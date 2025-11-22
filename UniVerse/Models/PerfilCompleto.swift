// Models/PerfilCompleto.swift
import Foundation

// MARK: - Perfil Completo Response
struct PerfilCompletoResponse: Codable {
    let success: Bool
    let message: String?
    let perfilBasico: PerfilBasico?
    let perfilEstudiante: PerfilEstudiantePerfil?
    var estadisticas: Estadisticas?
    var estadoSeguimiento: EstadoSeguimiento?
    let investigaciones: [Investigacion]?
    let experiencias: [ExperienciaPerfil]?
    let formaciones: [FormacionPerfil]?
    let certificaciones: [CertificacionPerfil]?
    let cvs: [CVArchivoPerfil]?
    let habilidades: [HabilidadPerfil]?
    let idiomas: [IdiomaPerfil]?
    let suscripcionActiva: SuscripcionActiva?
    let contadores: Contadores?
    let esFavoritoDelVisitante: Bool?
    let destacados: [Destacado]?
    let estaDestacado: Bool?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case perfilBasico = "perfil_basico"
        case perfilEstudiante = "perfil_estudiante"
        case estadisticas
        case estadoSeguimiento = "estado_seguimiento"
        case investigaciones
        case experiencias
        case formaciones
        case certificaciones
        case cvs
        case habilidades
        case idiomas
        case suscripcionActiva = "suscripcion_activa"
        case contadores
        case esFavoritoDelVisitante = "es_favorito_del_visitante"
        case destacados
        case estaDestacado = "esta_destacado"
    }
}

// MARK: - Perfil Básico
struct PerfilBasico: Codable {
    let idPerfil: Int
    let idUsuario: String
    let nombreCompleto: String
    let fotoPerfil: String?
    let biografia: String
    let ubicacion: String
    let pais: String
    let telefono: String
    let sitioWeb: String?
    let rol: String
    let estado: String
    let fechaCreacion: String
    
    enum CodingKeys: String, CodingKey {
        case idPerfil = "id_perfil"
        case idUsuario = "id_usuario"
        case nombreCompleto = "nombre_completo"
        case fotoPerfil = "foto_perfil"
        case biografia
        case ubicacion
        case pais
        case telefono
        case sitioWeb = "sitio_web"
        case rol
        case estado
        case fechaCreacion = "fecha_creacion"
    }
}

// MARK: - Perfil Estudiante Para Perfil Completo
struct PerfilEstudiantePerfil: Codable {
    let nombreComercial: String?
    let carrera: String
    let universidadActual: String?
    let fechaCreacion: String
    
    enum CodingKeys: String, CodingKey {
        case nombreComercial = "nombre_comercial"
        case carrera
        case universidadActual = "universidad_actual"
        case fechaCreacion = "fecha_creacion"
    }
}

// MARK: - Estadísticas
struct Estadisticas: Codable {
    var seguidores: Int
    let siguiendo: Int
    let publicaciones: Int
}

// MARK: - Estado Seguimiento
struct EstadoSeguimiento: Codable {
    let meSigue: Bool
    let esMiPerfil: Bool
    var sigoAEstePerfil: Bool
    
    enum CodingKeys: String, CodingKey {
        case meSigue = "me_sigue"
        case esMiPerfil = "es_mi_perfil"
        case sigoAEstePerfil = "sigo_a_este_perfil"
    }
}

// MARK: - Investigación
struct Investigacion: Codable {
    let idInvestigacion: Int
    let titulo: String
    let descripcion: String
    let rol: String?
    let fechaInicio: String
    let fechaFin: String
    let fechaPublicacion: String
    let ubicacion: String?
    
    enum CodingKeys: String, CodingKey {
        case idInvestigacion = "id_investigacion"
        case titulo
        case descripcion
        case rol
        case fechaInicio = "fecha_inicio"
        case fechaFin = "fecha_fin"
        case fechaPublicacion = "fecha_publicacion"
        case ubicacion
    }
}

// MARK: - Experiencia
struct ExperienciaPerfil: Codable {
    let idExperiencia: Int
    let empresa: String
    let tipo: String
    let puesto: String
    let fechaInicio: String
    let fechaFin: String?
    let descripcion: String?
    let ubicacion: String?
    let esActual: Bool
    
