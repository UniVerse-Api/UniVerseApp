
// Views/Empresa/PerfilEmpresaView.swift
import SwiftUI

struct PerfilEmpresaView: View {
    let idPerfil: Int?
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var perfilVM = PerfilEmpresaViewModel()
    
    // Constructor para vista independiente (usado desde ProfileDestinationView)
    init(idPerfil: Int? = nil) {
        self.idPerfil = idPerfil
    }
    
    // Estado original del archivo para compatibilidad
    init() {
        self.idPerfil = nil
    }
    
    // View content
    @State private var selectedTab = 0
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
   
    var body: some View {
        Group {
            if perfilVM.isLoading {
                loadingView
            } else if perfilVM.showError {
                errorView
            } else if perfilVM.hasData {
                mainContent
            } else {
                emptyView
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            loadProfileIfNeeded()
        }
        .alert("Error", isPresented: $perfilVM.showError) {
            Button("OK") {
                perfilVM.clearError()
            }
            Button("Reintentar") {
                loadProfileIfNeeded()
            }
        } message: {
            Text(perfilVM.errorMessage ?? "Error desconocido")
        }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header con navegación
                headerSection
               
                // Imagen de portada y logo
                coverAndLogoSection
               
                // Información de la empresa
                companyInfoSection
               
                // Botones de acción
                actionButtonsSection
               
                // Tabs (Acerca de / Publicaciones)
                tabSection
               
                // Contenido basado en la tab seleccionada
                contentSection
            }
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.primaryOrange)
            Text("Cargando perfil...")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    // MARK: - Error View
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("Error al cargar perfil")
                .font(.headline)
                .foregroundColor(.black)
            
            if let errorMessage = perfilVM.errorMessage {
                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    // MARK: - Empty View
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "building.2")
                .font(.system(size: 48))
                .foregroundColor(.textSecondary)
            
            Text("Perfil no disponible")
                .font(.headline)
                .foregroundColor(.black)
            
            Text("No se pudo cargar la información de la empresa")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    // MARK: - Helper Methods
    private func loadProfileIfNeeded() {
        guard let profileId = idPerfil else {
            print("DEBUG PerfilEmpresaView: No profile ID provided, using default data")
            return
        }
        
        let currentUserId = authVM.currentUser?.perfil?.id
        
        Task {
            await perfilVM.loadPerfilEmpresa(
                idPerfil: profileId,
                idPerfilVisitante: currentUserId
            )
        }
    }
    
    private func getUbicacionDisplay() -> String {
        guard let perfilBasico = perfilVM.perfilEmpresa?.perfilBasico else { return "N/A" }
        
        let ubicacion = perfilBasico.ubicacion ?? ""
        let pais = perfilBasico.pais ?? ""
        
        if ubicacion.isEmpty && pais.isEmpty {
            return "N/A"
        } else if pais.isEmpty {
            return ubicacion
        } else if ubicacion.isEmpty {
            return pais
        } else {
            return "\(ubicacion), \(pais)"
        }
    }
    
