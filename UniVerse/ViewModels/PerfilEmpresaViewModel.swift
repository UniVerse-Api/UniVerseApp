// ViewModels/PerfilEmpresaViewModel.swift
import Foundation
import SwiftUI

@MainActor
class PerfilEmpresaViewModel: ObservableObject {
    @Published var perfilEmpresa: PerfilEmpresaResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let perfilService = PerfilService()
    
    // MARK: - Public Methods
    
    /// Carga el perfil completo de una empresa
    /// - Parameters:
    ///   - idPerfil: ID del perfil de la empresa
    ///   - idPerfilVisitante: ID del perfil del visitante (opcional)
    func loadPerfilEmpresa(idPerfil: Int, idPerfilVisitante: Int? = nil) async {
        print("DEBUG PerfilEmpresaViewModel: loadPerfilEmpresa called with idPerfil: \(idPerfil)")
        
        guard !isLoading else {
            print("DEBUG PerfilEmpresaViewModel: Already loading, skipping")
            return
        }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        do {
            let perfil = try await perfilService.getPerfilEmpresaCompleto(
                idPerfil: idPerfil,
                idPerfilVisitante: idPerfilVisitante
            )
            
            print("DEBUG PerfilEmpresaViewModel: Successfully loaded empresa profile")
            perfilEmpresa = perfil
            
        } catch let error as PerfilService.PerfilError {
            print("DEBUG PerfilEmpresaViewModel: PerfilError: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            showError = true
            perfilEmpresa = nil
            
        } catch {
            print("DEBUG PerfilEmpresaViewModel: General error: \(error.localizedDescription)")
            errorMessage = "Error al cargar el perfil: \(error.localizedDescription)"
            showError = true
            perfilEmpresa = nil
        }
        
        isLoading = false
    }
    
    /// Actualiza el estado de seguimiento de la empresa
    /// - Parameter siguiendo: Nuevo estado de seguimiento
    func actualizarSeguimiento(siguiendo: Bool) {
        guard var estadisticas = perfilEmpresa?.estadisticas,
              var estadoSeguimiento = perfilEmpresa?.estadoSeguimiento else { return }
        
        // Actualizar estado local
        estadoSeguimiento.sigoAEstePerfil = siguiendo
        estadisticas.seguidores += siguiendo ? 1 : -1
        
        // Actualizar el perfil
        perfilEmpresa?.estadisticas = estadisticas
        perfilEmpresa?.estadoSeguimiento = estadoSeguimiento
    }
    
    /// Limpia el error actual
    func clearError() {
        errorMessage = nil
        showError = false
    }
    
    /// Refresca el perfil de la empresa
    /// - Parameters:
    ///   - idPerfil: ID del perfil de la empresa
    ///   - idPerfilVisitante: ID del perfil del visitante (opcional)
    func refreshPerfil(idPerfil: Int, idPerfilVisitante: Int? = nil) async {
        await loadPerfilEmpresa(idPerfil: idPerfil, idPerfilVisitante: idPerfilVisitante)
    }
    
    // MARK: - Computed Properties
    
    /// Indica si hay información disponible
    var hasData: Bool {
        perfilEmpresa != nil && !isLoading
    }
    
    /// Indica si el perfil está vacío
    var isEmpty: Bool {
        perfilEmpresa == nil && !isLoading
    }
    
    /// Obtiene el nombre de la empresa para mostrar
    var displayName: String {
        guard let perfil = perfilEmpresa else { return "Empresa" }
        
        if let nombreComercial = perfil.perfilEmpresa?.nombreComercial, !nombreComercial.isEmpty {
            return nombreComercial
        } else {
            return perfil.perfilBasico?.nombreCompleto ?? "Empresa"
        }
    }
    
    /// Obtiene la descripción de la empresa
    var descripcionEmpresa: String {
        return perfilEmpresa?.perfilEmpresa?.descripcion ?? "Sin descripción disponible"
    }
    
    /// Obtiene la información de contacto formateada
    var informacionContacto: String {
        guard let perfil = perfilEmpresa?.perfilBasico else { return "" }
        
        var info: [String] = []
        
        // Ubicación con país
        let ubicacion = perfil.ubicacion ?? ""
        let pais = perfil.pais ?? ""
        
        if !ubicacion.isEmpty && !pais.isEmpty {
            info.append("\(ubicacion), \(pais)")
        } else if !ubicacion.isEmpty {
            info.append(ubicacion)
        } else if !pais.isEmpty {
            info.append(pais)
        }
        
        // Industria si está disponible
        if let industria = perfilEmpresa?.perfilEmpresa?.industria, !industria.isEmpty {
            info.append(industria)
        }
        
        return info.joined(separator: " • ")
    }
    
    /// Obtiene el año de fundación formateado
    var anioFundacionTexto: String? {
        guard let anio = perfilEmpresa?.perfilEmpresa?.anioFundacion else { return nil }
        return String(anio)
    }
    
    /// Obtiene el tamaño de la empresa
    var tamanoEmpresaTexto: String? {
        if let totalEmpleados = perfilEmpresa?.perfilEmpresa?.totalEmpleados {
            return "\(totalEmpleados)+"
        }
        return perfilEmpresa?.perfilEmpresa?.tamanoEmpresa
    }
    
    /// Obtiene el número de seguidores formateado
    var seguidoresTexto: String {
        guard let seguidores = perfilEmpresa?.estadisticas?.seguidores else { return "0" }
        
        if seguidores >= 1000 {
            return String(format: "%.1fK", Double(seguidores) / 1000.0)
        } else {
            return "\(seguidores)"
        }
    }
    
    /// Obtiene el número de ofertas activas
    var ofertasActivasTexto: String {
        guard let ofertas = perfilEmpresa?.estadisticas?.ofertasActivas else { return "0" }
        return "\(ofertas)"
    }
    
    /// Indica si el usuario actual sigue a esta empresa
    var siguiendoEmpresa: Bool {
        return perfilEmpresa?.estadoSeguimiento?.sigoAEstePerfil ?? false
    }
    
    /// Indica si es el perfil propio
    var esMiPerfil: Bool {
        return perfilEmpresa?.estadoSeguimiento?.esMiPerfil ?? false
    }
    
    /// Obtiene las ofertas recientes para mostrar
    var ofertasRecientes: [OfertaEmpresa] {
        return perfilEmpresa?.ofertasRecientes ?? []
    }
    
    /// Obtiene todas las ofertas activas
    var ofertasActivas: [OfertaEmpresa] {
        return perfilEmpresa?.ofertasActivas ?? []
    }
    
    /// Indica si tiene ofertas para mostrar
    var tieneOfertas: Bool {
        return !ofertasRecientes.isEmpty || !ofertasActivas.isEmpty
    }
    
    /// Obtiene la URL de la foto de perfil
    var fotoPerfilURL: String? {
        return perfilEmpresa?.perfilBasico?.fotoPerfil
    }
    
    /// Obtiene la URL de la foto de portada
    var fotoPortadaURL: String? {
        return perfilEmpresa?.perfilEmpresa?.fotoPortada
    }
    
    /// Indica si tiene plan premium
    var esPremium: Bool {
        // Basado en el plan de suscripción activa
        return perfilEmpresa?.suscripcionActiva?.planNombre.lowercased().contains("premium") ?? false ||
               perfilEmpresa?.suscripcionActiva?.planNombre.lowercased().contains("empresas") ?? false
    }
}
