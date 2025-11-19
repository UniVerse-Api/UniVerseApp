// Empresa/RegistroEmpresaView.swift

import SwiftUI
import UIKit
import PhotosUI
import UniformTypeIdentifiers
import Supabase

// Tipos temporales hasta que se resuelva el problema de importación
struct DocumentInfoEmpresa: Identifiable {
    let id = UUID()
    let name: String
    let data: Data
    let size: Int
    let url: URL
    
    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
    
    var isValidPDF: Bool {
        return name.lowercased().hasSuffix(".pdf") && data.count > 0
    }
}

struct RegistroEmpresaView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var nombreCompleto = ""
    @State private var nombreComercial = ""
    @State private var anioFundacion = ""
    @State private var totalEmpleados = ""
    @State private var telefono = ""
    @State private var biografia = ""
    @State private var ubicacion = ""
    @State private var sitioWeb = ""
    @State private var paisSeleccionado = ""
    @State private var showPaisesDropdown = false
    @State private var ubicacionSeleccionada = ""
    @State private var showUbicacionesDropdown = false
    @State private var acceptTerms = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var emailValidationMessage = ""
    
    // Estados para archivos
    @State private var selectedProfileImage: UIImage?
    @State private var selectedDocument: DocumentInfoEmpresa?
    @State private var isUploadingFiles = false
    
    var body: some View {
        ZStack {
            // Fondo claro
            Color.backgroundLight
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header con botón de back
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primaryPurple)
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        Text("Registro de Empresa")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Card principal
                    VStack(spacing: 24) {
                        
                        // Título y descripción
                        VStack(spacing: 8) {
                            Text("Crea tu cuenta de empresa")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text("Completa la información para registrar tu empresa")
                                .font(.body)
                                .foregroundColor(.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Foto de perfil
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Foto de perfil")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primaryText)
                            
                            ImagePickerOptionsEmpresa(selectedImage: $selectedProfileImage)
                        }
                        
                        // Información básica
                        VStack(spacing: 20) {
                            
                            // Nombre completo del representante
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Nombre completo del representante *")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primaryText)
                                
                                TextField("Ej: Juan Pérez", text: $nombreCompleto)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                            }
                            
                            // Email
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Correo electrónico *")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primaryText)
                                
                                TextField("ejemplo@empresa.com", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(emailBorderColor, lineWidth: 2)
                                    )
                                    .onChange(of: email) { _ in
                                        validateEmail()
                                    }
                                
                                if !emailValidationMessage.isEmpty {
                                    HStack {
                                        Image(systemName: isValidEmail ? "checkmark.circle" : "xmark.circle")
                                            .foregroundColor(isValidEmail ? .green : .red)
                                        Text(emailValidationMessage)
                                            .foregroundColor(isValidEmail ? .green : .red)
                                            .font(.caption)
                                    }
                                }
                            }
                            
                            // Contraseña
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Contraseña *")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primaryText)
                                
                                HStack {
                                    if showPassword {
                                        TextField("Mínimo 6 caracteres", text: $password)
                                    } else {
                                        SecureField("Mínimo 6 caracteres", text: $password)
                                    }
                                    
                                    Button(action: {
                                        showPassword.toggle()
                                    }) {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(password.count >= 6 || password.isEmpty ? Color.borderColor : Color.red, lineWidth: 1)
                                )
                            }
                            
                            // Confirmar contraseña
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirmar contraseña *")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primaryText)
                                
                                HStack {
                                    if showConfirmPassword {
                                        TextField("Confirma tu contraseña", text: $confirmPassword)
                                    } else {
                                        SecureField("Confirma tu contraseña", text: $confirmPassword)
                                    }
                                    
                                    Button(action: {
                                        showConfirmPassword.toggle()
                                    }) {
                                        Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(passwordsMatch || confirmPassword.isEmpty ? Color.borderColor : Color.red, lineWidth: 1)
                                )
                                
                                if !confirmPassword.isEmpty && !passwordsMatch {
                                    HStack {
                                        Image(systemName: "xmark.circle")
                                            .foregroundColor(.red)
                                        Text("Las contraseñas no coinciden")
                                            .foregroundColor(.red)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        
                        // Información de la empresa
                        VStack(spacing: 20) {
                            
                            // Nombre comercial de la empresa
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Nombre comercial de la empresa *")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primaryText)
                                
                                TextField("Ej: TechCorp SV", text: $nombreComercial)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                            }
                            
                            // Año de fundación
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Año de fundación *")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primaryText)
                                
                                TextField("Ej: 2020", text: $anioFundacion)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                            }
                            
                            // Total de empleados
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Total de empleados *")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primaryText)
                                
                                TextField("Ej: 50", text: $totalEmpleados)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                            }
                            
                            // Teléfono
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Teléfono *")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primaryText)
                                
                                TextField("Ej: +503 7123-4567", text: $telefono)
                                    .keyboardType(.phonePad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                            }
                            
                            // Sitio web (opcional)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Sitio web")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primaryText)
                                
                                TextField("Ej: https://miempresa.com", text: $sitioWeb)
                                    .keyboardType(.URL)
                                    .autocapitalization(.none)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                            }
                        }
                        
                        // País
                        VStack(alignment: .leading, spacing: 8) {
                            Text("País *")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primaryText)
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showPaisesDropdown.toggle()
                                    if showPaisesDropdown {
                                        showUbicacionesDropdown = false
                                    }
                                }
                            }) {
                                HStack {
                                    Text(paisSeleccionado.isEmpty ? "Selecciona tu país" : paisSeleccionado)
                                        .foregroundColor(paisSeleccionado.isEmpty ? .gray : .primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                        .rotationEffect(.degrees(showPaisesDropdown ? 180 : 0))
                                }
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.borderColor, lineWidth: 1)
                                )
                            }
                            
                            if showPaisesDropdown {
                                VStack(spacing: 0) {
                                    ForEach(Paises, id: \.self) { pais in
                                        Button(action: {
                                            paisSeleccionado = pais
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                showPaisesDropdown = false
                                            }
                                        }) {
                                            HStack {
                                                Text(pais)
                                                    .foregroundColor(.primaryText)
                                                Spacer()
                                            }
                                            .padding()
                                        }
                                        
                                        if pais != Paises.last {
                                            Divider()
                                        }
                                    }
                                }
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.borderColor, lineWidth: 1)
                                )
                                .transition(.opacity.combined(with: .scale))
                            }
                        }
                        
                        // Ubicación
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ubicación *")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primaryText)
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showUbicacionesDropdown.toggle()
                                    if showUbicacionesDropdown {
                                        showPaisesDropdown = false
                                    }
                                }
                            }) {
                                HStack {
                                    Text(ubicacionSeleccionada.isEmpty ? "Selecciona tu ubicación" : ubicacionSeleccionada)
                                        .foregroundColor(ubicacionSeleccionada.isEmpty ? .gray : .primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                        .rotationEffect(.degrees(showUbicacionesDropdown ? 180 : 0))
                                }
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.borderColor, lineWidth: 1)
                                )
                            }
                            
                            if showUbicacionesDropdown {
                                VStack(spacing: 0) {
                                    ForEach(Ubicaciones, id: \.self) { ubicacion in
                                        Button(action: {
                                            ubicacionSeleccionada = ubicacion
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                showUbicacionesDropdown = false
                                            }
                                        }) {
                                            HStack {
                                                Text(ubicacion)
                                                    .foregroundColor(.primaryText)
                                                Spacer()
                                            }
                                            .padding()
                                        }
                                        
                                        if ubicacion != Ubicaciones.last {
                                            Divider()
                                        }
                                    }
                                }
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.borderColor, lineWidth: 1)
                                )
                                .transition(.opacity.combined(with: .scale))
                            }
                        }
                        
                        // Biografía/Descripción de la empresa
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Descripción de la empresa *")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primaryText)
                            
                            TextEditor(text: $biografia)
                                .frame(minHeight: 100)
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.borderColor, lineWidth: 1)
                                )
                                .overlay(
                                    // Placeholder
                                    VStack {
                                        if biografia.isEmpty {
                                            HStack {
                                                Text("Describe tu empresa, servicios, cultura organizacional...")
                                                    .foregroundColor(.gray)
                                                    .padding(.top, 8)
                                                    .padding(.leading, 12)
                                                Spacer()
                                            }
                                            Spacer()
                                        }
                                    }
                                )
                        }
                        
                        // Documento de verificación
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Documento de verificación")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primaryText)
                            
                            Text("Sube un documento que verifique la existencia legal de tu empresa (registro mercantil, escritura de constitución, etc.)")
                                .font(.caption)
                                .foregroundColor(.secondaryText)
                            
                            DocumentPickerButtonEmpresa(selectedDocument: $selectedDocument)
                        }
                        
                        // Términos y condiciones
                        HStack(spacing: 12) {
                            Button(action: {
                                acceptTerms.toggle()
                            }) {
                                Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(acceptTerms ? .primaryPurple : .gray)
                                    .font(.title2)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Acepto los términos y condiciones")
                                    .font(.body)
                                    .foregroundColor(.primaryText)
                                
                                Text("Al registrarte aceptas nuestros términos de uso y política de privacidad")
                                    .font(.caption)
                                    .foregroundColor(.secondaryText)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        
                        // Botón de registro
                        Button(action: {
                            handleRegister()
                        }) {
                            HStack {
                                if isUploadingFiles || authVM.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.white)
                                }
                                
                                Text(getButtonText())
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid && !authVM.isLoading && !isUploadingFiles ? Color.primaryPurple : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(!isFormValid || authVM.isLoading || isUploadingFiles)
                        
                        // Link a login
                        HStack {
                            Text("¿Ya tienes una cuenta?")
                                .foregroundColor(.secondaryText)
                            
                            Button("Inicia sesión") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .foregroundColor(.primaryPurple)
                            .fontWeight(.medium)
                        }
                        .padding(.bottom, 20)
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            // Cerrar dropdowns si se toca fuera
            withAnimation(.easeInOut(duration: 0.2)) {
                if showPaisesDropdown {
                    showPaisesDropdown = false
                }
                if showUbicacionesDropdown {
                    showUbicacionesDropdown = false
                }
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Email Validation
    private var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email) && !email.isEmpty
    }
    
    private var emailBorderColor: Color {
        if email.isEmpty {
            return Color.borderColor
        }
        return isValidEmail ? Color.green : Color.red
    }
    
    private func validateEmail() {
        if email.isEmpty {
            emailValidationMessage = ""
            return
        }
        
        if isValidEmail {
            emailValidationMessage = "Email válido"
        } else {
            emailValidationMessage = "Formato de email inválido"
        }
    }
    
    private var passwordsMatch: Bool {
        return password == confirmPassword && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    private func getButtonText() -> String {
        if isUploadingFiles {
            return "Subiendo archivos..."
        } else if authVM.isLoading {
            return "Registrando..."
        } else {
            return "Crear cuenta"
        }
    }
    
    private var isFormValid: Bool {
        !email.isEmpty &&
        isValidEmail &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        !nombreCompleto.isEmpty &&
        !nombreComercial.isEmpty &&
        !anioFundacion.isEmpty &&
        !totalEmpleados.isEmpty &&
        !telefono.isEmpty &&
        !paisSeleccionado.isEmpty &&
        !ubicacionSeleccionada.isEmpty &&
        !biografia.isEmpty &&
        acceptTerms &&
        password.count >= 6 &&
        passwordsMatch &&
        Int(anioFundacion) != nil &&
        Int(totalEmpleados) != nil
    }
    
    private func handleRegister() {
        // Validar email primero
        guard isValidEmail else {
            alertMessage = "Por favor ingresa un correo electrónico válido"
            showingAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Las contraseñas no coinciden"
            showingAlert = true
            return
        }
        
        guard password.count >= 6 else {
            alertMessage = "La contraseña debe tener al menos 6 caracteres"
            showingAlert = true
            return
        }
        
        guard let anioInt = Int(anioFundacion), anioInt > 1800 && anioInt <= Calendar.current.component(.year, from: Date()) else {
            alertMessage = "Por favor ingresa un año de fundación válido"
            showingAlert = true
            return
        }
        
        guard let empleadosInt = Int(totalEmpleados), empleadosInt > 0 else {
            alertMessage = "Por favor ingresa un número válido de empleados"
            showingAlert = true
            return
        }
        
        guard acceptTerms else {
            alertMessage = "Debes aceptar los términos y condiciones"
            showingAlert = true
            return
        }
        
        Task {
            isUploadingFiles = true
            
            do {
                // Crear usuario primero
                let authResponse = try await SupabaseManager.shared.client.auth.signUp(
                    email: email,
                    password: password
                )
                
                let userId = authResponse.user.id.uuidString
                var fotoPerfilURL: String? = nil
                var docVerificacionURL: String? = nil
                
                // Subir foto de perfil si existe
                if let profileImage = selectedProfileImage {
                    print("[DEBUG] Subiendo foto de perfil...")
                    fotoPerfilURL = try await uploadAvatar(profileImage, userId: userId)
                }
                
                // Subir documento de verificación si existe
                if let document = selectedDocument {
                    print("[DEBUG] Subiendo documento de verificación...")
                    docVerificacionURL = try await uploadPDFEmpresa(document.data, fileName: document.name, userId: userId)
                }
                
                // Registrar empresa con los URLs de archivos
                try await authVM.registrarEmpresaConArchivos(
                    userId: userId,
                    email: email,
                    password: password,
                    nombreCompleto: nombreCompleto,
                    nombreComercial: nombreComercial,
                    anioFundacion: anioInt,
                    totalEmpleados: empleadosInt,
                    telefono: telefono,
                    biografia: biografia,
                    ubicacion: ubicacionSeleccionada,
                    pais: paisSeleccionado,
                    sitioWeb: sitioWeb.isEmpty ? nil : sitioWeb,
                    fotoPerfilURL: fotoPerfilURL,
                    docVerificacionURL: docVerificacionURL
                )
                
                isUploadingFiles = false
                
                // Registro exitoso -> volver al login
                presentationMode.wrappedValue.dismiss()
                
            } catch {
                isUploadingFiles = false
                print("[ERROR] Error en registro: \(error)")
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
}

// MARK: - Componentes temporales para evitar errores de compilación

// Image Picker Options para Empresa
struct ImagePickerOptionsEmpresa: View {
    @Binding var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    
    var body: some View {
        Button(action: {
            showingActionSheet = true
        }) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.borderColor, lineWidth: 2))
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        VStack(spacing: 4) {
                            Image(systemName: "camera")
                                .font(.title2)
                                .foregroundColor(.gray)
                            Text("Foto")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
                    .overlay(Circle().stroke(Color.borderColor, lineWidth: 2))
            }
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Seleccionar foto de perfil"),
                buttons: [
                    .default(Text("Galería")) { showingImagePicker = true },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            PhotoPickerEmpresa(selectedImage: $selectedImage)
        }
    }
}

// Photo Picker para Empresa
struct PhotoPickerEmpresa: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPickerEmpresa
        
        init(_ parent: PhotoPickerEmpresa) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

// Document Picker Button para Empresa
struct DocumentPickerButtonEmpresa: View {
    @Binding var selectedDocument: DocumentInfoEmpresa?
    @State private var showingDocumentPicker = false
    
    var body: some View {
        Button(action: {
            showingDocumentPicker = true
        }) {
            VStack(spacing: 16) {
                if let document = selectedDocument {
                    HStack(spacing: 12) {
                        Image(systemName: "doc.fill")
                            .foregroundColor(.primaryPurple)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(document.name)
                                .font(.headline)
                                .foregroundColor(.primaryText)
                                .lineLimit(1)
                            
                            Text(document.formattedSize)
                                .font(.caption)
                                .foregroundColor(.secondaryText)
                        }
                        
                        Spacer()
                        
                        if document.isValidPDF {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "doc.badge.plus")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        
                        Text("Seleccionar documento")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("PDF (máx. 10MB)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .sheet(isPresented: $showingDocumentPicker) {
            SimpleDocumentPickerEmpresa(selectedDocument: $selectedDocument)
        }
    }
}

// Simple Document Picker para Empresa
struct SimpleDocumentPickerEmpresa: UIViewControllerRepresentable {
    @Binding var selectedDocument: DocumentInfoEmpresa?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: SimpleDocumentPickerEmpresa
        
        init(_ parent: SimpleDocumentPickerEmpresa) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            do {
                let data = try Data(contentsOf: url)
                let documentInfo = DocumentInfoEmpresa(
                    name: url.lastPathComponent,
                    data: data,
                    size: data.count,
                    url: url
                )
                
                DispatchQueue.main.async {
                    self.parent.selectedDocument = documentInfo
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            } catch {
                print("Error al leer archivo: \(error)")
            }
        }
    }
}

// MARK: - Storage Functions
extension RegistroEmpresaView {
    
    /// Sube una imagen de avatar y retorna la URL pública
    private func uploadAvatar(_ image: UIImage, userId: String) async throws -> String {
        print("[Storage] Subiendo avatar para empresa: \(userId)")
        
        // Comprimir y convertir imagen a Data
        guard let imageData = compressImage(image) else {
            throw StorageUploadErrorEmpresa.imageCompressionFailed
        }
        
        // Generar nombre único del archivo
        let fileName = "avatar_empresa_\(userId)_\(UUID().uuidString).jpg"
        
        do {
            // Subir archivo al bucket 'avatars'
            try await SupabaseManager.shared.client
                .storage
                .from("avatars")
                .upload(path: fileName, file: imageData)
            
            // Obtener URL pública
            let publicURL = try SupabaseManager.shared.client
                .storage
                .from("avatars")
                .getPublicURL(path: fileName)
            
            print("[Storage] Avatar de empresa subido exitosamente: \(publicURL)")
            return publicURL.absoluteString
            
        } catch {
            print("[Storage] Error subiendo avatar de empresa: \(error)")
            throw StorageUploadErrorEmpresa.uploadFailed(error.localizedDescription)
        }
    }
    
    /// Sube un PDF de verificación y retorna la URL pública
    private func uploadPDFEmpresa(_ data: Data, fileName: String, userId: String) async throws -> String {
        print("[Storage] Subiendo PDF de verificación para empresa: \(userId)")
        
        // Validar que es un PDF
        guard isPDF(data) else {
            throw StorageUploadErrorEmpresa.invalidPDFFormat
        }
        
        // Generar nombre único del archivo
        let cleanFileName = fileName.replacingOccurrences(of: " ", with: "_")
        let uniqueFileName = "verificacion_\(userId)_\(UUID().uuidString)_\(cleanFileName)"
        
        do {
            // Subir archivo al bucket 'docs_empresa'
            try await SupabaseManager.shared.client
                .storage
                .from("docs_empresa")
                .upload(path: uniqueFileName, file: data)
            
            // Obtener URL pública
            let publicURL = try SupabaseManager.shared.client
                .storage
                .from("docs_empresa")
                .getPublicURL(path: uniqueFileName)
            
            print("[Storage] PDF de verificación subido exitosamente: \(publicURL)")
            return publicURL.absoluteString
            
        } catch {
            print("[Storage] Error subiendo PDF de verificación: \(error)")
            throw StorageUploadErrorEmpresa.uploadFailed(error.localizedDescription)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Comprime una imagen para optimizar el tamaño
    private func compressImage(_ image: UIImage) -> Data? {
        // Redimensionar si es muy grande
        let maxDimension: CGFloat = 1024
        var resizedImage = image
        
        if max(image.size.width, image.size.height) > maxDimension {
            let aspectRatio = image.size.width / image.size.height
            let newSize: CGSize
            
            if image.size.width > image.size.height {
                newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
            } else {
                newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
            }
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
        }
        
        // Comprimir JPEG con calidad 0.8
        return resizedImage.jpegData(compressionQuality: 0.8)
    }
    
    /// Valida si los datos corresponden a un PDF
    private func isPDF(_ data: Data) -> Bool {
        guard data.count >= 4 else { return false }
        
        // Los PDFs comienzan con %PDF
        let pdfHeader = Data([0x25, 0x50, 0x44, 0x46]) // %PDF
        let fileHeader = data.prefix(4)
        
        return fileHeader == pdfHeader
    }
}

// MARK: - Storage Errors para Empresa
enum StorageUploadErrorEmpresa: Error, LocalizedError {
    case imageCompressionFailed
    case invalidPDFFormat
    case uploadFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .imageCompressionFailed:
            return "No se pudo comprimir la imagen"
        case .invalidPDFFormat:
            return "El archivo no es un PDF válido"
        case .uploadFailed(let message):
            return "Error al subir archivo: \(message)"
        }
    }
}

#Preview {
    NavigationView {
        RegistroEmpresaView()
            .environmentObject(AuthViewModel())
    }
}
