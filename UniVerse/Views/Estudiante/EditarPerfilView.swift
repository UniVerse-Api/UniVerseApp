// Views/Estudiante/EditarPerfilView.swift
import SwiftUI
import PhotosUI

struct ProfileSkill: Identifiable {
    let id = UUID()
    var name: String
}

struct ProfileLanguage: Identifiable {
    let id = UUID()
    var flag: String
    var name: String
    var level: LanguageLevel
}

enum LanguageLevel: String, CaseIterable {
    case basico = "Básico"
    case intermedio = "Intermedio"
    case avanzado = "Avanzado"
    case nativo = "Nativo"
}

struct EditarPerfilView: View {
    @State private var profileImage: Image?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showingImagePicker = false
    @State private var showingDeleteConfirmation = false
    @State private var showingSaveConfirmation = false
    
    // Basic Information
    @State private var fullName = "Alexandra Chen"
    @State private var email = "alexandra.chen@universidad.edu"
    @State private var phone = "+1 (415) 555-0123"
    @State private var location = "San Francisco, CA"
    @State private var bio = "Estudiante apasionada por el desarrollo de software escalable y con sólida base en estructuras de datos y algoritmos. Busco aplicar mis conocimientos académicos a desafíos del mundo real."
    
    // Skills
    @State private var skills = [
        ProfileSkill(name: "Python"),
        ProfileSkill(name: "JavaScript"),
        ProfileSkill(name: "React")
    ]
    
    // Languages
    @State private var languages = [
        ProfileLanguage(flag: "🇺🇸", name: "Inglés", level: .avanzado),
        ProfileLanguage(flag: "🇨🇳", name: "Mandarín", level: .intermedio)
    ]
    
    @Environment(\.presentationMode) var presentationMode
    
    let availableFlags = ["🇺🇸", "🇪🇸", "🇫🇷", "🇩🇪", "🇨🇳", "🇯🇵"]
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                editProfileHeader
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Photo Section
                        photoSection
                        
                        // Basic Information
                        basicInformationSection
                        
                        // Skills
                        skillsSection
                        
                        // Languages
                        languagesSection
                        
                        // Save/Cancel Buttons
                        actionButtons
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Perfil Actualizado", isPresented: $showingSaveConfirmation) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Los cambios han sido guardados correctamente")
        }
        .alert("Eliminar Foto", isPresented: $showingDeleteConfirmation) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                profileImage = nil
            }
        } message: {
            Text("¿Estás seguro de que deseas eliminar tu foto de perfil?")
        }
    }
    
    // MARK: - Header Section
    private var editProfileHeader: some View {
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
                
                Spacer()
                
                Text("Editar Perfil")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    saveProfile()
                }) {
                    Text("Guardar")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primaryOrange)
                        .padding(8)
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
    
    // MARK: - Photo Section
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Foto de Perfil")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                // Profile Photo
                ZStack {
                    // Animated gradient border
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple, .indigo]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 88, height: 88)
                        .blur(radius: 4)
                        .opacity(0.75)
                    
                    if let profileImage = profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.backgroundDark, lineWidth: 2)
                            )
                    } else {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.backgroundDark, lineWidth: 2)
                            )
                    }
                }
                
                VStack(spacing: 8) {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        HStack(spacing: 6) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 12))
                            Text("Cambiar Foto")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.primaryOrange)
                        .cornerRadius(8)
                    }
                    .onChange(of: selectedPhotoItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                profileImage = Image(uiImage: uiImage)
                            }
                        }
                    }
                    
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 12))
                            Text("Eliminar")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Basic Information Section
    private var basicInformationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Información Básica")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 16) {
                // Name and Email Row
                HStack(spacing: 12) {
                    ProfileTextField(
                        label: "Nombre Completo *",
                        text: $fullName
                    )
                    
                    ProfileTextField(
                        label: "Email *",
                        text: $email,
                        keyboardType: .emailAddress
                    )
                }
                
                // Phone and Location Row
                HStack(spacing: 12) {
                    ProfileTextField(
                        label: "Teléfono",
                        text: $phone,
                        keyboardType: .phonePad
                    )
                    
                    ProfileTextField(
                        label: "Ubicación",
                        text: $location
                    )
                }
                
                // Bio
                VStack(alignment: .leading, spacing: 6) {
                    Text("Biografía")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    TextEditor(text: $bio)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Skills Section
    private var skillsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(.primaryOrange)
                    
                    Text("Habilidades Técnicas")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {
                    addSkill()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 12))
                        Text("Agregar")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
            
            VStack(spacing: 10) {
                ForEach(skills.indices, id: \.self) { index in
                    ProfileSkillRow(
                        skill: $skills[index],
                        onDelete: {
                            skills.remove(at: index)
                        }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Languages Section
    private var languagesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "globe")
                        .font(.system(size: 16))
                        .foregroundColor(.primaryOrange)
                    
                    Text("Idiomas")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {
                    addLanguage()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 12))
                        Text("Agregar")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
            
            VStack(spacing: 10) {
                ForEach(languages.indices, id: \.self) { index in
                    ProfileLanguageRow(
                        language: $languages[index],
                        availableFlags: availableFlags,
                        onDelete: {
                            languages.remove(at: index)
                        }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(action: {
                saveProfile()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                    Text("Guardar Cambios")
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.primaryOrange)
                .cornerRadius(8)
            }
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancelar")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Helper Functions
    private func addSkill() {
        skills.append(ProfileSkill(name: ""))
    }
    
    private func addLanguage() {
        languages.append(ProfileLanguage(flag: "🇺🇸", name: "", level: .basico))
    }
    
    private func saveProfile() {
        showingSaveConfirmation = true
    }
}

// MARK: - Profile Text Field Component
struct ProfileTextField: View {
    let label: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.textSecondary)
            
            TextField("", text: $text)
                .padding(12)
                .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.borderColor, lineWidth: 1)
                )
                .foregroundColor(.white)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
        }
    }
}

// MARK: - Profile Skill Row Component
struct ProfileSkillRow: View {
    @Binding var skill: ProfileSkill
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            TextField("Nueva habilidad", text: $skill.name)
                .padding(10)
                .foregroundColor(.white)
            
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(8)
            }
        }
        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Profile Language Row Component
struct ProfileLanguageRow: View {
    @Binding var language: ProfileLanguage
    let availableFlags: [String]
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Flag Picker
            Menu {
                ForEach(availableFlags, id: \.self) { flag in
                    Button(action: {
                        language.flag = flag
                    }) {
                        Text(flag)
                            .font(.system(size: 24))
                    }
                }
            } label: {
                Text(language.flag)
                    .font(.system(size: 28))
                    .padding(4)
            }
            
            // Language Name
            TextField("Idioma", text: $language.name)
                .padding(8)
                .foregroundColor(.white)
            
            // Level Picker
            Menu {
                ForEach(LanguageLevel.allCases, id: \.self) { level in
                    Button(action: {
                        language.level = level
                    }) {
                        Text(level.rawValue)
                    }
                }
            } label: {
                Text(language.level.rawValue)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.borderColor, lineWidth: 1)
                    )
            }
            
            // Delete Button
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(8)
            }
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

// MARK: - Preview
#Preview {
    NavigationView {
        EditarPerfilView()
    }
    .preferredColorScheme(.dark)
}
