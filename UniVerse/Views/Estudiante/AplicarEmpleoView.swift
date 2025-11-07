
// Views/Estudiante/AplicarEmpleoView.swift
import SwiftUI

enum CVOption {
    case existing
    case upload
}

struct Job {
    let title: String
    let company: String
    let logoUrl: String
    let location: String
    let type: String
    let isVerified: Bool
}

struct AplicarEmpleoView: View {
    @State private var selectedCV: CVOption = .existing
    @State private var coverLetter = ""
    @State private var email = "maria.rodriguez@email.com"
    @State private var phone = "+1 (555) 123-4567"
    @State private var availability = "Inmediatamente"
    @State private var hasWorkAuth = false
    @State private var showSuccessModal = false
    @State private var isSubmitting = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let availabilityOptions = ["Inmediatamente", "En 2 semanas", "En 1 mes", "En 2 meses", "Otro"]
    
    let job = Job(
        title: "Desarrollador Full Stack Junior",
        company: "Innovate Inc.",
        logoUrl: "building.2.fill",
        location: "San Francisco, CA",
        type: "Tiempo Completo",
        isVerified: true
    )
    
    var characterCount: Int {
        coverLetter.count
    }
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Job Info Card
                        jobInfoCard
                        
                        // CV Selection
                        cvSelectionSection
                        
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
                        .foregroundColor(.white)
                        .padding(8)
                }
                
                Text("Aplicar a Empleo")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.backgroundDark.opacity(0.8))
        .backdrop()
    }
    
    // MARK: - Job Info Card
    private var jobInfoCard: some View {
        HStack(spacing: 12) {
            // Company Logo
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 64, height: 64)
                
                Image(systemName: job.logoUrl)
                    .font(.system(size: 32))
                    .foregroundColor(.blue)
            }
            
            // Job Details
            VStack(alignment: .leading, spacing: 4) {
                Text(job.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 6) {
                    Text(job.company)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    if job.isVerified {
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
                        Text(job.location)
                            .font(.system(size: 11))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                        Text(job.type)
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
    
    // MARK: - CV Selection Section
    private var cvSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Currículum Vitae")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                // Existing CV Option
                Button(action: {
                    selectedCV = .existing
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: selectedCV == .existing ? "circle.inset.filled" : "circle")
                            .font(.system(size: 20))
                            .foregroundColor(.primaryOrange)
                        
                        Image(systemName: "doc.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("CV_Actualizado_2024.pdf")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text("Subido: 15 Oct 2024 • 2.3 MB")
                                .font(.system(size: 11))
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                    }
                    .padding(12)
                    .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedCV == .existing ? Color.primaryOrange : Color.borderColor, lineWidth: selectedCV == .existing ? 2 : 1)
                    )
                }
                
                // Upload New CV Option
                Button(action: {
                    selectedCV = .upload
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: selectedCV == .upload ? "circle.inset.filled" : "circle")
                            .font(.system(size: 20))
                            .foregroundColor(.primaryOrange)
                        
                        Image(systemName: "arrow.up.doc.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.textSecondary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Subir nuevo CV")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text("Formatos: PDF, DOC, DOCX (Max 5MB)")
                                .font(.system(size: 11))
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                    }
                    .padding(12)
                    .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedCV == .upload ? Color.primaryOrange : Color.borderColor, lineWidth: selectedCV == .upload ? 2 : 1)
                    )
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
    
    // MARK: - Cover Letter Section
    private var coverLetterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Carta de Presentación")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                TextEditor(text: $coverLetter)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.borderColor, lineWidth: 1)
                    )
                    .foregroundColor(.white)
                
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
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email de contacto")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    TextField("tu.email@ejemplo.com", text: $email)
                        .padding(12)
                        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Teléfono")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    TextField("+1 (555) 123-4567", text: $phone)
                        .padding(12)
                        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                        .foregroundColor(.white)
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
                    .foregroundColor(.white)
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
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.textSecondary)
                        }
                        .padding(12)
                        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                    }
                }
                
                Button(action: {
                    hasWorkAuth.toggle()
                }) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: hasWorkAuth ? "checkmark.square.fill" : "square")
                            .font(.system(size: 20))
                            .foregroundColor(hasWorkAuth ? .primaryOrange : .textSecondary)
                        
                        Text("Confirmo que tengo autorización legal para trabajar en Estados Unidos")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
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
        .background(Color.backgroundDark)
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
                        .foregroundColor(.white)
                    
                    Text("Tu aplicación ha sido enviada exitosamente a **Innovate Inc.** Recibirás una confirmación por email y te notificaremos sobre el estado de tu aplicación.")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        showSuccessModal = false
                        // Navigate to applications
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
                    }) {
                        Text("Seguir Buscando Empleos")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
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
        isSubmitting = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            showSuccessModal = true
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        AplicarEmpleoView()
    }
    .preferredColorScheme(.dark)
}
