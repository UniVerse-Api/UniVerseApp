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
        case perfil = "perfil"
    }
    
    // Decodificador personalizado para manejar perfil como array o objeto
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        rol = try container.decode(RolUsuario.self, forKey: .rol)
        estado = try container.decode(EstadoUsuario.self, forKey: .estado)
        fechaCreacion = try container.decode(Date.self, forKey: .fechaCreacion)
        
        // Intentar decodificar perfil como objeto único
        if let perfilObject = try? container.decode(Perfil.self, forKey: .perfil) {
            perfil = perfilObject
        } else if let perfilArray = try? container.decode([Perfil].self, forKey: .perfil) {
            // Si viene como array, tomar el primero
            perfil = perfilArray.first
        } else {
            perfil = nil
        }
    }
    
    // Encoder personalizado
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(rol, forKey: .rol)
        try container.encode(estado, forKey: .estado)
        try container.encode(fechaCreacion, forKey: .fechaCreacion)
        try container.encodeIfPresent(perfil, forKey: .perfil)
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
    let pais: String  // NUEVO CAMPO
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
        case pais  // NUEVO CAMPO
        case perfilEstudiante = "perfil_estudiante"
        case perfilEmpresa = "perfil_empresa"
    }
    
    // Decodificador personalizado para manejar subobjetos que pueden venir como arrays
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        idUsuario = try container.decode(UUID.self, forKey: .idUsuario)
        nombreCompleto = try container.decode(String.self, forKey: .nombreCompleto)
        fotoPerfil = try container.decodeIfPresent(String.self, forKey: .fotoPerfil)
        biografia = try container.decode(String.self, forKey: .biografia)
        ubicacion = try container.decode(String.self, forKey: .ubicacion)
        telefono = try container.decode(String.self, forKey: .telefono)
        sitioWeb = try container.decodeIfPresent(String.self, forKey: .sitioWeb)
        pais = try container.decode(String.self, forKey: .pais)  // NUEVO CAMPO

        // Manejar perfilEstudiante
        if let estudianteObject = try? container.decode(PerfilEstudiante.self, forKey: .perfilEstudiante) {
            perfilEstudiante = estudianteObject
        } else if let estudianteArray = try? container.decode([PerfilEstudiante].self, forKey: .perfilEstudiante) {
            perfilEstudiante = estudianteArray.first
        } else {
            perfilEstudiante = nil
        }
        
        // Manejar perfilEmpresa
        if let empresaObject = try? container.decode(PerfilEmpresa.self, forKey: .perfilEmpresa) {
            perfilEmpresa = empresaObject
        } else if let empresaArray = try? container.decode([PerfilEmpresa].self, forKey: .perfilEmpresa) {
            perfilEmpresa = empresaArray.first
        } else {
            perfilEmpresa = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(idUsuario, forKey: .idUsuario)
        try container.encode(nombreCompleto, forKey: .nombreCompleto)
        try container.encodeIfPresent(fotoPerfil, forKey: .fotoPerfil)
        try container.encode(biografia, forKey: .biografia)
        try container.encode(ubicacion, forKey: .ubicacion)
        try container.encode(telefono, forKey: .telefono)
        try container.encodeIfPresent(sitioWeb, forKey: .sitioWeb)
        try container.encode(pais, forKey: .pais)  // NUEVO CAMPO
        try container.encodeIfPresent(perfilEstudiante, forKey: .perfilEstudiante)
        try container.encodeIfPresent(perfilEmpresa, forKey: .perfilEmpresa)
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
    let nombreComercial: String
    let anioFundacion: Int
    let totalEmpleados: Int
    let docVerificacion: String
    let fechaCreacion: Date
    let fotoPortada: String?
    
    enum CodingKeys: String, CodingKey {
        case idPerfil = "id_perfil"
        case nombreComercial = "nombre_comercial"
        case anioFundacion = "anio_fundacion"
        case totalEmpleados = "total_empleados"
        case docVerificacion = "doc_verificacion"
        case fechaCreacion = "fecha_creacion"
        case fotoPortada = "foto_portada"
    }
}
