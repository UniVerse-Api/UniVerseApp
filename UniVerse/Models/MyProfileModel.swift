import Foundation

struct MyProfileResponse: Codable {
    let success: Bool
    let perfil: MyProfileInfo?
    let suscripcion: MyProfileSubscription?
    let estadisticas: MyProfileStats?
    let certificaciones: [MyProfileCertification]?
    let progreso: MyProfileProgress?
    let actividadReciente: [MyProfileActivity]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case perfil
        case suscripcion
        case estadisticas
        case certificaciones
        case progreso
        case actividadReciente = "actividad_reciente"
    }
}

struct MyProfileInfo: Codable {
    let idPerfil: Int
    let nombreCompleto: String
    let fotoPerfil: String?
    let ubicacion: String
    let pais: String
    let universidadActual: String?
    let carrera: String?
    
    enum CodingKeys: String, CodingKey {
        case idPerfil = "id_perfil"
        case nombreCompleto = "nombre_completo"
        case fotoPerfil = "foto_perfil"
        case ubicacion
        case pais
        case universidadActual = "universidad_actual"
        case carrera
    }
}

struct MyProfileSubscription: Codable {
    let esPremium: Bool
    let plan: String
    
    enum CodingKeys: String, CodingKey {
        case esPremium = "es_premium"
        case plan
    }
}

struct MyProfileStats: Codable {
    let seguidores: Int
    let siguiendo: Int
    let publicaciones: Int
    let guardados: Int
}

struct MyProfileCertification: Codable, Identifiable {
    let id: Int
    let titulo: String
    let institucion: String
    let imagen: String
    let fecha: String
}

struct MyProfileProgress: Codable {
    let habilidadesCount: Int
    let certificacionesCount: Int
    let idiomasCount: Int
    
    enum CodingKeys: String, CodingKey {
        case habilidadesCount = "habilidades_count"
        case certificacionesCount = "certificaciones_count"
        case idiomasCount = "idiomas_count"
    }
}

struct MyProfileActivity: Codable, Identifiable {
    let id: Int
    let titulo: String
    let fecha: String
    let tipo: String
}
