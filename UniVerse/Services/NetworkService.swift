// Services/NetworkService.swift
import Foundation
import Supabase

class NetworkService {
    static let shared = NetworkService()

    private let client = SupabaseManager.shared.client

    private init() {}

    enum NetworkError: Error, LocalizedError {
        case invalidResponse
        case networkError(String)
        case followError(String)

        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "Respuesta inválida del servidor"
            case .networkError(let message):
                return "Error de red: \(message)"
            case .followError(let message):
                return "Error al seguir/dejar de seguir: \(message)"
            }
        }
    }

    // MARK: - Get Network Profiles

    /// Obtiene perfiles para la vista de red con filtros y búsqueda
    /// - Parameters:
    ///   - idPerfilVisitante: ID del perfil que está viendo la red
    ///   - tipoFiltro: Filtro por tipo de perfil
    ///   - busqueda: Texto de búsqueda
    ///   - limit: Número máximo de resultados
    ///   - offset: Offset para paginación
    /// - Returns: Array de PerfilRed
    func getPerfilesRed(
        idPerfilVisitante: Int? = nil,
        tipoFiltro: TipoFiltro = .todos,
        busqueda: String? = nil,
        limit: Int = 50,
        offset: Int = 0
    ) async throws -> [PerfilRed] {
        print("DEBUG NetworkService: getPerfilesRed called with visitante: \(idPerfilVisitante ?? -1), filtro: \(tipoFiltro.rawValue), busqueda: \(busqueda ?? "nil")")

        do {
            let response = try await client.rpc(
                "get_perfiles_red",
                params: [
                    "p_id_perfil_visitante": idPerfilVisitante.map { String($0) },
                    "p_tipo_filtro": tipoFiltro.rawValue,
                    "p_busqueda": busqueda,
                    "p_limit": String(limit),
                    "p_offset": String(offset)
                ]
            ).execute()

            print("DEBUG NetworkService: RPC get_perfiles_red response received")

            let decoder = JSONDecoder()
            let perfiles = try decoder.decode([PerfilRed].self, from: response.data)

            print("DEBUG NetworkService: Successfully decoded \(perfiles.count) profiles")
            return perfiles

        } catch let error as PostgrestError {
            print("DEBUG NetworkService: PostgrestError: \(error.localizedDescription)")
            throw NetworkError.networkError(error.localizedDescription)
        } catch {
            print("DEBUG NetworkService: General error: \(error.localizedDescription)")
            throw NetworkError.networkError(error.localizedDescription)
        }
    }

    // MARK: - Toggle Follow

    /// Toggle follow/unfollow entre perfiles
    /// - Parameters:
    ///   - idSeguidor: ID del perfil que sigue
    ///   - idSeguido: ID del perfil que es seguido
    /// - Returns: Estado final del seguimiento
    func toggleSeguir(idSeguidor: Int, idSeguido: Int) async throws -> Bool {
        print("DEBUG NetworkService: toggleSeguir called with seguidor: \(idSeguidor), seguido: \(idSeguido)")

        do {
            let response = try await client.rpc(
                "toggle_seguir",
                params: [
                    "p_id_seguidor": String(idSeguidor),
                    "p_id_seguido": String(idSeguido)
                ]
            ).execute()

            print("DEBUG NetworkService: RPC toggle_seguir response received")

            // Decodificar respuesta
            struct ToggleResponse: Codable {
                let success: Bool
                let message: String
                let esta_siguiendo: Bool
                let total_seguidores: Int
                let total_seguidos: Int
            }

            let decoder = JSONDecoder()
            let results = try decoder.decode([ToggleResponse].self, from: response.data)

            guard let result = results.first, result.success else {
                throw NetworkError.followError("Error al cambiar estado de seguimiento")
            }

            print("DEBUG NetworkService: Follow toggled - esta_siguiendo: \(result.esta_siguiendo)")
            return result.esta_siguiendo

        } catch let error as PostgrestError {
            print("DEBUG NetworkService: PostgrestError in toggleSeguir: \(error.localizedDescription)")
            throw NetworkError.networkError(error.localizedDescription)
        } catch {
            print("DEBUG NetworkService: General error in toggleSeguir: \(error.localizedDescription)")
            throw NetworkError.networkError(error.localizedDescription)
        }
    }
}
