// Services/FeedService.swift
import Foundation
import Supabase

class FeedService: ObservableObject {
    private let client = SupabaseManager.shared.client
    
    enum FeedError: Error, LocalizedError {
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
    
    // MARK: - Feed Functions
    
    /// Obtiene el feed del usuario utilizando el RPC get_feed
    /// - Parameters:
    ///   - idPerfil: ID del perfil del usuario
    ///   - limit: Número máximo de elementos a obtener (por defecto 20)
    ///   - offset: Número de elementos a saltar para paginación (por defecto 0)
    /// - Returns: Array de FeedItem
    func getFeed(idPerfil: Int, limit: Int = 20, offset: Int = 0) async throws -> [FeedItem] {
        print("DEBUG FeedService: getFeed called with idPerfil: \(idPerfil), limit: \(limit), offset: \(offset)")
        do {
            print("DEBUG FeedService: Calling RPC get_feed...")
            let response = try await client.rpc(
                "get_feed",
                params: [
                    "p_id_perfil": idPerfil,
                    "p_limit": limit,
                    "p_offset": offset
                ]
            ).execute()
            
            print("DEBUG FeedService: RPC response received")
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
                    // Fallback a formato básico
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    if let date = dateFormatter.date(from: dateString) {
                        return date
                    }
                }
                
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "No se pudo decodificar la fecha: \(dateString)"
                )
            }
            
            print("DEBUG FeedService: Decoding JSON data...")
            let feedItems = try decoder.decode([FeedItem].self, from: data)
            print("DEBUG FeedService: Successfully decoded \(feedItems.count) feed items")
            return feedItems
            
        } catch let error as PostgrestError {
            print("DEBUG FeedService: PostgrestError: \(error.localizedDescription)")
            throw FeedError.networkError(error.localizedDescription)
        } catch {
            print("DEBUG FeedService: General error: \(error.localizedDescription)")
            throw FeedError.networkError(error.localizedDescription)
        }
    }
    
    /// Obtiene la primera página del feed
    /// - Parameter idPerfil: ID del perfil del usuario
    /// - Returns: Array de FeedItem
    func getInitialFeed(idPerfil: Int) async throws -> [FeedItem] {
        return try await getFeed(idPerfil: idPerfil, limit: 20, offset: 0)
    }
    
    /// Obtiene más elementos del feed para paginación infinita
    /// - Parameters:
    ///   - idPerfil: ID del perfil del usuario
    ///   - currentCount: Número actual de elementos en el feed
    /// - Returns: Array de FeedItem adicionales
    func loadMoreFeed(idPerfil: Int, currentCount: Int) async throws -> [FeedItem] {
        return try await getFeed(idPerfil: idPerfil, limit: 20, offset: currentCount)
    }
    
    /// Actualiza el feed completo (pull to refresh)
    /// - Parameter idPerfil: ID del perfil del usuario
    /// - Returns: Array de FeedItem actualizado
    func refreshFeed(idPerfil: Int) async throws -> [FeedItem] {
        return try await getInitialFeed(idPerfil: idPerfil)
    }
    
    // MARK: - Interaction Functions
    
    /// Da like a una publicación
    /// - Parameters:
    ///   - idPublicacion: ID de la publicación
    ///   - idPerfil: ID del perfil que da like
    func likePublicacion(idPublicacion: Int, idPerfil: Int) async throws {
        do {
            // Primero verificar si ya existe el like
            let existingLike = try await client
                .from("Like_publicacion")
                .select("*")
                .eq("id_publicacion", value: idPublicacion)
                .eq("id_perfil", value: idPerfil)
                .execute()
            
            let isEmpty = existingLike.data.isEmpty
            if isEmpty {
                // No existe, crear el like
                try await client
                    .from("Like_publicacion")
                    .insert([
                        "id_publicacion": idPublicacion,
                        "id_perfil": idPerfil
                    ])
                    .execute()
            } else {
                // Ya existe, remover el like
                try await client
                    .from("Like_publicacion")
                    .delete()
                    .eq("id_publicacion", value: idPublicacion)
                    .eq("id_perfil", value: idPerfil)
                    .execute()
            }
            
        } catch let error as PostgrestError {
            throw FeedError.networkError(error.localizedDescription)
        }
    }
    
    /// Guarda una publicación en favoritos
    /// - Parameters:
    ///   - idPublicacion: ID de la publicación
    ///   - idPerfil: ID del perfil que guarda
    func savePublicacion(idPublicacion: Int, idPerfil: Int) async throws {
        do {
            // Verificar si ya está guardada
            let existingSave = try await client
                .from("Publicacion_guardada")
                .select("*")
                .eq("id_publicacion", value: idPublicacion)
                .eq("id_perfil", value: idPerfil)
                .execute()
            
            let isEmpty = existingSave.data.isEmpty
            if isEmpty {
                // No existe, guardar la publicación
                try await client
                    .from("Publicacion_guardada")
                    .insert([
                        "id_publicacion": idPublicacion,
                        "id_perfil": idPerfil
                    ])
                    .execute()
            } else {
                // Ya existe, remover de guardados
                try await client
                    .from("Publicacion_guardada")
                    .delete()
                    .eq("id_publicacion", value: idPublicacion)
                    .eq("id_perfil", value: idPerfil)
                    .execute()
            }
            
        } catch let error as PostgrestError {
            throw FeedError.networkError(error.localizedDescription)
        }
    }
    
    /// Incrementa el contador de vistas de un anuncio
    /// - Parameter idAnuncio: ID del anuncio
    func incrementVistaAnuncio(idAnuncio: Int) async throws {
        do {
            try await client.rpc(
                "incrementar_vista_anuncio",
                params: ["p_id_anuncio": idAnuncio]
            ).execute()
            
        } catch let error as PostgrestError {
            throw FeedError.networkError(error.localizedDescription)
        }
    }
    
    // MARK: - Helper Functions
    
    /// Valida si un perfil existe
    /// - Parameter idPerfil: ID del perfil a validar
    /// - Returns: Bool indicando si existe
    func validateProfile(idPerfil: Int) async throws -> Bool {
        do {
            let response = try await client
                .from("Perfil")
                .select("id_perfil")
                .eq("id_perfil", value: idPerfil)
                .execute()
            
            return !response.data.isEmpty
            
        } catch let error as PostgrestError {
            throw FeedError.networkError(error.localizedDescription)
        }
    }
}