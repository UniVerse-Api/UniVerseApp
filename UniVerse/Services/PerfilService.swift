// Services/PerfilService.swift
import Foundation
import Supabase

class PerfilService: ObservableObject {
    private let client = SupabaseManager.shared.client
    
    enum PerfilError: Error, LocalizedError, Equatable {
        case perfilNotFound
        case invalidResponse
        case networkError(String)
        case notStudent
        case notCompany
        case inactiveProfile
        case unsupportedRole
        
        var errorDescription: String? {
            switch self {
            case .perfilNotFound:
                return "Perfil no encontrado"
            case .invalidResponse:
                return "Respuesta inválida del servidor"
            case .networkError(let message):
                return "Error de red: \(message)"
            case .notStudent:
                return "Este perfil no corresponde a un estudiante"
            case .notCompany:
                return "Este perfil no corresponde a una empresa"
            case .inactiveProfile:
                return "Este perfil no está disponible"
            case .unsupportedRole:
                return "Tipo de perfil no soportado"
            }
        }
    }
    
    enum TipoPerfil: String, CaseIterable {
        case estudiante = "estudiante"
        case empresa = "empresa"
        case universidad = "universidad"
    }
    
    /// Obtiene el perfil completo de un estudiante usando el RPC get_perfil_estudiante_completo
    /// - Parameters:
    ///   - idPerfil: ID del perfil del estudiante a obtener
    ///   - idPerfilVisitante: ID del perfil del visitante (opcional, para verificar seguimiento y favoritos)
    /// - Returns: PerfilCompletoResponse con toda la información del estudiante
    func getPerfilEstudianteCompleto(idPerfil: Int, idPerfilVisitante: Int? = nil) async throws -> PerfilCompletoResponse {
        print("DEBUG PerfilService: getPerfilEstudianteCompleto called with idPerfil: \(idPerfil), idPerfilVisitante: \(idPerfilVisitante ?? -1)")
        
        do {
            // Crear parámetros con tipos específicos para RPC
            struct RPCParams: Codable {
                let p_id_perfil: Int
                let p_id_perfil_visitante: Int?
            }
            
            let params = RPCParams(
                p_id_perfil: idPerfil,
                p_id_perfil_visitante: idPerfilVisitante
            )
            
            print("DEBUG PerfilService: Calling RPC get_perfil_estudiante_completo with params: \(params)")
            
            let response = try await client.rpc(
                "get_perfil_estudiante_completo",
                params: params
            ).execute()
            
            print("DEBUG PerfilService: RPC response received")
            let data = response.data
            let decoder = JSONDecoder()
            
            // Configurar el decodificador para fechas
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            let iso8601Formatter = ISO8601DateFormatter()
            iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                // Intentar diferentes formatos de fecha
                if let date = iso8601Formatter.date(from: dateString) {
                    return date
                } else if let date = dateFormatter.date(from: dateString) {
                    return date
                } else {
                    // Formato de fecha simple YYYY-MM-DD
                    let simpleDateFormatter = DateFormatter()
                    simpleDateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date = simpleDateFormatter.date(from: dateString) {
                        return date
                    }
                }
                
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot parse date: \(dateString)")
            }
            
            print("DEBUG PerfilService: Decoding JSON data...")
            
            // Intentar decodificar como array primero (caso común con RPCs de Supabase)
            let perfilCompleto: PerfilCompletoResponse
            do {
                // Intentar como array primero
                let arrayResponse = try decoder.decode([PerfilCompletoResponse].self, from: data)
                guard let firstItem = arrayResponse.first else {
                    print("DEBUG PerfilService: Array response is empty")
                    throw PerfilError.invalidResponse
                }
                perfilCompleto = firstItem
                print("DEBUG PerfilService: Successfully decoded perfil estudiante from array")
            } catch {
                // Si falla, intentar como objeto único
                print("DEBUG PerfilService: Array decode failed, trying single object: \(error)")
                perfilCompleto = try decoder.decode(PerfilCompletoResponse.self, from: data)
                print("DEBUG PerfilService: Successfully decoded perfil estudiante as single object")
            }
            
            print("DEBUG PerfilService: Perfil estudiante success: \(perfilCompleto.success)")
            
            // Verificar si la respuesta indica éxito
            if !perfilCompleto.success {
                if let message = perfilCompleto.message {
                    if message.contains("no encontrado") {
                        throw PerfilError.perfilNotFound
                    } else if message.contains("no corresponde a un estudiante") {
                        throw PerfilError.notStudent
                    } else if message.contains("no está disponible") {
                        throw PerfilError.inactiveProfile
                    } else {
                        throw PerfilError.networkError(message)
                    }
                } else {
                    throw PerfilError.invalidResponse
                }
            }
            
            return perfilCompleto
            
        } catch let error as PostgrestError {
            print("DEBUG PerfilService: PostgrestError: \(error.localizedDescription)")
            throw PerfilError.networkError(error.localizedDescription)
        } catch let error as PerfilError {
            // Re-lanzar errores ya procesados
            throw error
        } catch {
            print("DEBUG PerfilService: General error: \(error.localizedDescription)")
            throw PerfilError.networkError(error.localizedDescription)
        }
    }
    
    /// Obtiene el perfil completo de un estudiante sin información de visitante
    /// - Parameter idPerfil: ID del perfil del estudiante a obtener
    /// - Returns: PerfilCompletoResponse con la información pública del estudiante
    func getPerfilEstudiantePublico(idPerfil: Int) async throws -> PerfilCompletoResponse {
        return try await getPerfilEstudianteCompleto(idPerfil: idPerfil, idPerfilVisitante: nil)
    }
    
    /// Valida si un perfil existe y es de un estudiante
    /// - Parameter idPerfil: ID del perfil a validar
    /// - Returns: Bool indicando si es un perfil válido de estudiante
    func validateEstudiantePerfil(idPerfil: Int) async throws -> Bool {
        do {
            let perfil = try await getPerfilEstudiantePublico(idPerfil: idPerfil)
            return perfil.success && perfil.perfilBasico?.rol == "estudiante"
        } catch {
            return false
        }
    }
    
    /// Obtiene información básica de un perfil para mostrar en listas
    /// - Parameter idPerfil: ID del perfil
    /// - Returns: PerfilBasico con la información esencial
    func getPerfilBasico(idPerfil: Int) async throws -> PerfilBasico {
        let (_, resultado) = try await getPerfilCompletoAuto(idPerfil: idPerfil)
        
        if let perfilEstudiante = resultado as? PerfilCompletoResponse {
            guard let perfilBasico = perfilEstudiante.perfilBasico else {
                throw PerfilError.invalidResponse
            }
            return perfilBasico
        } else if let perfilEmpresa = resultado as? PerfilEmpresaResponse {
            guard let perfilBasico = perfilEmpresa.perfilBasico else {
                throw PerfilError.invalidResponse
            }
            return perfilBasico
        } else {
            throw PerfilError.invalidResponse
        }
    }
    
    // MARK: - Empresa Methods
    
    /// Obtiene el perfil completo de una empresa usando el RPC get_profile_empresa
    /// - Parameters:
    ///   - idPerfil: ID del perfil de la empresa a obtener
    ///   - idPerfilVisitante: ID del perfil del visitante (opcional, para verificar seguimiento y favoritos)
    /// - Returns: PerfilEmpresaResponse con toda la información de la empresa
    func getPerfilEmpresaCompleto(idPerfil: Int, idPerfilVisitante: Int? = nil) async throws -> PerfilEmpresaResponse {
        print("DEBUG PerfilService: getPerfilEmpresaCompleto called with idPerfil: \(idPerfil), idPerfilVisitante: \(idPerfilVisitante ?? -1)")
        
        do {
            // Crear parámetros con tipos específicos para RPC
            struct RPCParams: Codable {
                let p_id_perfil: Int
                let p_id_perfil_visitante: Int?
            }
            
            let params = RPCParams(
                p_id_perfil: idPerfil,
                p_id_perfil_visitante: idPerfilVisitante
            )
            
            print("DEBUG PerfilService: Calling RPC get_profile_empresa with params: \(params)")
            
            let response = try await client.rpc(
                "get_profile_empresa",
                params: params
            ).execute()
            
            print("DEBUG PerfilService: RPC response received")
            let data = response.data
            
            // Debug: Imprimir datos crudos
            if let jsonString = String(data: data, encoding: .utf8) {
                print("DEBUG PerfilService: Raw empresa response data: \(jsonString)")
            } else {
                print("DEBUG PerfilService: Could not convert empresa response data to string")
            }
            
            // Verificar si los datos están vacíos
            if data.isEmpty {
                print("DEBUG PerfilService: Empresa response data is empty")
                throw PerfilError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            
            // Configurar el decodificador para fechas
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            let iso8601Formatter = ISO8601DateFormatter()
            iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                // Intentar diferentes formatos de fecha
                if let date = iso8601Formatter.date(from: dateString) {
                    return date
                } else if let date = dateFormatter.date(from: dateString) {
                    return date
                } else {
                    // Formato de fecha simple YYYY-MM-DD
                    let simpleDateFormatter = DateFormatter()
                    simpleDateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date = simpleDateFormatter.date(from: dateString) {
                        return date
                    }
                }
                
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot parse date: \(dateString)")
            }
            
            print("DEBUG PerfilService: Decoding JSON data...")
            
            // Intentar decodificar como array primero (caso común con RPCs de Supabase)
            let perfilEmpresa: PerfilEmpresaResponse
            do {
                // Intentar como array primero
                let arrayResponse = try decoder.decode([PerfilEmpresaResponse].self, from: data)
                guard let firstItem = arrayResponse.first else {
                    print("DEBUG PerfilService: Array response is empty")
                    throw PerfilError.invalidResponse
                }
                perfilEmpresa = firstItem
                print("DEBUG PerfilService: Successfully decoded perfil empresa from array")
            } catch {
                // Si falla, intentar como objeto único
                print("DEBUG PerfilService: Array decode failed, trying single object: \(error)")
                perfilEmpresa = try decoder.decode(PerfilEmpresaResponse.self, from: data)
                print("DEBUG PerfilService: Successfully decoded perfil empresa as single object")
            }
            
            print("DEBUG PerfilService: Perfil empresa success: \(perfilEmpresa.success)")
            
            // Verificar si la respuesta indica éxito
            if !perfilEmpresa.success {
                if let message = perfilEmpresa.message {
                    if message.contains("no encontrado") {
                        throw PerfilError.perfilNotFound
                    } else if message.contains("no corresponde a una empresa") {
                        throw PerfilError.notCompany
                    } else if message.contains("no está disponible") {
                        throw PerfilError.inactiveProfile
                    } else {
                        throw PerfilError.networkError(message)
                    }
                } else {
                    throw PerfilError.invalidResponse
                }
            }
            
            return perfilEmpresa
            
        } catch let error as PostgrestError {
            print("DEBUG PerfilService: PostgrestError: \(error.localizedDescription)")
            throw PerfilError.networkError(error.localizedDescription)
        } catch let error as PerfilError {
            // Re-lanzar errores ya procesados
            throw error
        } catch {
            print("DEBUG PerfilService: General error: \(error.localizedDescription)")
            throw PerfilError.networkError(error.localizedDescription)
        }
    }
    
    /// Obtiene el perfil completo de una empresa sin información de visitante
    /// - Parameter idPerfil: ID del perfil de la empresa a obtener
    /// - Returns: PerfilEmpresaResponse con la información pública de la empresa
    func getPerfilEmpresaPublico(idPerfil: Int) async throws -> PerfilEmpresaResponse {
        return try await getPerfilEmpresaCompleto(idPerfil: idPerfil, idPerfilVisitante: nil)
    }
    
    // MARK: - Generic Profile Methods
    
    /// Detecta el tipo de perfil basándose en el campo esEmpresa del FeedItem
    /// - Parameter idPerfil: ID del perfil a detectar
    /// - Returns: TipoPerfil del perfil
    func detectarTipoPerfil(idPerfil: Int) async throws -> TipoPerfil {
        print("DEBUG PerfilService: detectarTipoPerfil called with idPerfil: \(idPerfil)")
        
        // Primero intentar como estudiante
        do {
            _ = try await getPerfilEstudianteCompleto(idPerfil: idPerfil, idPerfilVisitante: nil)
            print("DEBUG PerfilService: Detected as estudiante")
            return .estudiante
        } catch let error as PerfilError {
            if error == .notStudent {
                // Si no es estudiante, intentar como empresa
                do {
                    _ = try await getPerfilEmpresaCompleto(idPerfil: idPerfil, idPerfilVisitante: nil)
                    print("DEBUG PerfilService: Detected as empresa")
                    return .empresa
                } catch {
                    print("DEBUG PerfilService: Not empresa either: \(error.localizedDescription)")
                    throw PerfilError.unsupportedRole
                }
            } else {
                throw error
            }
        } catch {
            throw PerfilError.networkError(error.localizedDescription)
        }
    }
    
    /// Obtiene el perfil completo basado en el tipo automáticamente detectado
    /// - Parameters:
    ///   - idPerfil: ID del perfil a obtener
    ///   - idPerfilVisitante: ID del perfil del visitante (opcional)
    /// - Returns: Tuple con el tipo de perfil y la respuesta correspondiente
    func getPerfilCompletoAuto(idPerfil: Int, idPerfilVisitante: Int? = nil) async throws -> (TipoPerfil, Any) {
        print("DEBUG PerfilService: getPerfilCompletoAuto called with idPerfil: \(idPerfil)")
        
        // Detectar tipo de perfil
        let tipoPerfil = try await detectarTipoPerfil(idPerfil: idPerfil)
        
        // Obtener perfil según el tipo
        switch tipoPerfil {
        case .estudiante:
            let perfil = try await getPerfilEstudianteCompleto(idPerfil: idPerfil, idPerfilVisitante: idPerfilVisitante)
            return (tipoPerfil, perfil)
            
        case .empresa:
            let perfil = try await getPerfilEmpresaCompleto(idPerfil: idPerfil, idPerfilVisitante: idPerfilVisitante)
            return (tipoPerfil, perfil)
            
        case .universidad:
            // Por ahora no implementado, se puede agregar más tarde
            throw PerfilError.unsupportedRole
        }
    }
    
    
    // MARK: - My Profile Method
    
    /// Obtiene el perfil del usuario actual usando el RPC get_myprof
    /// - Parameter userId: UUID del usuario
    /// - Returns: MyProfileResponse con la información del perfil
    func getMyProfile(userId: UUID) async throws -> MyProfileResponse {
        print("DEBUG PerfilService: getMyProfile called with userId: \(userId)")
        
        struct Params: Codable {
            let p_user_id: UUID
        }
        
        let params = Params(p_user_id: userId)
        
        let response = try await client.rpc("get_myprof", params: params).execute()
        
        let data = response.data
        let decoder = JSONDecoder()
        
        // Configurar el decodificador para fechas si es necesario, aunque el RPC devuelve strings
        // Si el RPC devuelve fechas en formato ISO, esto ayudará
        
        return try decoder.decode(MyProfileResponse.self, from: data)
    }
    
    // MARK: - Certification Methods
    
    /// Estructura para la respuesta del RPC agregar_certificacion
    struct AgregarCertificacionResponse: Codable {
        let success: Bool
        let message: String
        let idCertificacion: Int?
        let imagen: String?
        
        enum CodingKeys: String, CodingKey {
            case success
            case message
            case idCertificacion = "id_certificacion"
            case imagen
        }
    }
    
    /// Agrega una nueva certificación al perfil usando el RPC agregar_certificacion
    /// - Parameters:
    ///   - idPerfil: ID del perfil al que agregar la certificación
    ///   - titulo: Título de la certificación
    ///   - institucion: Institución que otorga la certificación
    ///   - fechaObtencion: Fecha de obtención de la certificación
    /// - Returns: AgregarCertificacionResponse con el resultado de la operación
    func agregarCertificacion(
        idPerfil: Int,
        titulo: String,
        institucion: String,
        fechaObtencion: Date
    ) async throws -> AgregarCertificacionResponse {
        print("DEBUG PerfilService: agregarCertificacion called with idPerfil: \(idPerfil), titulo: \(titulo), institucion: \(institucion)")
        
        struct RPCParams: Codable {
            let p_id_perfil: Int
            let p_titulo: String
            let p_institucion: String
            let p_fecha_obtencion: String
        }
        
        // Formatear la fecha para PostgreSQL
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fechaString = dateFormatter.string(from: fechaObtencion)
        
        let params = RPCParams(
            p_id_perfil: idPerfil,
            p_titulo: titulo,
            p_institucion: institucion,
            p_fecha_obtencion: fechaString
        )
        
        do {
            print("DEBUG PerfilService: Calling RPC agregar_certificacion with params: \(params)")
            
            let response = try await client.rpc(
                "agregar_certificacion",
                params: params
            ).execute()
            
            let data = response.data
            let decoder = JSONDecoder()
            
            print("DEBUG PerfilService: RPC agregar_certificacion response received")
            
            // Intentar decodificar como array primero (caso común con RPCs de Supabase)
            do {
                let responseArray = try decoder.decode([AgregarCertificacionResponse].self, from: data)
                guard let firstResponse = responseArray.first else {
                    throw PerfilError.invalidResponse
                }
                print("DEBUG PerfilService: Successfully decoded from array")
                return firstResponse
            } catch {
                // Si falla, intentar como objeto directo
                let response = try decoder.decode(AgregarCertificacionResponse.self, from: data)
                print("DEBUG PerfilService: Successfully decoded as direct object")
                return response
            }
            
        } catch let error as PostgrestError {
            print("DEBUG PerfilService: PostgrestError: \(error.localizedDescription)")
            throw PerfilError.networkError(error.localizedDescription)
        } catch {
            print("DEBUG PerfilService: General error: \(error.localizedDescription)")
            throw PerfilError.networkError(error.localizedDescription)
        }
    }
}
