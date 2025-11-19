// Models/FeedItem.swift
import Foundation

struct FeedItem: Identifiable, Codable, Equatable {
    let tipo: String // 'publicacion' o 'anuncio'
    let id: Int
    let idPerfil: Int
    let nombreCompleto: String
    let fotoPerfil: String?
    let titulo: String?
    let descripcion: String
    var likesContador: Int? // Cambiado a var para poder actualizarlo
    let comentariosContador: Int?
    let fechaPublicacion: Date
    let recursos: [RecursoItem]
    let esSeguido: Bool
    let esFavorito: Bool
    let esDestacado: Bool
    let vistaContador: Int?
    let fechaInicio: Date?
    let fechaFin: Date?
    
    // Estado local para el like del usuario actual (no viene de la DB)
    var tieneLikeUsuario: Bool = false
    
    // Computed property para usar como identificador en SwiftUI
    var uniqueId: String {
        "\(tipo)_\(id)"
    }
    
    // Para determinar si es una publicación o anuncio
    var esPublicacion: Bool {
        tipo == "publicacion"
    }
    
    var esAnuncio: Bool {
        tipo == "anuncio"
    }
    
    enum CodingKeys: String, CodingKey {
        case tipo
        case id
        case idPerfil = "id_perfil"
        case nombreCompleto = "nombre_completo"
        case fotoPerfil = "foto_perfil"
        case titulo
        case descripcion
        case likesContador = "likes_contador"
        case comentariosContador = "comentarios_contador"
        case fechaPublicacion = "fecha_publicacion"
        case recursos
        case esSeguido = "es_seguido"
        case esFavorito = "es_favorito"
        case esDestacado = "es_destacado"
        case vistaContador = "vista_contador"
        case fechaInicio = "fecha_inicio"
        case fechaFin = "fecha_fin"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tipo = try container.decode(String.self, forKey: .tipo)
        id = try container.decode(Int.self, forKey: .id)
        idPerfil = try container.decode(Int.self, forKey: .idPerfil)
        nombreCompleto = try container.decode(String.self, forKey: .nombreCompleto)
        fotoPerfil = try container.decodeIfPresent(String.self, forKey: .fotoPerfil)
        titulo = try container.decodeIfPresent(String.self, forKey: .titulo)
        descripcion = try container.decode(String.self, forKey: .descripcion)
        likesContador = try container.decodeIfPresent(Int.self, forKey: .likesContador)
        comentariosContador = try container.decodeIfPresent(Int.self, forKey: .comentariosContador)
        
        // Manejar la fecha que viene como string desde PostgreSQL
        let fechaString = try container.decode(String.self, forKey: .fechaPublicacion)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: fechaString) {
            fechaPublicacion = date
        } else {
            // Fallback format
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            fechaPublicacion = fallbackFormatter.date(from: fechaString) ?? Date()
        }
        
        // Decodificar recursos - simplificado para evitar problemas con JSONB
        if let recursosContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .recursos) {
            // Si recursos viene como objeto JSONB anidado
            recursos = []
        } else if let recursosArray = try? container.decode([RecursoItem].self, forKey: .recursos) {
            // Si recursos viene como array directo
            recursos = recursosArray
        } else {
            recursos = []
        }
        
        esSeguido = try container.decode(Bool.self, forKey: .esSeguido)
        esFavorito = try container.decode(Bool.self, forKey: .esFavorito)
        esDestacado = try container.decode(Bool.self, forKey: .esDestacado)
        vistaContador = try container.decodeIfPresent(Int.self, forKey: .vistaContador)
        
        // Fechas opcionales para anuncios
        if let fechaInicioString = try container.decodeIfPresent(String.self, forKey: .fechaInicio) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            fechaInicio = dateFormatter.date(from: fechaInicioString)
        } else {
            fechaInicio = nil
        }
        
        if let fechaFinString = try container.decodeIfPresent(String.self, forKey: .fechaFin) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            fechaFin = dateFormatter.date(from: fechaFinString)
        } else {
            fechaFin = nil
        }
        
        // Inicializar estado local del like como false
        tieneLikeUsuario = false
    }
    
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.uniqueId == rhs.uniqueId
    }
}

struct RecursoItem: Codable, Equatable {
    let url: String
}

// Helper para claves dinámicas
private struct DynamicKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
}