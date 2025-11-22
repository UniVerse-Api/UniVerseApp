// Views/Estudiante/EmpleosEstudianteView.swift
import SwiftUI

enum JobFilterType: String, CaseIterable {
    case todos = "Todos"
    case misAplicaciones = "Mis Aplicaciones"
    case pasantias = "Pasantías"
    case tiempoCompleto = "Tiempo Completo"
    case remoto = "Remoto"
    
    var icon: String? {
        switch self {
        case .misAplicaciones:
            return "doc.text.fill"
        default:
            return nil
        }
    }
}

struct EmpleosEstudianteView: View {
    @State private var searchText = ""
    @State private var selectedFilter: JobFilterType = .todos
    @State private var bookmarkedJobs: Set<Int> = []
    @State private var showingFilterSheet = false
    
    @StateObject private var ofertaService = OfertaService()
    @State private var ofertas: [OfertaEstudiante] = []
    @State private var aplicaciones: [AplicacionEstudiante] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // Obtener el AuthViewModel del entorno
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var filteredOfertas: [OfertaEstudiante] {
        var filtered = ofertas
        
        // Filter by type
        switch selectedFilter {
        case .pasantias:
            filtered = filtered.filter { $0.tipoOferta == .pasantia }
        case .tiempoCompleto:
            filtered = filtered.filter { $0.tipoOferta == .tiempoCompleto }
        case .remoto:
            filtered = filtered.filter { $0.ubicacion.lowercased().contains("remoto") }
        case .todos, .misAplicaciones:
            break
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { oferta in
                oferta.titulo.lowercased().contains(searchText.lowercased()) ||
                oferta.ubicacion.lowercased().contains(searchText.lowercased()) ||
                oferta.requisitos.contains { $0.lowercased().contains(searchText.lowercased()) }
            }
        }
        
        return filtered
    }
    
    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                empleosHeader
                
