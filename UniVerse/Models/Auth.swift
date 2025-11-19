// Models/Auth.swift
import Foundation

// MARK: - Requests para registro

struct RegistroEstudianteRequest: Codable {
    let pIdUsuario: UUID
    let pNombreCompleto: String
    let pBiografia: String
    let pUbicacion: String
    let pTelefono: String
    let pNombreComercial: String
    let pCarrera: String
    let pUniversidadActual: String?
    let pFotoPerfil: String?
    let pSitioWeb: String?
    let pPais: String  // NUEVO CAMPO
    
    enum CodingKeys: String, CodingKey {
        case pIdUsuario = "p_id_usuario"
        case pNombreCompleto = "p_nombre_completo"
        case pBiografia = "p_biografia"
        case pUbicacion = "p_ubicacion"
        case pTelefono = "p_telefono"
        case pNombreComercial = "p_nombre_comercial"
        case pCarrera = "p_carrera"
        case pUniversidadActual = "p_universidad_actual"
        case pFotoPerfil = "p_foto_perfil"
        case pSitioWeb = "p_sitio_web"
        case pPais = "p_pais"
    }
}

struct RegistroEmpresaRequest: Codable {
    let pIdUsuario: UUID
    let pNombreCompleto: String
    let pFotoPerfil: String?
    let pBiografia: String
    let pUbicacion: String
    let pTelefono: String
    let pSitioWeb: String?
    let pPais: String
    let pNombreComercial: String
    let pAnioFundacion: Int
    let pTotalEmpleados: Int
    let pDocVerificacion: String
    let pFotoPortada: String?
    
    enum CodingKeys: String, CodingKey {
        case pIdUsuario = "p_id_usuario"
        case pNombreCompleto = "p_nombre_completo"
        case pFotoPerfil = "p_foto_perfil"
        case pBiografia = "p_biografia"
        case pUbicacion = "p_ubicacion"
        case pTelefono = "p_telefono"
        case pSitioWeb = "p_sitio_web"
        case pPais = "p_pais"
        case pNombreComercial = "p_nombre_comercial"
        case pAnioFundacion = "p_anio_fundacion"
        case pTotalEmpleados = "p_total_empleados"
        case pDocVerificacion = "p_doc_verificacion"
        case pFotoPortada = "p_foto_portada"
    }
}

// MARK: - Response

struct RegistroResponse: Codable {
    let success: Bool
    let idPerfil: Int?
    let message: String?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case idPerfil = "id_perfil"
        case message
        case error
    }
}