import SwiftUI

struct ExperienciasView: View {
    let perfilId: Int
    @Environment(\.dismiss) private var dismiss
    @StateObject private var perfilService = PerfilService()
    
    @State private var experiencias: [ExperienciaLaboralItem] = []
    @State private var isLoading = true
    @State private var showAddExperience = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundLight.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerSection
                    
                    if isLoading {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                        Spacer()
                    } else {
                        // Content
                        contentSection
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await loadExperiences()
        }
        .sheet(isPresented: $showAddExperience) {
            AddExperienceView(
                perfilId: perfilId,
                onExperienceAdded: {
                    Task {
                        await loadExperiences()
                    }
                }
            )
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                Text("Experiencia Laboral")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: {
                    showAddExperience = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primaryOrange)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.backgroundLight)
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if experiencias.isEmpty {
                    emptyStateView
                } else {
                    ForEach(experiencias) { experiencia in
                        ExperienceCard(experiencia: experiencia)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "briefcase")
                .font(.system(size: 64))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 8) {
                Text("No tienes experiencias registradas")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text("Agrega tu primera experiencia laboral para destacar tu trayectoria profesional")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showAddExperience = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16))
                    
                    Text("Agregar Experiencia")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.primaryOrange, .primaryOrange.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(24)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Methods
    private func loadExperiences() async {
        do {
            let response = try await perfilService.getExperienciasPerfil(idPerfil: perfilId)
            
            await MainActor.run {
                if response.success {
                    experiencias = response.experiencias ?? []
                } else {
                    alertTitle = "Error"
                    alertMessage = response.message ?? "No se pudieron cargar las experiencias"
                    showingAlert = true
                }
                isLoading = false
            }
        } catch {
            await MainActor.run {
                alertTitle = "Error"
                alertMessage = "No se pudieron cargar las experiencias. Inténtalo de nuevo."
                showingAlert = true
                isLoading = false
            }
        }
    }
}

// MARK: - Experience Card Component
struct ExperienceCard: View {
    let experiencia: ExperienciaLaboralItem
    
    private var isCurrentJob: Bool {
        experiencia.fechaFin == nil
    }
    
    private var formattedDuration: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = formatter.date(from: experiencia.fechaInicio) else {
            return experiencia.fechaInicio
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM yyyy"
        displayFormatter.locale = Locale(identifier: "es_ES")
        
        let startString = displayFormatter.string(from: startDate)
        
        if let fechaFinString = experiencia.fechaFin,
           let endDate = formatter.date(from: fechaFinString) {
            let endString = displayFormatter.string(from: endDate)
            return "\(startString) - \(endString)"
        } else {
            return "\(startString) - Presente"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with company and type
            HStack(alignment: .top, spacing: 12) {
                // Type Icon
                ZStack {
                    Circle()
                        .fill(colorForType(experiencia.tipo).opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: experiencia.tipo.icon)
                        .foregroundColor(colorForType(experiencia.tipo))
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    // Company name
                    Text(experiencia.empresa)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    // Position
                    Text(experiencia.puesto)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primaryOrange)
                    
                    // Type and Duration
                    HStack(spacing: 8) {
                        Text(experiencia.tipo.displayName)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(colorForType(experiencia.tipo))
                            .cornerRadius(12)
                        
                        Text(formattedDuration)
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                if isCurrentJob {
                    Text("ACTUAL")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            // Location
            if let ubicacion = experiencia.ubicacion, !ubicacion.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 12))
                    
                    Text(ubicacion)
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
            }
            
            // Description
            if let descripcion = experiencia.descripcion, !descripcion.isEmpty {
                Text(descripcion)
                    .font(.system(size: 14))
                    .foregroundColor(.textPrimary)
                    .lineLimit(nil)
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
    }
    
    private func colorForType(_ tipo: TipoExperienciaLaboral) -> Color {
        switch tipo.color {
        case "blue":
            return .blue
        case "green":
            return .green
        case "orange":
            return .orange
        case "red":
            return .red
        default:
            return .gray
        }
    }
}

// MARK: - Preview
#Preview {
    ExperienciasView(perfilId: 1)
        .preferredColorScheme(.light)
}