                // MARK: - Search and Filters
                searchAndFiltersSection
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        if isLoading {
                            ForEach(0..<3, id: \.self) { _ in
                                JobLoadingSkeleton()
                            }
                        } else if let error = errorMessage {
                            ErrorView(message: error) {
                                Task {
                                    await loadData()
                                }
                            }
                        } else {
                            if selectedFilter == .misAplicaciones {
                                // Applications List
                                if aplicaciones.isEmpty {
                                    EmptyStateView(
                                        icon: "doc.text.fill",
                                        title: "No tienes aplicaciones",
                                        message: "Aún no has aplicado a ninguna oferta de empleo"
                                    )
                                } else {
                                    ForEach(aplicaciones) { aplicacion in
                                        ApplicationCardView(aplicacion: aplicacion)
                                    }
                                }
                            } else {
                                // Job Listings
                                if filteredOfertas.isEmpty {
                                    EmptyStateView(
                                        icon: "briefcase.fill",
                                        title: "No hay ofertas disponibles",
                                        message: searchText.isEmpty ? "No se encontraron ofertas activas" : "No se encontraron ofertas con '\(searchText)'"
                                    )
                                } else {
                                    ForEach(filteredOfertas) { oferta in
                                        NavigationLink(destination: DetalleEmpleoView(oferta: oferta)) {
                                            OfertaCardView(
                                                oferta: oferta,
                                                isBookmarked: bookmarkedJobs.contains(oferta.id),
                                                onBookmarkTap: {
                                                    toggleBookmark(oferta.id)
                                                }
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
                .background(Color.backgroundLight.opacity(0.3))
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Log para ver información del usuario al entrar a la vista
            if let user = authViewModel.currentUser {
                print("=== DEBUG EmpleosEstudianteView ===")
                print("Usuario autenticado: \(user.perfil?.nombreCompleto ?? "Sin nombre")")
                print("ID Usuario: \(user.id)")
                print("ID Perfil: \(user.perfil?.id ?? -1)")
                print("Rol: \(user.rol)")
                print("===================================")
            } else {
                print("⚠️ WARNING: No hay usuario autenticado en EmpleosEstudianteView")
            }
        }
        .task {
            await loadData()
        }
    }
    
    // MARK: - Header
    private var empleosHeader: some View {
        VStack(spacing: 0) {
            Text("Empleos")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.backgroundLight.opacity(0.95))
        .backdrop()
    }
    
    // MARK: - Search and Filters Section
    private var searchAndFiltersSection: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                
                TextField("Buscar por título, requisito o ubicación...", text: $searchText)
                    .font(.system(size: 14))
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.inputBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
            
            // Filter Buttons
            HStack(spacing: 8) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(JobFilterType.allCases, id: \.self) { filter in
                            JobFilterButton(
                                title: filter.rawValue,
                                icon: filter.icon,
                                isSelected: selectedFilter == filter
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedFilter = filter
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.backgroundLight)
        .overlay(
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Load Data
    private func loadData() async {
        // Verificar que haya un usuario autenticado con perfil
        guard let perfil = authViewModel.currentUser?.perfil else {
            errorMessage = "No se pudo obtener el perfil del usuario"
            print("❌ ERROR: No se pudo obtener el perfil del usuario en loadData()")
            return
        }
        
        print("📊 DEBUG loadData: Cargando ofertas para perfil ID: \(perfil.id)")
        print("📊 DEBUG loadData: Usuario: \(perfil.nombreCompleto)")
        
        isLoading = true
        errorMessage = nil
        
        do {
            async let ofertasTask = ofertaService.getOfertasActivas()
            async let aplicacionesTask = ofertaService.getAplicaciones(idPerfil: perfil.id)
            
            let (fetchedOfertas, fetchedAplicaciones) = try await (ofertasTask, aplicacionesTask)
            
            ofertas = fetchedOfertas
            aplicaciones = fetchedAplicaciones
            
            print("✅ DEBUG loadData: Ofertas cargadas: \(fetchedOfertas.count)")
            print("✅ DEBUG loadData: Aplicaciones cargadas: \(fetchedAplicaciones.count)")
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ ERROR loadData: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Toggle Bookmark
    private func toggleBookmark(_ jobId: Int) {
        if bookmarkedJobs.contains(jobId) {
            bookmarkedJobs.remove(jobId)
        } else {
            bookmarkedJobs.insert(jobId)
        }
    }
}

// MARK: - Job Filter Button
struct JobFilterButton: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 11))
                }
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(isSelected ? .black : .textSecondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(isSelected ? Color.primaryOrange : Color.inputBackground)
            .cornerRadius(20)
        }
    }
}

// MARK: - Oferta Card View
struct OfertaCardView: View {
    let oferta: OfertaEstudiante
    let isBookmarked: Bool
    let onBookmarkTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Premium Badge (if applicable)
            if oferta.esPremium {
                HStack {
                    Spacer()
                    Text("DESTACADO")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple)
                        .cornerRadius(4)
                }
                .padding([.top, .trailing], 12)
            }
            
            HStack(alignment: .top, spacing: 12) {
                // Company Logo
                if let fotoPerfil = oferta.fotoPerfil, !fotoPerfil.isEmpty {
                    AsyncImage(url: URL(string: fotoPerfil)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.borderColor, lineWidth: 1))
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }
                
                // Job Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(oferta.titulo)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                    
                    Text(oferta.nombreCompleto)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: oferta.ubicacion.lowercased().contains("remoto") ? "laptopcomputer" : "location.fill")
                                .font(.system(size: 9))
                            Text(oferta.ubicacion)
                                .font(.system(size: 10))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 9))
                            Text(oferta.tipoOferta.displayName)
                                .font(.system(size: 10))
                        }
                    }
                    .foregroundColor(.textSecondary)
                    
                    // Requirements (first 3, truncated)
                    if !oferta.requisitos.isEmpty {
                        HStack(spacing: 6) {
                            ForEach(Array(oferta.requisitos.prefix(3).enumerated()), id: \.offset) { index, requisito in
                                let displayText = requisito.count > 10 ? String(requisito.prefix(10)) + "..." : requisito
                                let colors: [Color] = [.blue, .green, .purple, .orange, .pink]
                                let color = colors[index % colors.count]
                                
                                Text(displayText)
                                    .font(.system(size: 10))
                                    .foregroundColor(color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(color.opacity(0.15))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    
                    // Posted Date and Deadline
                    HStack(spacing: 8) {
                        // Left: Deadline Info
                        if let fechaLimite = oferta.fechaLimite {
                            let daysRemaining = daysUntil(fechaLimite)
                            
                            HStack(spacing: 6) {
                                // Urgency Badge
                                if daysRemaining <= 3 && daysRemaining >= 0 {
                                    HStack(spacing: 4) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .font(.system(size: 9))
                                        Text("URGENTE")
                                            .font(.system(size: 9, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(Color.red)
                                    .cornerRadius(4)
                                }
                                
                                // Deadline Text
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.fill")
                                        .font(.system(size: 9))
                                    Text(formatDeadline(fechaLimite, daysRemaining: daysRemaining))
                                        .font(.system(size: 10, weight: .medium))
                                }
                                .foregroundColor(daysRemaining <= 3 ? .red : .orange)
                            }
                        }
                        
                        Spacer()
                        
                        // Right: Posted Date
                        Text(formatDate(oferta.fechaPublicacion))
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, oferta.esPremium ? 16 : 16)
            .padding(.bottom, oferta.esPremium ? 16 : 0)
            .padding(.top, oferta.esPremium ? 0 : 16)
            
            // Action Buttons
            HStack(spacing: 8) {
                Text("Ver Detalles")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.primaryOrange)
                    .cornerRadius(8)
                
                Button(action: onBookmarkTap) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 14))
                        .foregroundColor(isBookmarked ? .primaryOrange : .textSecondary)
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.borderColor.opacity(0.3))
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(oferta.esPremium ? Color.primaryOrange : Color.borderColor, lineWidth: oferta.esPremium ? 2 : 1)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.day], from: date, to: now)
        
        if let days = components.day {
            if days == 0 {
                return "Hoy"
            } else if days == 1 {
                return "Hace 1 día"
            } else if days < 7 {
                return "Hace \(days) días"
            } else if days < 30 {
                let weeks = days / 7
                return "Hace \(weeks) semana\(weeks > 1 ? "s" : "")"
            } else {
                let months = days / 30
                return "Hace \(months) mes\(months > 1 ? "es" : "")"
            }
        }
        
        return "Hace tiempo"
    }
    
    private func daysUntil(_ date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: date)
        return components.day ?? 0
    }
    
    private func formatDeadline(_ date: Date, daysRemaining: Int) -> String {
        if daysRemaining < 0 {
            return "Expirado"
        } else if daysRemaining == 0 {
            return "Cierra hoy"
        } else if daysRemaining == 1 {
            return "Cierra mañana"
        } else if daysRemaining <= 7 {
            return "Cierra en \(daysRemaining) días"
        } else {
            let weeks = daysRemaining / 7
            return "Cierra en \(weeks) semana\(weeks > 1 ? "s" : "")"
        }
    }
}