    // Vista por defecto para portada
    private var defaultPortadaView: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.orange]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 180)
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .offset(x: 20, y: -10)
                    }
                    Spacer()
                    HStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 100, height: 20)
                            .cornerRadius(10)
                        Spacer()
                    }
                    .offset(x: -10, y: 20)
                }
            )
    }
    
    // Vista por defecto para avatar
    private var defaultAvatarView: some View {
        Circle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 100, height: 100)
            .overlay(
                Text(String(perfilVM.displayName.prefix(1)))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            )
    }
   
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
               
                Spacer()
               
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(.black)
                        .rotationEffect(.degrees(90))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.95))
        }
    }
   
    // MARK: - Cover and Logo Section
    private var coverAndLogoSection: some View {
        ZStack(alignment: .bottomLeading) {
            // Imagen de portada
            ZStack {
                // Siempre mostrar fondo por defecto primero
                defaultPortadaView
                
                // Cargar imagen encima si existe
                if let fotoPortadaURL = perfilVM.fotoPortadaURL, !fotoPortadaURL.isEmpty {
                    AsyncImage(url: URL(string: fotoPortadaURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .clipped()
                    } placeholder: {
                        Color.clear
                    }
                    .allowsHitTesting(false)
                }
            }
           
            // Logo de la empresa
            HStack {
                ZStack {
                    // Siempre mostrar avatar por defecto primero
                    defaultAvatarView
                    
                    // Cargar imagen encima si existe
                    if let fotoPerfilURL = perfilVM.fotoPerfilURL, !fotoPerfilURL.isEmpty {
                        AsyncImage(url: URL(string: fotoPerfilURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } placeholder: {
                            Color.clear
                        }
                        .allowsHitTesting(false)
                    }
                }
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                )
                .offset(y: 50)
               
                Spacer()
            }
            .padding(.leading, 16)
        }
    }
   
    // MARK: - Company Info Section
    private var companyInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Text(perfilVM.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
               
                // Badge Premium
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 24, height: 24)
                   
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
           
            Text(perfilVM.informacionContacto)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 60)
    }
   
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            if !perfilVM.esMiPerfil {
                Button(action: {
                    handleFollowToggle()
                }) {
                    Text(perfilVM.siguiendoEmpresa ? "Siguiendo" : "Seguir")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(perfilVM.siguiendoEmpresa ? .black : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(perfilVM.siguiendoEmpresa ? Color.gray.opacity(0.2) : Color.primaryOrange)
                        .cornerRadius(8)
                }
               
                Button(action: {
                    // TODO: Implementar mensaje
                }) {
                    Text("Mensaje")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            } else {
                Button(action: {
                    // TODO: Implementar editar perfil
                }) {
                    Text("Editar Perfil")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    private func handleFollowToggle() {
        // TODO: Implementar follow/unfollow
        perfilVM.actualizarSeguimiento(siguiendo: !perfilVM.siguiendoEmpresa)
    }
   
    // MARK: - Tab Section
    private var tabSection: some View {
        VStack(spacing: 0) {
            HStack {
                TabButtond(title: "Acerca de", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
               
                TabButtond(title: "Publicaciones", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
            }
           
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .padding(.top, 20)
        .background(Color.white)
    }
   
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 20) {
            if selectedTab == 0 {
                aboutSection
            } else {
                publicationsSection
            }
        }
        .padding(.top, 20)
        .background(Color.white)
    }
   
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(spacing: 20) {
            // Información de la empresa
            VStack(alignment: .leading, spacing: 16) {
                Text("Acerca de \(perfilVM.displayName)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
               
                VStack(alignment: .leading, spacing: 8) {
                    Text(perfilVM.descripcionEmpresa)
                        .font(.body)
                        .foregroundColor(.textSecondary)
                   
                    Button("Leer más") {
                        // Acción para leer más
                    }
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryOrange)
                }
               
                // Grid de estadísticas
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    if let tamano = perfilVM.tamanoEmpresaTexto {
                        StatCard2(icon: "person.3.fill", value: tamano, label: "Empleados")
                    }
                    if let anio = perfilVM.anioFundacionTexto {
                        StatCard2(icon: "calendar", value: anio, label: "Fundada")
                    }
                    StatCard2(icon: "location.fill", value: getUbicacionDisplay(), label: "Ubicación")
                    StatCard2(icon: "briefcase.fill", value: perfilVM.ofertasActivasTexto, label: "Ofertas Activas")
                }
                .padding(.top, 8)
               
                // Información de contacto
                VStack(alignment: .leading, spacing: 12) {
                    if let ubicacion = perfilVM.perfilEmpresa?.perfilBasico?.ubicacion, !ubicacion.isEmpty {
                        let pais = perfilVM.perfilEmpresa?.perfilBasico?.pais ?? ""
                        let ubicacionCompleta = pais.isEmpty ? ubicacion : "\(ubicacion), \(pais)"
                        ContactRowEmpresa(icon: "location.fill", text: ubicacionCompleta)
                    }
                    
                    if let telefono = perfilVM.perfilEmpresa?.perfilBasico?.telefono, !telefono.isEmpty {
                        ContactRowEmpresa(icon: "phone.fill", text: telefono)
                    }
                   
                    if let sitioWeb = perfilVM.perfilEmpresa?.perfilBasico?.sitioWeb, !sitioWeb.isEmpty {
                        Button(action: {
                            if let url = URL(string: sitioWeb.hasPrefix("http") ? sitioWeb : "https://\(sitioWeb)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "link")
                                    .foregroundColor(.primaryOrange)
                                Text(sitioWeb)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryOrange)
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 16)
           
            // Ofertas de trabajo
            jobOffersSection
        }
    }
   
    // MARK: - Job Offers Section
    private var jobOffersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Ofertas y oportunidades")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
               
                Spacer()
               
                Button("Ver Todas") {
                    // Acción para ver todas las ofertas
                }
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.primaryOrange)
            }
            .padding(.horizontal, 16)
           
            if perfilVM.tieneOfertas {
                VStack(spacing: 12) {
                    ForEach(perfilVM.ofertasRecientes, id: \.idOferta) { oferta in
                        JobCardEmpresa(
                            title: oferta.titulo,
                            location: [oferta.ubicacion, oferta.tipoOferta].compactMap { $0 }.joined(separator: " • "),
                            description: oferta.descripcion
                        )
                    }
                }
                .padding(.horizontal, 16)
            } else {
                Text("No hay ofertas disponibles en este momento")
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
            }
        }
    }
   
    // MARK: - Publications Section
    private var publicationsSection: some View {
        VStack(spacing: 16) {
            Text("Publicaciones")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
           
            Text("Aquí aparecerán las publicaciones de la empresa")
                .font(.body)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 16)
        }
        .padding(.top, 40)
    }
}


// MARK: - Supporting Views


struct TabButtond: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
   
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(isSelected ? .primaryOrange : .black)
               
                Rectangle()
                    .fill(isSelected ? Color.primaryOrange : Color.clear)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}


struct StatCard2: View {
    let icon: String
    let value: String
    let label: String
   
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.1))
                    .frame(width: 40, height: 40)
               
                Image(systemName: icon)
                    .foregroundColor(.primaryOrange)
                    .font(.system(size: 16))
            }
           
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
               
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
           
            Spacer()
        }
    }
}


struct ContactRowEmpresa: View {
    let icon: String
    let text: String
   
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.primaryOrange)
                .font(.system(size: 14))
                .frame(width: 20)
           
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
        }
    }
}


struct JobCardEmpresa: View {
    let title: String
    let location: String
    let description: String
   
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
           
            Text(location)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
           
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .lineLimit(2)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}


// MARK: - Preview
#Preview {
    NavigationView {
        PerfilEmpresaView()
    }
    .preferredColorScheme(.dark)
}