    enum CodingKeys: String, CodingKey {
        case idExperiencia = "id_experiencia"
        case empresa
        case tipo
        case puesto
        case fechaInicio = "fecha_inicio"
        case fechaFin = "fecha_fin"
        case descripcion
        case ubicacion
        case esActual = "es_actual"
    }
}

// MARK: - Formación
struct FormacionPerfil: Codable {
    let idFormacion: Int
    let institucion: String
    let campoEstudio: String
    let grado: String
    let fechaInicio: String
    let fechaFin: String
    let esActual: Bool
    
    enum CodingKeys: String, CodingKey {
        case idFormacion = "id_formacion"
        case institucion
        case campoEstudio = "campo_estudio"
        case grado
        case fechaInicio = "fecha_inicio"
        case fechaFin = "fecha_fin"
        case esActual = "es_actual"
    }
}

// MARK: - Certificación
struct CertificacionPerfil: Codable {
    let idCertificacion: Int
    let titulo: String
    let imagen: String
    let institucion: String
    let fechaObtencion: String
    
    enum CodingKeys: String, CodingKey {
        case idCertificacion = "id_certificacion"
        case titulo
        case imagen
        case institucion
        case fechaObtencion = "fecha_obtencion"
    }
}

// MARK: - CV Archivo Para Perfil Completo
struct CVArchivoPerfil: Codable {
    let idCv: Int
    let nombre: String
    let urlCv: String
    let fechaSubida: String
    let visible: String
    
    enum CodingKeys: String, CodingKey {
        case idCv = "id_cv"
        case nombre
        case urlCv = "url_cv"
        case fechaSubida = "fecha_subida"
        case visible
    }
}

// MARK: - Habilidad
struct HabilidadPerfil: Codable {
    let idHabilidad: Int
    let nombre: String
    
    enum CodingKeys: String, CodingKey {
        case idHabilidad = "id_habilidad"
        case nombre
    }
}

// MARK: - Idioma
struct IdiomaPerfil: Codable {
    let idIdioma: Int
    let nombre: String
    let nivel: String
    
    enum CodingKeys: String, CodingKey {
        case idIdioma = "id_idioma"
        case nombre
        case nivel
    }
}

// MARK: - Suscripción Activa
struct SuscripcionActiva: Codable {
    let idSuscripcion: Int
    let planNombre: String
    let estatus: String
    let fechaInicio: String
    let fechaFin: String
    let maxCvSubida: Int
    let maxOfertasTrabajo: Int
    let prioridadBusqueda: String
    
    enum CodingKeys: String, CodingKey {
        case idSuscripcion = "id_suscripcion"
        case planNombre = "plan_nombre"
        case estatus
        case fechaInicio = "fecha_inicio"
        case fechaFin = "fecha_fin"
        case maxCvSubida = "max_cv_subida"
        case maxOfertasTrabajo = "max_ofertas_trabajo"
        case prioridadBusqueda = "prioridad_busqueda"
    }
}

// MARK: - Contadores
struct Contadores: Codable {
    let totalHabilidades: Int
    let totalAplicaciones: Int
    let totalCvsPublicos: Int
    let totalExperiencias: Int
    let totalCertificaciones: Int
    let totalInvestigaciones: Int
    
    enum CodingKeys: String, CodingKey {
        case totalHabilidades = "total_habilidades"
        case totalAplicaciones = "total_aplicaciones"
        case totalCvsPublicos = "total_cvs_publicos"
        case totalExperiencias = "total_experiencias"
        case totalCertificaciones = "total_certificaciones"
        case totalInvestigaciones = "total_investigaciones"
    }
}

// MARK: - Destacado
struct Destacado: Codable {
    let idPerfil: Int
    let nombre: String
    let rol: String
    let comentario: String?
    let fotoPerfil: String?
    let fechaCreacion: String
    
    enum CodingKeys: String, CodingKey {
        case idPerfil = "id_perfil"
        case nombre
        case rol
        case comentario
        case fotoPerfil = "foto_perfil"
        case fechaCreacion = "fecha_creacion"
    }
}