// MARK: - Application Card View
struct ApplicationCardView: View {
    let aplicacion: AplicacionEstudiante
    
    var statusColor: Color {
        switch aplicacion.status {
        case .pendiente: return .yellow
        case .revisado: return .blue
        case .rechazado: return .red
        case .aceptado: return .green
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                // Company Logo
                if let fotoPerfil = aplicacion.fotoPerfil, !fotoPerfil.isEmpty {
                    AsyncImage(url: URL(string: fotoPerfil)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.borderColor, lineWidth: 1))
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }
                
                // Job Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(aplicacion.titulo)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text(aplicacion.nombreEmpresa)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 9))
                        Text(formatApplicationDate(aplicacion.fechaAplicacion))
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.textSecondary)
                    
                    // Status Badge
                    HStack(spacing: 6) {
                        Image(systemName: aplicacion.status.icon)
                            .font(.system(size: 10))
                        Text(aplicacion.status.displayName)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.2))
                    .cornerRadius(20)
                }
                
                Spacer()
            }
            
            // View Details Button
            Button(action: {}) {
                Text("Ver Detalles")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primaryOrange)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.primaryOrange.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.primaryOrange, lineWidth: 1)
                    )
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    private func formatApplicationDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.day], from: date, to: now)
        
        if let days = components.day {
            if days == 0 {
                return "Aplicado hoy"
            } else if days == 1 {
                return "Aplicado hace 1 día"
            } else if days < 7 {
                return "Aplicado hace \(days) días"
            } else if days < 30 {
                let weeks = days / 7
                return "Aplicado hace \(weeks) semana\(weeks > 1 ? "s" : "")"
            } else {
                let months = days / 30
                return "Aplicado hace \(months) mes\(months > 1 ? "es" : "")"
            }
        }
        
        return "Aplicado hace tiempo"
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.textSecondary)
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding(.vertical, 60)
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("Error al cargar datos")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: onRetry) {
                Text("Reintentar")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.primaryOrange)
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 60)
    }
}

// MARK: - Job Loading Skeleton
struct JobLoadingSkeleton: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 14)
                        .frame(maxWidth: .infinity)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 12)
                        .frame(width: 120)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 10)
                        .frame(width: 100)
                }
            }
            .padding(16)
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .opacity(isAnimating ? 0.5 : 1.0)
        .animation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        EmpleosEstudianteView()
    }
    .preferredColorScheme(.light)
}
