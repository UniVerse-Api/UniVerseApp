// Models/NetworkModels.swift
import Foundation

// MARK: - PerfilRed
struct PerfilRed: Identifiable, Codable {
    let id: Int
    let nombreCompleto: String
    let fotoPerfil: String?
    let biografia: String
    let tipoPerfil: String // "estudiante" | "empresa" | "universidad"
    let ubicacion: String?
    let pais: String?
    let esPremium: Bool
    var sigoAEstePerfil: Bool
    var seguidoresCount: Int
    let siguiendoCount: Int

    var idPerfil: Int { id }

    enum CodingKeys: String, CodingKey {
        case id = "id_perfil"
        case nombreCompleto = "nombre_completo"
        case fotoPerfil = "foto_perfil"
        case biografia
        case tipoPerfil = "tipo_perfil"
        case ubicacion
        case pais
        case esPremium = "es_premium"
        case sigoAEstePerfil = "sigo_a_este_perfil"
        case seguidoresCount = "seguidores_count"
        case siguiendoCount = "siguiendo_count"
    }
}

// MARK: - TipoFiltro
enum TipoFiltro: String, CaseIterable, Identifiable {
    case todos = "todos"
    case estudiantes = "estudiantes"
    case empresas = "empresas"

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .todos: return "Todos"
        case .estudiantes: return "Estudiantes"
        case .empresas: return "Empresas"
        }
    }
}
