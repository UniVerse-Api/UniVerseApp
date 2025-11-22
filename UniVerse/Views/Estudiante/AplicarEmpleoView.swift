
// Views/Estudiante/AplicarEmpleoView.swift
import SwiftUI



struct AplicarEmpleoView: View {
    let oferta: OfertaEstudiante
    
    @State private var coverLetter = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var availability = "Inmediatamente"
    @State private var showSuccessModal = false
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    
    @StateObject private var ofertaService = OfertaService()
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let availabilityOptions = ["Inmediatamente", "En 2 semanas", "En 1 mes", "En 2 meses", "Otro"]
    
    var characterCount: Int {
        coverLetter.count
    }
    
    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Job Info Card
                        jobInfoCard
                        
                        // Cover Letter
                        coverLetterSection
                        
                        // Contact Information
                        contactInfoSection
                        
                        // Additional Information
                        additionalInfoSection
                        
                        // Privacy Notice
                        privacyNotice
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
            
            // Submit Button (Fixed at bottom)
            VStack {
                Spacer()
                submitButton
            }
            
            // Success Modal
            if showSuccessModal {
                successModal
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadUserData()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .foregroundColor(.textPrimary)
                        .padding(8)
                }
                
                Text("Aplicar a Empleo")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.backgroundLight.opacity(0.95))
        .backdrop()
    }
    
    // MARK: - Job Info Card
    private var jobInfoCard: some View {
        HStack(spacing: 12) {
            // Company Logo
            if let fotoPerfil = oferta.fotoPerfil, !fotoPerfil.isEmpty {
                AsyncImage(url: URL(string: fotoPerfil)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 64, height: 64)
                        
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                    }
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
            }
            
            // Job Details
            VStack(alignment: .leading, spacing: 4) {
                Text(oferta.titulo)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                HStack(spacing: 6) {
                    Text(oferta.nombreCompleto)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    if oferta.esPremium {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 16, height: 16)
                            
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 10))
                        Text(oferta.ubicacion)
                            .font(.system(size: 11))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                        Text(oferta.tipoOferta.displayName)
                            .font(.system(size: 11))
                    }
                }
                .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }

    
    // MARK: - Cover Letter Section
    private var coverLetterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Carta de Presentación")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: 8) {
                TextEditor(text: $coverLetter)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color.inputBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.borderColor, lineWidth: 1)
                    )
                    .foregroundColor(.textPrimary)
                
                HStack {
                    Text("Mínimo 50 caracteres recomendado")
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text("\(characterCount)/500")
                        .font(.system(size: 11))
                        .foregroundColor(characterCount > 500 ? .red : .textSecondary)
                }
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
    
    // MARK: - Contact Info Section
    private var contactInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Información de Contacto")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email de contacto")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    TextField("correo@ejemplo.com", text: $email)
                        .padding(12)
                        .background(Color.inputBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                        .foregroundColor(.textPrimary)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Teléfono")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    TextField("+1 (555) 123-4567", text: $phone)
                        .padding(12)
                        .background(Color.inputBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                        .foregroundColor(.textPrimary)
                        .keyboardType(.phonePad)
                }
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
    
    // MARK: - Additional Info Section
    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Información Adicional")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("¿Cuándo estarías disponible para empezar?")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    Menu {
                        ForEach(availabilityOptions, id: \.self) { option in
                            Button(option) {
                                availability = option
                            }
                        }
                    } label: {
                        HStack {
                            Text(availability)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.textSecondary)
                        }
                        .padding(12)
                        .background(Color.inputBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                    }
                }
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
    
    // MARK: - Privacy Notice
    private var privacyNotice: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "hand.raised.fill")
                .font(.system(size: 20))
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Privacidad de tus datos")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
                
                Text("Tu información será compartida únicamente con Innovate Inc. para procesar tu aplicación. Puedes revisar nuestra política de privacidad para más detalles.")
                    .font(.system(size: 12))
                    .foregroundColor(.blue.opacity(0.9))
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.indigo.opacity(0.1)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Submit Button
    private var submitButton: some View {
        VStack(spacing: 8) {
            Button(action: {
                submitApplication()
            }) {
                HStack(spacing: 8) {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        Text("Enviando...")
                    } else {
                        Image(systemName: "paperplane.fill")
                        Text("Enviar Aplicación")
                    }
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.primaryOrange)
                .cornerRadius(8)
            }
            .disabled(isSubmitting)
            
            Text("Al enviar confirmas que la información proporcionada es veraz y completa")
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundLight)
        .overlay(
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1),
            alignment: .top
        )
    }
    
    // MARK: - Success Modal
    private var successModal: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    showSuccessModal = false
                }
            
            VStack(spacing: 20) {
                // Success Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                }
                
                // Success Message
                VStack(spacing: 8) {
                    Text("¡Aplicación Enviada!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text("Tu aplicación ha sido enviada exitosamente a **Innovate Inc.** Puedes consultar en cualquier momentoel estado de tu aplicación.")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        showSuccessModal = false
                        // Navigate back to job list and switch to applications tab
                        presentationMode.wrappedValue.dismiss()
                        // Post notification to switch tab
                        NotificationCenter.default.post(name: NSNotification.Name("SwitchToApplicationsTab"), object: nil)
                    }) {
                        Text("Ver Mis Aplicaciones")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.primaryOrange)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        showSuccessModal = false
                        presentationMode.wrappedValue.dismiss()
                        // Post notification to switch to Todos tab
                        NotificationCenter.default.post(name: NSNotification.Name("SwitchToTodosTab"), object: nil)
                    }) {
                        Text("Seguir Buscando Empleos")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(24)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
            .padding(.horizontal, 32)
        }
    }
    
    // MARK: - Submit Application
    private func submitApplication() {
        guard let perfil = authViewModel.currentUser?.perfil else {
            errorMessage = "No se pudo obtener el perfil del usuario"
            return
        }
        
        // Validar campos requeridos
        guard !coverLetter.isEmpty else {
            errorMessage = "La carta de presentación es requerida"
            return
        }
        
        guard !email.isEmpty else {
            errorMessage = "El email es requerido"
            return
        }
        
        guard !phone.isEmpty else {
            errorMessage = "El teléfono es requerido"
            return
        }
        
        isSubmitting = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await ofertaService.aplicarEmpleo(
                    idOferta: oferta.id,
                    idPerfil: perfil.id,
                    cartaPresentacion: coverLetter,
                    emailContacto: email,
                    telefono: phone,
                    disponibilidad: availability
                )
                
                await MainActor.run {
                    isSubmitting = false
                    if result.success {
                        showSuccessModal = true
                    } else {
                        errorMessage = result.message
                    }
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    errorMessage = "Error al enviar la aplicación: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Load User Data
    private func loadUserData() {
        if let perfil = authViewModel.currentUser?.perfil {
            // Pre-fill phone if available
            if !perfil.telefono.isEmpty {
                phone = perfil.telefono
            }
            // Email will be entered manually by user
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        AplicarEmpleoView(oferta: OfertaEstudiante(
            id: 1,
            titulo: "Desarrollador Full Stack Junior",
            descripcion: "Buscamos un desarrollador Full Stack apasionado para unirse a nuestro equipo.",
            salarioRango: "$1,500 - $2,500 USD",
            tipoOferta: .tiempoCompleto,
            ubicacion: "San Salvador, El Salvador",
            fechaPublicacion: Date().addingTimeInterval(-86400 * 3),
            fechaLimite: Date().addingTimeInterval(86400 * 20),
            idPerfilEmpresa: 1,
            nombreCompleto: "Innovate Inc.",
            fotoPerfil: nil,
            ubicacionEmpresa: "San Salvador, El Salvador",
            requisitos: ["Swift", "SwiftUI", "Node.js", "React"],
            esPremium: true
        ))
    }
    .preferredColorScheme(.light)
    .environmentObject(AuthViewModel())
}
