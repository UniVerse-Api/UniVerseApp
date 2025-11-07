
// Views/Empresa/CrearPublicacionView.swift
import SwiftUI

enum PublicationType {
    case post
    case job
    case announcement
}

struct CrearPublicacionView: View {
    @State private var selectedType: PublicationType = .post
    @State private var postTitle = ""
    @State private var postContent = ""
    @State private var announcementTitle = ""
    @State private var announcementDescription = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var allowComments = true
    @State private var promotePost = false
    @State private var schedulePost = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Publication Type Selector
                        publicationTypeSection
                        
                        // Dynamic Form Based on Type
                        if selectedType == .post {
                            postFormSection
                        } else if selectedType == .announcement {
                            announcementFormSection
                        }
                        
                        // Advanced Options
                        advancedOptionsSection
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 100)
                }
                
                Spacer()
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
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text("Crear Publicación")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        // Save as draft
                    }) {
                        Text("Borrador")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                    }
                    
                    Button(action: {
                        // Publish
                    }) {
                        Text("Publicar")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.primaryOrange)
                            .cornerRadius(20)
                    }
                }
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
    
    // MARK: - Publication Type Section
    private var publicationTypeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tipo de Publicación")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text("Elige el tipo de contenido que quieres compartir con la comunidad")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 12) {
                // Post Option
                PublicationTypeButton(
                    icon: "doc.text.fill",
                    title: "Post",
                    subtitle: "Actualización general",
                    isSelected: selectedType == .post
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedType = .post
                    }
                }
                
                // Job Offer Option
                PublicationTypeButton(
                    icon: "briefcase.fill",
                    title: "Oferta de Trabajo",
                    subtitle: "Formulario completo",
                    isSelected: selectedType == .job
                ) {
                    // Navigate to job posting view
                }
                
                // Announcement Option
                PublicationTypeButton(
                    icon: "megaphone.fill",
                    title: "Anuncio",
                    subtitle: "Promoción destacada",
                    isSelected: selectedType == .announcement
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedType = .announcement
                    }
                }
            }
        }
    }
    
    // MARK: - Post Form Section
    private var postFormSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // Company Logo
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Text("I")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 16) {
                    TextField("Título de tu publicación...", text: $postTitle)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .placeholder(when: postTitle.isEmpty) {
                            Text("Título de tu publicación...")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textSecondary)
                        }
                    
                    TextEditor(text: $postContent)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .frame(minHeight: 120)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                }
            }
            .padding(16)
            
            // Media Upload Buttons
            HStack(spacing: 16) {
                MediaUploadButton(icon: "photo", label: "Imagen")
                MediaUploadButton(icon: "video", label: "Video")
                MediaUploadButton(icon: "paperclip", label: "Archivo")
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.borderColor.opacity(0.3))
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Announcement Form Section
    private var announcementFormSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 255/255, green: 182/255, blue: 52/255))
                
                Text("Crear Anuncio Premium")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 16) {
                // Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Título del Anuncio *")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    TextField("ej. Únete a nuestro programa de graduados", text: $announcementTitle)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                }
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descripción *")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    TextEditor(text: $announcementDescription)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(height: 100)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                    
                    Text("Máximo 500 caracteres")
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                }
                
                // Dates
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fecha de Inicio")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.textSecondary)
                        
                        HStack {
                            DatePicker("", selection: $startDate, displayedComponents: .date)
                                .labelsHidden()
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fecha de Fin")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.textSecondary)
                        
                        HStack {
                            DatePicker("", selection: $endDate, displayedComponents: .date)
                                .labelsHidden()
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                    }
                }
                
                // Image Upload
                VStack(alignment: .leading, spacing: 8) {
                    Text("Imagen del Anuncio")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    Button(action: {}) {
                        VStack(spacing: 8) {
                            Image(systemName: "cloud.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.textSecondary)
                            
                            Text("Haz clic para subir imagen")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(
                                    style: StrokeStyle(lineWidth: 2, dash: [5])
                                )
                                .foregroundColor(.borderColor)
                        )
                    }
                }
            }
            
            // Pricing Info
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 255/255, green: 182/255, blue: 52/255))
                    
                    Text("Información del Anuncio")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    InfoRow(text: "Los anuncios aparecen destacados en el feed principal")
                    InfoRow(text: "Mayor visibilidad y alcance entre estudiantes")
                    InfoRow(text: "Incluye analytics de rendimiento")
                    InfoRow(text: "Costo: €50/día (mínimo 3 días)")
                }
            }
            .padding(16)
            .background(Color(red: 255/255, green: 182/255, blue: 52/255).opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 255/255, green: 182/255, blue: 52/255).opacity(0.3), lineWidth: 1)
            )
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Advanced Options Section
    private var advancedOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Opciones Avanzadas")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 0) {
                ToggleOption(
                    title: "Permitir comentarios",
                    subtitle: "Los usuarios pueden comentar en tu publicación",
                    isOn: $allowComments
                )
                
                Divider()
                    .background(Color.borderColor)
                
                ToggleOption(
                    title: "Promocionar publicación",
                    subtitle: "Aumenta el alcance de tu contenido (+€10)",
                    isOn: $promotePost
                )
                
                Divider()
                    .background(Color.borderColor)
                
                ToggleOption(
                    title: "Programar publicación",
                    subtitle: "Publica en una fecha específica",
                    isOn: $schedulePost
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
}

// MARK: - Supporting Views

struct PublicationTypeButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.primaryOrange.opacity(0.2) : Color.backgroundLight.opacity(0.05))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(isSelected ? Color.primaryOrange.opacity(0.1) : Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.primaryOrange : Color.borderColor, lineWidth: 2)
            )
        }
    }
}

struct MediaUploadButton: View {
    let icon: String
    let label: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                
                Text(label)
                    .font(.system(size: 13))
            }
            .foregroundColor(.textSecondary)
        }
    }
}

struct ToggleOption: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .primaryOrange))
        }
        .padding(.vertical, 12)
    }
}

struct InfoRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.system(size: 13))
                .foregroundColor(Color(red: 255/255, green: 182/255, blue: 52/255))
            
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        CrearPublicacionView()
    }
    .preferredColorScheme(.dark)
}
