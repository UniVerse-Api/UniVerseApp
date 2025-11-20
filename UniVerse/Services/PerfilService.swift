// Services/PerfilService.swift
import Foundation
import Supabase

class PerfilService: ObservableObject {
    private let client = SupabaseManager.shared.client
    
    enum PerfilError: Error, LocalizedError {
        case perfilNotFound
        case invalidResponse
        case networkError(String)
        case notStudent
        case inactiveProfile
        
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
            case .inactiveProfile:
                return "Este perfil no está disponible"
            }
        }
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
            
            // Decodificar la respuesta
            let perfilCompleto = try decoder.decode(PerfilCompletoResponse.self, from: data)
            print("DEBUG PerfilService: Successfully decoded perfil completo, success: \(perfilCompleto.success)")
            
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
        let perfilCompleto = try await getPerfilEstudiantePublico(idPerfil: idPerfil)
        
        guard let perfilBasico = perfilCompleto.perfilBasico else {
            throw PerfilError.invalidResponse
        }
        
        return perfilBasico
    }
}
