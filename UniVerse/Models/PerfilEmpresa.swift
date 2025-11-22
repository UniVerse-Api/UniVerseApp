// Models/PerfilEmpresa.swift
import Foundation

// MARK: - Perfil Empresa Response
struct PerfilEmpresaResponse: Codable {
    let success: Bool
    let message: String?
    let perfilBasico: PerfilBasico?
    let perfilEmpresa: PerfilEmpresaPerfil?
    var estadisticas: EstadisticasEmpresa?
    var estadoSeguimiento: EstadoSeguimiento?
    let ofertasRecientes: [OfertaEmpresa]?
    let ofertasActivas: [OfertaEmpresa]?
    let suscripcionActiva: SuscripcionActivaEmpresa?
    let contadores: ContadoresEmpresa?
    let aplicacionesVisitante: [AplicacionVisitante]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case perfilBasico = "perfil_basico"
        case perfilEmpresa = "perfil_empresa"
        case estadisticas
        case estadoSeguimiento = "estado_seguimiento"
        case ofertasRecientes = "ofertas_recientes"
        case ofertasActivas = "ofertas_activas"
        case suscripcionActiva = "suscripcion_activa"
        case contadores
        case aplicacionesVisitante = "aplicaciones_visitante"
    }
}

// MARK: - Perfil Empresa Específico
struct PerfilEmpresaPerfil: Codable {
    let nombreComercial: String?
    let anioFundacion: Int?
    let descripcion: String?
    let industria: String?
    let tamanoEmpresa: String?
    let fotoPortada: String?
    let totalEmpleados: Int?
    let fechaCreacion: String?
    
    enum CodingKeys: String, CodingKey {
        case nombreComercial = "nombre_comercial"
        case anioFundacion = "anio_fundacion"
        case descripcion
        case industria
        case tamanoEmpresa = "tamano_empresa"
        case fotoPortada = "foto_portada"
        case totalEmpleados = "total_empleados"
        case fechaCreacion = "fecha_creacion"
    }
}

// MARK: - Estadísticas Empresa
struct EstadisticasEmpresa: Codable {
    var seguidores: Int
    let siguiendo: Int
    let publicaciones: Int
    let ofertasActivas: Int
    let anunciosActivos: Int
    
    enum CodingKeys: String, CodingKey {
        case seguidores
        case siguiendo
        case publicaciones
        case ofertasActivas = "ofertas_activas"
        case anunciosActivos = "anuncios_activos"
    }
}

// MARK: - Oferta Empresa
struct OfertaEmpresa: Codable {
    let idOferta: Int
    let titulo: String
    let descripcion: String
    let ubicacion: String?
    let tipoOferta: String?
    let fechaLimite: String?
    let salarioRango: String?
    let fechaPublicacion: String
    let totalAplicaciones: Int?
    let beneficios: [BeneficioOferta]?
    let requisitos: [RequisitoOferta]?
    
    enum CodingKeys: String, CodingKey {
        case idOferta = "id_oferta"
        case titulo
        case descripcion
        case ubicacion
        case tipoOferta = "tipo_oferta"
        case fechaLimite = "fecha_limite"
        case salarioRango = "salario_rango"
        case fechaPublicacion = "fecha_publicacion"
        case totalAplicaciones = "total_aplicaciones"
        case beneficios
        case requisitos
    }
}

// MARK: - Beneficio Oferta
struct BeneficioOferta: Codable {
    let idBeneficio: Int
    let nombreBeneficio: String
    
    enum CodingKeys: String, CodingKey {
        case idBeneficio = "id_beneficio"
        case nombreBeneficio = "nombre_beneficio"
    }
}

// MARK: - Requisito Oferta
struct RequisitoOferta: Codable {
    let idRequisito: Int
    let nombreRequisito: String
    
    enum CodingKeys: String, CodingKey {
        case idRequisito = "id_requisito"
        case nombreRequisito = "nombre_requisito"
    }
}

// MARK: - Contadores Empresa
struct ContadoresEmpresa: Codable {
    let totalOfertas: Int
    let totalAnuncios: Int
    let estudiantesFavoritos: Int
    let totalOfertasActivas: Int
    let totalAplicacionesRecibidas: Int
    
    enum CodingKeys: String, CodingKey {
        case totalOfertas = "total_ofertas"
        case totalAnuncios = "total_anuncios"
        case estudiantesFavoritos = "estudiantes_favoritos"
        case totalOfertasActivas = "total_ofertas_activas"
        case totalAplicacionesRecibidas = "total_aplicaciones_recibidas"
    }
}

// MARK: - Aplicación Visitante
struct AplicacionVisitante: Codable {
    let idAplicacion: Int
    let idOferta: Int
    let tituloOferta: String
    let fechaAplicacion: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case idAplicacion = "id_aplicacion"
        case idOferta = "id_oferta"
        case tituloOferta = "titulo_oferta"
        case fechaAplicacion = "fecha_aplicacion"
        case status
    }
}

// MARK: - Suscripción Activa Empresa
struct SuscripcionActivaEmpresa: Codable {
    let idSuscripcion: Int
    let planNombre: String
    let estatus: String
    let fechaInicio: String
    let fechaFin: String
    let maxOfertasTrabajo: Int
    let maxPubDia: Int
    let prioridadBusqueda: String
    let agregarAds: Bool
    
    enum CodingKeys: String, CodingKey {
        case idSuscripcion = "id_suscripcion"
        case planNombre = "plan_nombre"
        case estatus
        case fechaInicio = "fecha_inicio"
        case fechaFin = "fecha_fin"
        case maxOfertasTrabajo = "max_ofertas_trabajo"
        case maxPubDia = "max_pub_dia"
        case prioridadBusqueda = "prioridad_busqueda"
        case agregarAds = "agregar_ads"
    }
}
