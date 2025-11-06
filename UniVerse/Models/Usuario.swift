// Models/Usuario.swift
import Foundation

struct Usuario: Codable, Identifiable {
    let id: UUID
    let rol: RolUsuario
    let estado: EstadoUsuario
    let fechaCreacion: Date
    var perfil: Perfil?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_usuario"
        case rol
        case estado
        case fechaCreacion = "fecha_creacion"
        case perfil = "Perfil"
    }
}

enum RolUsuario: String, Codable {
    case estudiante
    case empresa
}

enum EstadoUsuario: String, Codable {
    case activo
    case inactivo
    case suspendido
}

struct Perfil: Codable, Identifiable {
    let id: Int
    let idUsuario: UUID
    let nombreCompleto: String
    let fotoPerfil: String?
    let biografia: String
    let ubicacion: String
    let telefono: String
    let sitioWeb: String?
    var perfilEstudiante: PerfilEstudiante?
    var perfilEmpresa: PerfilEmpresa?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_perfil"
        case idUsuario = "id_usuario"
        case nombreCompleto = "nombre_completo"
        case fotoPerfil = "foto_perfil"
        case biografia
        case ubicacion
        case telefono
        case sitioWeb = "sitio_web"
        case perfilEstudiante = "Perfil_estudiante"
        case perfilEmpresa = "Perfil_empresa"
    }
}

struct PerfilEstudiante: Codable {
    let idPerfil: Int
    let nombreComercial: String?
    let carrera: String
    let universidadActual: String?
    let fechaCreacion: Date
    
    enum CodingKeys: String, CodingKey {
        case idPerfil = "id_perfil"
        case nombreComercial = "nombre_comercial"
        case carrera
        case universidadActual = "universidad_actual"
        case fechaCreacion = "fecha_creacion"
    }
}

struct PerfilEmpresa: Codable {
    let idPerfil: Int
    let nombreEmpresa: String
    let fechaCreacion: Date
    
    enum CodingKeys: String, CodingKey {
        case idPerfil = "id_perfil"
        case nombreEmpresa = "nombre_empresa"
        case fechaCreacion = "fecha_creacion"
    }
}
