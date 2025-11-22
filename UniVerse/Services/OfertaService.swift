// Services/OfertaService.swift
import Foundation
import Supabase

class OfertaService: ObservableObject {
    private let client = SupabaseManager.shared.client
    
    enum OfertaError: Error, LocalizedError {
        case noUserProfile
        case invalidResponse
        case networkError(String)
        
        var errorDescription: String? {
            switch self {
            case .noUserProfile:
                return "No se encontró el perfil del usuario"
            case .invalidResponse:
                return "Respuesta inválida del servidor"
            case .networkError(let message):
                return "Error de red: \(message)"
            }
        }
    }
    
    /// Obtiene las ofertas de empleo activas
    /// - Returns: Array de OfertaEstudiante
    func getOfertasActivas() async throws -> [OfertaEstudiante] {
        print("DEBUG OfertaService: getOfertasActivas called")
        
        do {
            let response = try await client.rpc("get_ofertas_estudiante").execute()
            let data = response.data
            
            let decoder = JSONDecoder()
            
            // Configurar decodificación de fechas
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
                
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(dateString)"
                )
            }
            
            let ofertas = try decoder.decode([OfertaEstudiante].self, from: data)
            print("DEBUG OfertaService: Successfully decoded \(ofertas.count) ofertas")
            return ofertas
            
        } catch let error as PostgrestError {
            print("DEBUG OfertaService: PostgrestError: \(error.localizedDescription)")
            throw OfertaError.networkError(error.localizedDescription)
        } catch {
            print("DEBUG OfertaService: General error: \(error.localizedDescription)")
            throw OfertaError.networkError(error.localizedDescription)
        }
    }
    
    /// Obtiene las aplicaciones del estudiante
    /// - Parameter idPerfil: ID del perfil del estudiante
    /// - Returns: Array de AplicacionEstudiante
    func getAplicaciones(idPerfil: Int) async throws -> [AplicacionEstudiante] {
        print("DEBUG OfertaService: getAplicaciones called for perfil: \(idPerfil)")
        
        do {
            let response = try await client.rpc(
                "get_aplicaciones_estudiante",
                params: ["p_id_perfil": idPerfil]
            ).execute()
            let data = response.data
            
            // DEBUG: Ver el JSON crudo
            if let jsonString = String(data: data, encoding: .utf8) {
                print("DEBUG OfertaService: Raw aplicaciones JSON: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            
            // Configurar decodificación de fechas para timestamps de PostgreSQL
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                // Formato: "2025-11-22T00:24:59.524047"
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                if let date = formatter.date(from: dateString) {
                    return date
                }
                
                // Intentar sin microsegundos
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                if let date = formatter.date(from: dateString) {
                    return date
                }
                
                // Intentar formato ISO8601 estándar
                let iso8601Formatter = ISO8601DateFormatter()
                iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                if let date = iso8601Formatter.date(from: dateString) {
                    return date
                }
                
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(dateString)"
                )
            }
            
            let aplicaciones = try decoder.decode([AplicacionEstudiante].self, from: data)
            print("DEBUG OfertaService: Successfully decoded \(aplicaciones.count) aplicaciones")
            return aplicaciones
            
        } catch let error as PostgrestError {
            print("DEBUG OfertaService: PostgrestError: \(error.localizedDescription)")
            throw OfertaError.networkError(error.localizedDescription)
        } catch let decodingError as DecodingError {
            print("DEBUG OfertaService: DecodingError: \(decodingError)")
            throw OfertaError.networkError(decodingError.localizedDescription)
        } catch {
            print("DEBUG OfertaService: General error: \(error.localizedDescription)")
            throw OfertaError.networkError(error.localizedDescription)
        }
    }
}
