import Foundation

// MARK: - Experience Models

struct ExperienciaLaboralResponse: Codable {
    let success: Bool
    let experiencias: [ExperienciaLaboralItem]?
    let message: String?
}

struct ExperienciaLaboralItem: Codable, Identifiable {
    let id: Int
    let empresa: String
    let tipo: TipoExperienciaLaboral
    let puesto: String
    let fechaInicio: String
    let fechaFin: String?
    let descripcion: String?
    let ubicacion: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_experiencia"
        case empresa
        case tipo
        case puesto
        case fechaInicio = "fecha_inicio"
        case fechaFin = "fecha_fin"
        case descripcion
        case ubicacion
    }
}

enum TipoExperienciaLaboral: String, CaseIterable, Codable {
    case pasantia = "pasantia"
    case tiempoCompleto = "tiempo_completo"
    case medioTiempo = "medio_tiempo"
    case voluntariado = "voluntariado"
    
    var displayName: String {
        switch self {
        case .pasantia:
            return "Pasantía"
        case .tiempoCompleto:
            return "Tiempo Completo"
        case .medioTiempo:
            return "Medio Tiempo"
        case .voluntariado:
            return "Voluntariado"
        }
    }
    
    var icon: String {
        switch self {
        case .pasantia:
            return "graduationcap.fill"
        case .tiempoCompleto:
            return "briefcase.fill"
        case .medioTiempo:
            return "clock.fill"
        case .voluntariado:
            return "heart.fill"
        }
    }
    
    var color: String {
        switch self {
        case .pasantia:
            return "blue"
        case .tiempoCompleto:
            return "green"
        case .medioTiempo:
            return "orange"
        case .voluntariado:
            return "red"
        }
    }
}

struct AgregarExperienciaLaboralResponse: Codable {
    let success: Bool
    let message: String
    let idExperiencia: Int?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case idExperiencia = "id_experiencia"
    }
}
