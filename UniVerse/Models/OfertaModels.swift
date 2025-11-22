// Models/OfertaModels.swift
import Foundation

// MARK: - Oferta Estudiante
struct OfertaEstudiante: Identifiable, Codable {
    let id: Int
    let titulo: String
    let descripcion: String
    let salarioRango: String
    let tipoOferta: TipoOferta
    let ubicacion: String
    let fechaPublicacion: Date
    let fechaLimite: Date?
    let idPerfilEmpresa: Int
    let nombreCompleto: String
    let fotoPerfil: String?
    let ubicacionEmpresa: String
    let requisitos: [String]
    let esPremium: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "oferta_id"
        case titulo = "oferta_titulo"
        case descripcion = "oferta_descripcion"
        case salarioRango = "oferta_salario_rango"
        case tipoOferta = "oferta_tipo"
        case ubicacion = "oferta_ubicacion"
        case fechaPublicacion = "oferta_fecha_publicacion"
        case fechaLimite = "oferta_fecha_limite"
        case idPerfilEmpresa = "id_perfil_empresa"
        case nombreCompleto = "empresa_nombre_completo"
        case fotoPerfil = "empresa_foto_perfil"
        case ubicacionEmpresa = "empresa_ubicacion"
        case requisitos
        case esPremium = "es_premium"
    }
}

// MARK: - Tipo Oferta Enum
enum TipoOferta: String, Codable, CaseIterable {
    case tiempoCompleto = "tiempo_completo"
    case medioTiempo = "medio_tiempo"
    case pasantia = "pasantia"
    
    var displayName: String {
        switch self {
        case .tiempoCompleto:
            return "Tiempo Completo"
        case .medioTiempo:
            return "Medio Tiempo"
        case .pasantia:
            return "Pasantía"
        }
    }
    
    var filterName: String {
        switch self {
        case .tiempoCompleto:
            return "Tiempo Completo"
        case .medioTiempo:
            return "Remoto"
        case .pasantia:
            return "Pasantías"
        }
    }
}

// MARK: - Aplicacion Estudiante
struct AplicacionEstudiante: Identifiable, Codable {
    let id: Int
    let idOferta: Int
    let titulo: String
    let nombreEmpresa: String
    let fotoPerfil: String?
    let ubicacion: String
    let tipoOferta: TipoOferta
    let status: StatusAplicacion
    let fechaAplicacion: Date
    let esActiva: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id_aplicacion"
        case idOferta = "id_oferta"
        case titulo
        case nombreEmpresa = "nombre_empresa"
        case fotoPerfil = "foto_perfil"
        case ubicacion
        case tipoOferta = "tipo_oferta"
        case status
        case fechaAplicacion = "fecha_aplicacion"
        case esActiva = "es_activa"
    }
}

// MARK: - Status Aplicacion Enum
enum StatusAplicacion: String, Codable {
    case pendiente
    case revisado
    case rechazado
    case aceptado
    
    var displayName: String {
        switch self {
        case .pendiente:
            return "En Revisión"
        case .revisado:
            return "Revisado"
        case .rechazado:
            return "No Seleccionado"
        case .aceptado:
            return "Aceptado"
        }
    }
    
    var color: String {
        switch self {
        case .pendiente:
            return "yellow"
        case .revisado:
            return "blue"
        case .rechazado:
            return "red"
        case .aceptado:
            return "green"
        }
    }
    
    var icon: String {
        switch self {
        case .pendiente:
            return "clock.fill"
        case .revisado:
            return "eye.fill"
        case .rechazado:
            return "xmark.circle.fill"
        case .aceptado:
            return "checkmark.circle.fill"
        }
    }
}
