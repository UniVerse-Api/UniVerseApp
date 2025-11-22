// Services/PostService.swift
import Foundation
import Supabase

class PostService {
    static let shared = PostService()

    private let client = SupabaseManager.shared.client

    private init() {}

    enum PostError: Error, LocalizedError {
        case invalidResponse
        case networkError(String)
        case creationFailed(String)

        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "Respuesta inválida del servidor"
            case .networkError(let message):
                return "Error de red: \(message)"
            case .creationFailed(let message):
                return "Error al crear publicación: \(message)"
            }
        }
    }

    // MARK: - Create Publication

    /// Crea una nueva publicación usando la función RPC crear_publicacion
    /// - Parameters:
    ///   - idPerfil: ID del perfil que crea la publicación
    ///   - titulo: Título de la publicación
    ///   - descripcion: Descripción de la publicación
    ///   - urlRecurso: URL opcional del recurso (imagen)
    /// - Returns: ID de la publicación creada
    func createPublication(idPerfil: Int, titulo: String, descripcion: String, urlRecurso: String? = nil) async throws -> Int {
        print("DEBUG PostService: createPublication called with idPerfil: \(idPerfil), titulo: \(titulo)")

        do {
            let response = try await client.rpc(
                "crear_publicacion",
                params: [
                    "p_id_perfil": String(idPerfil),
                    "p_titulo": titulo,
                    "p_descripcion": descripcion,
                    "p_url_recurso": urlRecurso
                ]
            ).execute()

            print("DEBUG PostService: RPC crear_publicacion response received")

            // Decodificar la respuesta
            struct CreateResponse: Codable {
                let success: Bool
                let message: String
                let data: PublicationData?
                let error_code: String?

                struct PublicationData: Codable {
                    let id_publicacion: Int
                    let id_perfil: Int
                    let titulo: String
                    let fecha_publicacion: String
                    let tiene_recurso: Bool
                    let publicaciones_restantes_hoy: Int
                    let plan_id: Int
                }
            }

            let decoder = JSONDecoder()
            let createResult = try decoder.decode(CreateResponse.self, from: response.data)

            if createResult.success, let data = createResult.data {
                print("DEBUG PostService: Publication created successfully with ID: \(data.id_publicacion)")
                return data.id_publicacion
            } else {
                let errorMessage = createResult.message
                print("DEBUG PostService: Failed to create publication: \(errorMessage)")
                throw PostError.creationFailed(errorMessage)
            }

        } catch let error as PostgrestError {
            print("DEBUG PostService: PostgrestError: \(error.localizedDescription)")
            throw PostError.networkError(error.localizedDescription)
        } catch {
            print("DEBUG PostService: General error: \(error.localizedDescription)")
            throw PostError.networkError(error.localizedDescription)
        }
    }
}
