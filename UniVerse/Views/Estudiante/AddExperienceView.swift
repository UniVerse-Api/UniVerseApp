import SwiftUI

struct AddExperienceView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var perfilService = PerfilService()
    
    let perfilId: Int
    let onExperienceAdded: () -> Void
    
    @State private var empresa = ""
    @State private var puesto = ""
    @State private var selectedTipo: TipoExperienciaLaboral = .tiempoCompleto
    @State private var fechaInicio = Date()
    @State private var fechaFin = Date()
    @State private var isCurrentJob = false
    @State private var descripcion = ""
    @State private var selectedUbicacion = ""
    @State private var customUbicacion = ""
    @State private var isCustomUbicacion = false
    
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundLight.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection
                        
                        // Form
                        formSection
                        
                        // Add Button
                        addButton
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") {
                if alertTitle == "¡Éxito!" {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .frame(width: 32, height: 32)
                        .background(Color.cardBackground)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Agregar Experiencia")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                // Placeholder for symmetry
                Color.clear
                    .frame(width: 32, height: 32)
            }
            
            Text("Comparte tu experiencia laboral y destaca tu trayectoria profesional")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 20) {
            // Company and Position
            companyPositionCard
            
            // Experience Type
            experienceTypeCard
            
            // Dates
            datesCard
            
            // Location
            locationCard
            
            // Description
            descriptionCard
        }
    }
    
    // MARK: - Company and Position Card
    private var companyPositionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 16))
                
                Text("Empresa y Puesto")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: 12) {
                TextField("Nombre de la empresa", text: $empresa)
                    .textFieldStyle(CustomTextFieldStyle())
                
                TextField("Puesto o cargo", text: $puesto)
                    .textFieldStyle(CustomTextFieldStyle())
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Experience Type Card
    private var experienceTypeCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "briefcase.fill")
                    .foregroundColor(.purple)
                    .font(.system(size: 16))
                
                Text("Tipo de Experiencia")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(TipoExperienciaLaboral.allCases, id: \.self) { tipo in
                    TipoExperienciaButton(
                        tipo: tipo,
                        isSelected: selectedTipo == tipo,
                        action: { selectedTipo = tipo }
                    )
                }
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Dates Card
    private var datesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "calendar.badge.checkmark")
                    .foregroundColor(.green)
                    .font(.system(size: 16))
                
                Text("Fechas")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: 16) {
                // Start Date
                VStack(alignment: .leading, spacing: 8) {
                    Text("Fecha de Inicio")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textPrimary)
                    
                    DatePicker(
                        "Fecha de inicio",
                        selection: $fechaInicio,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.compact)
                    .accentColor(.primaryOrange)
                }
                
                // Current Job Toggle
                Toggle("Trabajo Actual", isOn: $isCurrentJob)
                    .font(.system(size: 14, weight: .medium))
                    .toggleStyle(SwitchToggleStyle(tint: .primaryOrange))
                
                // End Date (if not current job)
                if !isCurrentJob {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fecha de Fin")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.textPrimary)
                        
                        DatePicker(
                            "Fecha de fin",
                            selection: $fechaFin,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.compact)
                        .accentColor(.primaryOrange)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Location Card
    private var locationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "location.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 16))
                
                Text("Ubicación")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
                // Toggle between predefined and custom
                HStack(spacing: 0) {
                    Button(action: {
                        isCustomUbicacion = false
                        customUbicacion = ""
                    }) {
                        Text("Seleccionar")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(isCustomUbicacion ? .textSecondary : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isCustomUbicacion ? Color.clear : Color.primaryOrange)
                    }
                    .overlay(
                        Rectangle()
                            .stroke(Color.primaryOrange, lineWidth: 1)
                    )
                    
                    Button(action: {
                        isCustomUbicacion = true
                        selectedUbicacion = ""
                    }) {
                        Text("Personalizar")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(!isCustomUbicacion ? .textSecondary : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(!isCustomUbicacion ? Color.clear : Color.primaryOrange)
                    }
                    .overlay(
                        Rectangle()
                            .stroke(Color.primaryOrange, lineWidth: 1)
                    )
                }
                .cornerRadius(8);          if isCustomUbicacion {
                TextField("Ubicación personalizada", text: $customUbicacion)
                    .textFieldStyle(CustomTextFieldStyle())
            } else {
                Menu {
                    ForEach(Ubicaciones, id: \.self) { ubicacion in
                        Button(ubicacion) {
                            selectedUbicacion = ubicacion
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedUbicacion.isEmpty ? "Selecciona una ubicación" : selectedUbicacion)
                            .foregroundColor(selectedUbicacion.isEmpty ? .textSecondary : .textPrimary)
                            .font(.system(size: 14))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.textSecondary)
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.borderColor, lineWidth: 1)
                    )
                }
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Description Card
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "text.alignleft")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                
                Text("Descripción (Opcional)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            TextEditor(text: $descripcion)
                .frame(minHeight: 100)
                .padding(12)
                .background(Color.inputBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.borderColor, lineWidth: 1)
                )
                .font(.system(size: 14))
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button(action: {
            addExperience()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16))
                }
                
                Text(isLoading ? "Agregando..." : "Agregar Experiencia")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.primaryOrange, .primaryOrange.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .disabled(isLoading || !isFormValid)
            .opacity(isFormValid ? 1.0 : 0.6)
        }
        .padding(.top, 10)
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        let hasEmpresa = !empresa.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasPuesto = !puesto.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasValidDates = isCurrentJob || fechaFin >= fechaInicio
        
        return hasEmpresa && hasPuesto && hasValidDates
    }
    
    private var finalUbicacion: String? {
        if isCustomUbicacion {
            let custom = customUbicacion.trimmingCharacters(in: .whitespacesAndNewlines)
            return custom.isEmpty ? nil : custom
        } else {
            return selectedUbicacion.isEmpty ? nil : selectedUbicacion
        }
    }
    
    // MARK: - Methods
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
    
    private func addExperience() {
        guard isFormValid else { return }
        
        isLoading = true
        
        Task {
            do {
                let response = try await perfilService.agregarExperiencia(
                    idPerfil: perfilId,
                    empresa: empresa.trimmingCharacters(in: .whitespacesAndNewlines),
                    tipo: selectedTipo,
                    puesto: puesto.trimmingCharacters(in: .whitespacesAndNewlines),
                    fechaInicio: fechaInicio,
                    fechaFin: isCurrentJob ? nil : fechaFin,
                    descripcion: descripcion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : descripcion.trimmingCharacters(in: .whitespacesAndNewlines),
                    ubicacion: finalUbicacion
                )
                
                await MainActor.run {
                    isLoading = false
                    
                    if response.success {
                        alertTitle = "¡Éxito!"
                        alertMessage = "La experiencia se agregó correctamente."
                        showingAlert = true
                        
                        // Notify parent view
                        onExperienceAdded()
                    } else {
                        alertTitle = "Error"
                        alertMessage = response.message
                        showingAlert = true
                    }
                }
                
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertTitle = "Error"
                    alertMessage = "No se pudo agregar la experiencia. Inténtalo de nuevo."
                    showingAlert = true
                }
            }
        }
    }
}

// MARK: - Supporting Components
struct TipoExperienciaButton: View {
    let tipo: TipoExperienciaLaboral
    let isSelected: Bool
    let action: () -> Void
    
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
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: tipo.icon)
                    .foregroundColor(isSelected ? .white : colorForType(tipo))
                    .font(.system(size: 20))
                
                Text(tipo.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : .textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isSelected
                ? colorForType(tipo)
                : Color.cardBackground
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected
                        ? Color.clear
                        : Color.borderColor,
                        lineWidth: 1
                    )
            )
        }
    }
}

// MARK: - Preview
#Preview {
    AddExperienceView(
        perfilId: 1,
        onExperienceAdded: {}
    )
    .preferredColorScheme(.light)
}
