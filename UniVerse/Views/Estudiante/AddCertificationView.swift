import SwiftUI

struct AddCertificationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var perfilService = PerfilService()
    
    let perfilId: Int
    let onCertificationAdded: () -> Void
    
    @State private var selectedCertification = ""
    @State private var customCertification = ""
    @State private var institution = ""
    @State private var selectedDate = Date()
    @State private var isCustom = false
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
            Button("OK") { }
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
                
                Text("Agregar Certificación")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                // Placeholder for symmetry
                Color.clear
                    .frame(width: 32, height: 32)
            }
            
            Text("Destaca tus logros profesionales agregando una nueva certificación")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 20) {
            // Certification Selection
            certificationSelectionCard
            
            // Institution Field
            institutionCard
            
            // Date Selection
            dateSelectionCard
        }
    }
    
    private var certificationSelectionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "award.fill")
                    .foregroundColor(.primaryOrange)
                    .font(.system(size: 16))
                
                Text("Certificación")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            // Toggle between predefined and custom
            HStack(spacing: 0) {
                Button(action: {
                    isCustom = false
                    customCertification = ""
                }) {
                    Text("Seleccionar")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isCustom ? .textSecondary : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(isCustom ? Color.clear : Color.primaryOrange)
                        .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                }
                .overlay(
                    Rectangle()
                        .stroke(Color.primaryOrange, lineWidth: 1)
                        .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                )
                
                Button(action: {
                    isCustom = true
                    selectedCertification = ""
                }) {
                    Text("Personalizar")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(!isCustom ? .textSecondary : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(!isCustom ? Color.clear : Color.primaryOrange)
                        .cornerRadius(8, corners: [.topRight, .bottomRight])
                }
                .overlay(
                    Rectangle()
                        .stroke(Color.primaryOrange, lineWidth: 1)
                        .cornerRadius(8, corners: [.topRight, .bottomRight])
                )
            }
            
            if isCustom {
                // Custom certification input
                TextField("Nombre de la certificación", text: $customCertification)
                    .textFieldStyle(CustomTextFieldStyle())
            } else {
                // Predefined certification picker
                Menu {
                    ForEach(certificaciones, id: \.self) { cert in
                        Button(cert) {
                            selectedCertification = cert
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCertification.isEmpty ? "Selecciona una certificación" : selectedCertification)
                            .foregroundColor(selectedCertification.isEmpty ? .textSecondary : .textPrimary)
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
    
    private var institutionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 16))
                
                Text("Institución")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            TextField("Nombre de la institución", text: $institution)
                .textFieldStyle(CustomTextFieldStyle())
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    private var dateSelectionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "calendar.badge.checkmark")
                    .foregroundColor(.green)
                    .font(.system(size: 16))
                
                Text("Fecha de Obtención")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            DatePicker(
                "Fecha de obtención",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
            .accentColor(.primaryOrange)
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
            addCertification()
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
                
                Text(isLoading ? "Agregando..." : "Agregar Certificación")
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
        let hasCertification = isCustom ? !customCertification.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                        : !selectedCertification.isEmpty
        let hasInstitution = !institution.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        return hasCertification && hasInstitution
    }
    
    private var certificationTitle: String {
        return isCustom ? customCertification.trimmingCharacters(in: .whitespacesAndNewlines)
                        : selectedCertification
    }
    
    // MARK: - Methods
    private func addCertification() {
        guard isFormValid else { return }
        
        isLoading = true
        
        Task {
            do {
                let response = try await perfilService.agregarCertificacion(
                    idPerfil: perfilId,
                    titulo: certificationTitle,
                    institucion: institution.trimmingCharacters(in: .whitespacesAndNewlines),
                    fechaObtencion: selectedDate
                )
                
                await MainActor.run {
                    isLoading = false
                    
                    if response.success {
                        alertTitle = "¡Éxito!"
                        alertMessage = "La certificación se agregó correctamente."
                        showingAlert = true
                        
                        // Notify parent view and dismiss after alert
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            onCertificationAdded()
                            dismiss()
                        }
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
                    alertMessage = "No se pudo agregar la certificación. Inténtalo de nuevo."
                    showingAlert = true
                }
            }
        }
    }
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
            .font(.system(size: 14))
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
#Preview {
    AddCertificationView(
        perfilId: 1,
        onCertificationAdded: {}
    )
    .preferredColorScheme(.dark)
}
