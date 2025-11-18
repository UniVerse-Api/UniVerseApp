// Views/RegistroEstudianteView.swift
import SwiftUI
import UIKit
import PhotosUI
import UniformTypeIdentifiers
import Supabase

// Tipos temporales hasta que se resuelva el problema de importación
struct DocumentInfo: Identifiable {
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

struct RegistroEstudianteView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var nombreCompleto = ""
    @State private var carrera = ""
    @State private var telefono = ""
    @State private var biografia = ""
    @State private var ubicacion = ""
    @State private var universidad = ""
    @State private var paisSeleccionado = ""
    @State private var showPaisesDropdown = false
    @State private var ubicacionSeleccionada = ""
    @State private var showUbicacionesDropdown = false
    @State private var carreraSeleccionada = ""
    @State private var showCarrerasDropdown = false
    @State private var acceptTerms = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var emailValidationMessage = ""
    
    // Estados para archivos
    @State private var selectedProfileImage: UIImage?
    @State private var selectedDocument: DocumentInfo?
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
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Volver")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.primaryOrange)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Card principal
                    VStack(spacing: 24) {
                        // Título
                        VStack(spacing: 8) {
                            Text("Registro")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Text("Estudiante")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primaryOrange)
                            
                            Text("Crea tu cuenta como estudiante y encuentra oportunidades laborales")
                                .font(.system(size: 14))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 10)
                        }
                        .padding(.top, 20)
                        
                        // Formulario
                        VStack(spacing: 20) {
                            // Datos de cuenta
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Datos de cuenta")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                // Email
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Correo electrónico")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(isValidEmail ? .green : .textSecondary)
                                            .font(.system(size: 16))
                                            .frame(width: 20)
                                        
                                        TextField("tu@correo.com", text: $email)
                                            .foregroundColor(.textPrimary)
                                            .textInputAutocapitalization(.never)
                                            .keyboardType(.emailAddress)
                                            .tint(.primaryOrange)
                                            .onChange(of: email) { _ in
                                                validateEmail()
                                            }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.inputBackground)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(emailBorderColor, lineWidth: 1)
                                    )
                                    
                                    // Mensaje de validación de email
                                    if !emailValidationMessage.isEmpty {
                                        HStack(spacing: 6) {
                                            Image(systemName: isValidEmail ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                                                .foregroundColor(isValidEmail ? .green : .red)
                                                .font(.system(size: 12))
                                            
                                            Text(emailValidationMessage)
                                                .font(.system(size: 12))
                                                .foregroundColor(isValidEmail ? .green : .red)
                                        }
                                        .padding(.top, 4)
                                    }
                                }
                                
                                // Contraseña
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Contraseña")
                                            .font(.system(size: 14))
                                            .foregroundColor(.textSecondary)
                                        
                                        Spacer()
                                        
                                        // Indicador de fortaleza de contraseña
                                        if !password.isEmpty {
                                            HStack(spacing: 4) {
                                                Image(systemName: password.count >= 6 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(password.count >= 6 ? .green : .red)
                                                
                                                Text(password.count >= 6 ? "Válida" : "Muy corta")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(password.count >= 6 ? .green : .red)
                                            }
                                        }
                                        
                                        Button(action: {
                                            showPassword.toggle()
                                        }) {
                                            Text(showPassword ? "Ocultar" : "Mostrar")
                                                .font(.system(size: 12))
                                                .foregroundColor(.primaryOrange)
                                        }
                                    }
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(.textSecondary)
                                            .font(.system(size: 16))
                                            .frame(width: 20)
                                        
                                        if showPassword {
                                            TextField("Mínimo 6 caracteres", text: $password)
                                                .foregroundColor(.textPrimary)
                                                .tint(.primaryOrange)
                                        } else {
                                            SecureField("Mínimo 6 caracteres", text: $password)
                                                .foregroundColor(.textPrimary)
                                                .tint(.primaryOrange)
                                        }
                                        
                                        // Icono de validación en el campo
                                        if !password.isEmpty {
                                            Image(systemName: password.count >= 6 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(password.count >= 6 ? .green : .red)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.inputBackground)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                !password.isEmpty ?
                                                (password.count >= 6 ? Color.green.opacity(0.5) : Color.red.opacity(0.5)) :
                                                Color.borderColor,
                                                lineWidth: 1
                                            )
                                    )
                                    
                                    // Mensaje de ayuda
                                    if !password.isEmpty && password.count < 6 {
                                        HStack(spacing: 6) {
                                            Image(systemName: "info.circle.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.yellow)
                                            
                                            Text("La contraseña debe tener al menos 6 caracteres")
                                                .font(.system(size: 12))
                                                .foregroundColor(.yellow)
                                        }
                                        .padding(.top, 4)
                                    }
                                }
                                
                                // Confirmar contraseña
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Confirmar contraseña")
                                            .font(.system(size: 14))
                                            .foregroundColor(.textSecondary)
                                        
                                        Spacer()
                                        
                                        // Indicador de validación
                                        if !confirmPassword.isEmpty {
                                            HStack(spacing: 4) {
                                                Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(passwordsMatch ? .green : .red)
                                                
                                                Text(passwordsMatch ? "Coinciden" : "No coinciden")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(passwordsMatch ? .green : .red)
                                            }
                                        }
                                        
                                        Button(action: {
                                            showConfirmPassword.toggle()
                                        }) {
                                            Text(showConfirmPassword ? "Ocultar" : "Mostrar")
                                                .font(.system(size: 12))
                                                .foregroundColor(.primaryOrange)
                                        }
                                    }
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(.textSecondary)
                                            .font(.system(size: 16))
                                            .frame(width: 20)
                                        
                                        if showConfirmPassword {
                                            TextField("Repite tu contraseña", text: $confirmPassword)
                                                .foregroundColor(.textPrimary)
                                                .tint(.primaryOrange)
                                        } else {
                                            SecureField("Repite tu contraseña", text: $confirmPassword)
                                                .foregroundColor(.textPrimary)
                                                .tint(.primaryOrange)
                                        }
                                        
                                        // Icono de validación en el campo
                                        if !confirmPassword.isEmpty {
                                            Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(passwordsMatch ? .green : .red)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.inputBackground)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                !confirmPassword.isEmpty ?
                                                (passwordsMatch ? Color.green.opacity(0.5) : Color.red.opacity(0.5)) :
                                                Color.borderColor,
                                                lineWidth: 1
                                            )
                                    )
                                    
                                    // Mensaje de ayuda
                                    if !confirmPassword.isEmpty && !passwordsMatch {
                                        HStack(spacing: 6) {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.red)
                                            
                                            Text("Las contraseñas no coinciden")
                                                .font(.system(size: 12))
                                                .foregroundColor(.red)
                                        }
                                        .padding(.top, 4)
                                    }
                                }
                            }
                            
                            // Información personal
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Información personal")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                // Nombre completo
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Nombre completo")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.textSecondary)
                                            .font(.system(size: 16))
                                            .frame(width: 20)
                                        
                                        TextField("Tu nombre completo", text: $nombreCompleto)
                                            .foregroundColor(.textPrimary)
                                            .tint(.primaryOrange)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.inputBackground)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                                }
                                
                                // Teléfono
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Teléfono")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "phone.fill")
                                            .foregroundColor(.textSecondary)
                                            .font(.system(size: 16))
                                            .frame(width: 20)
                                        
                                        TextField("+1 234 567 8900", text: $telefono)
                                            .foregroundColor(.textPrimary)
                                            .keyboardType(.phonePad)
                                            .tint(.primaryOrange)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.inputBackground)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                                }
                                
                                // País - Combobox
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("País")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                    
                                    VStack(spacing: 0) {
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                showPaisesDropdown.toggle()
                                            }
                                        }) {
                                            HStack(spacing: 12) {
                                                Image(systemName: "globe")
                                                    .foregroundColor(.textSecondary)
                                                    .font(.system(size: 16))
                                                    .frame(width: 20)
                                                
                                                Text(paisSeleccionado.isEmpty ? "Selecciona tu país" : paisSeleccionado)
                                                    .foregroundColor(paisSeleccionado.isEmpty ? .textSecondary : .textPrimary)
                                                    .font(.system(size: 16))
                                                
                                                Spacer()
                                                
                                                Image(systemName: showPaisesDropdown ? "chevron.up" : "chevron.down")
                                                    .foregroundColor(.textSecondary)
                                                    .font(.system(size: 12))
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 14)
                                        }
                                        .background(Color.inputBackground)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    showPaisesDropdown ? Color.primaryOrange : Color.borderColor,
                                                    lineWidth: 1
                                                )
                                        )
                                        
                                        // Dropdown lista
                                        if showPaisesDropdown {
                                            VStack(spacing: 0) {
                                                ScrollView {
                                                    LazyVStack(spacing: 0) {
                                                        ForEach(Paises, id: \.self) { pais in
                                                            Button(action: {
                                                                paisSeleccionado = pais
                                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                                    showPaisesDropdown = false
                                                                }
                                                            }) {
                                                                HStack {
                                                                    Text(pais)
                                                                        .font(.system(size: 16))
                                                                        .foregroundColor(.textPrimary)
                                                                    
                                                                    Spacer()
                                                                    
                                                                    if paisSeleccionado == pais {
                                                                        Image(systemName: "checkmark")
                                                                            .foregroundColor(.primaryOrange)
                                                                            .font(.system(size: 14))
                                                                    }
                                                                }
                                                                .padding(.horizontal, 16)
                                                                .padding(.vertical, 12)
                                                            }
                                                            .background(
                                                                paisSeleccionado == pais ? 
                                                                Color.primaryOrange.opacity(0.1) : 
                                                                Color.clear
                                                            )
                                                            
                                                            if pais != Paises.last {
                                                                Divider()
                                                                    .background(Color.borderColor)
                                                            }
                                                        }
                                                    }
                                                }
                                                .frame(maxHeight: 200)
                                            }
                                            .background(Color.inputBackground)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.primaryOrange, lineWidth: 1)
                                            )
                                            .padding(.top, 4)
                                        }
                                    }
                                }
                                
                                // Ubicación
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Ubicación")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                    
                                    VStack(spacing: 0) {
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                showUbicacionesDropdown.toggle()
                                            }
                                        }) {
                                            HStack(spacing: 12) {
                                                Image(systemName: "location.fill")
                                                    .foregroundColor(.textSecondary)
                                                    .font(.system(size: 16))
                                                    .frame(width: 20)
                                                
                                                Text(ubicacionSeleccionada.isEmpty ? "Selecciona tu ubicación" : ubicacionSeleccionada)
                                                    .foregroundColor(ubicacionSeleccionada.isEmpty ? .textSecondary : .textPrimary)
                                                    .font(.system(size: 16))
                                                
                                                Spacer()
                                                
                                                Image(systemName: showUbicacionesDropdown ? "chevron.up" : "chevron.down")
                                                    .foregroundColor(.textSecondary)
                                                    .font(.system(size: 12))
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 14)
                                        }
                                        .background(Color.inputBackground)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    showUbicacionesDropdown ? Color.primaryOrange : Color.borderColor,
                                                    lineWidth: 1
                                                )
                                        )
                                        
                                        // Dropdown lista
                                        if showUbicacionesDropdown {
                                            VStack(spacing: 0) {
                                                ScrollView {
                                                    LazyVStack(spacing: 0) {
                                                        ForEach(Ubicaciones, id: \.self) { ubicacion in
                                                            Button(action: {
                                                                ubicacionSeleccionada = ubicacion
                                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                                    showUbicacionesDropdown = false
                                                                }
                                                            }) {
                                                                HStack {
                                                                    Text(ubicacion)
                                                                        .font(.system(size: 16))
                                                                        .foregroundColor(.textPrimary)
                                                                    
                                                                    Spacer()
                                                                    
                                                                    if ubicacionSeleccionada == ubicacion {
                                                                        Image(systemName: "checkmark")
                                                                            .foregroundColor(.primaryOrange)
                                                                            .font(.system(size: 14))
                                                                    }
                                                                }
                                                                .padding(.horizontal, 16)
                                                                .padding(.vertical, 12)
                                                            }
                                                            .background(
                                                                ubicacionSeleccionada == ubicacion ? 
                                                                Color.primaryOrange.opacity(0.1) : 
                                                                Color.clear
                                                            )
                                                            
                                                            if ubicacion != Ubicaciones.last {
                                                                Divider()
                                                                    .background(Color.borderColor)
                                                            }
                                                        }
                                                    }
                                                }
                                                .frame(maxHeight: 200)
                                            }
                                            .background(Color.inputBackground)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.primaryOrange, lineWidth: 1)
                                            )
                                            .padding(.top, 4)
                                        }
                                    }
                                }
                                
                                // Biografía
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Biografía")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(alignment: .top, spacing: 12) {
                                            Image(systemName: "text.alignleft")
                                                .foregroundColor(.textSecondary)
                                                .font(.system(size: 16))
                                                .frame(width: 20)
                                                .padding(.top, 2)
                                            
                                            TextField("Cuéntanos sobre ti, tus intereses y objetivos profesionales...", text: $biografia, axis: .vertical)
                                                .foregroundColor(.textPrimary)
                                                .tint(.primaryOrange)
                                                .lineLimit(4...8)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 14)
                                    }
                                    .background(Color.inputBackground)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                                }
                            }
                            
                            // Foto de perfil
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Foto de perfil")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                VStack(spacing: 12) {
                                    // Usar el nuevo componente ImagePickerOptions
                                    ImagePickerOptions(selectedImage: $selectedProfileImage)
                                    
                                    Text("Toca para seleccionar una foto de perfil")
                                        .font(.system(size: 12))
                                        .foregroundColor(.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            
                            // CV/Currículum
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Currículum (opcional)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                // Usar el nuevo componente DocumentPickerButton
                                DocumentPickerButton(selectedDocument: $selectedDocument)
                            }
                            
                            // Información académica
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Información académica")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                // Carrera
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Carrera")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                    
                                    VStack(spacing: 0) {
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                showCarrerasDropdown.toggle()
                                            }
                                        }) {
                                            HStack(spacing: 12) {
                                                Image(systemName: "graduationcap.fill")
                                                    .foregroundColor(.textSecondary)
                                                    .font(.system(size: 16))
                                                    .frame(width: 20)
                                                
                                                Text(carreraSeleccionada.isEmpty ? "Selecciona tu carrera" : carreraSeleccionada)
                                                    .foregroundColor(carreraSeleccionada.isEmpty ? .textSecondary : .textPrimary)
                                                    .font(.system(size: 16))
                                                
                                                Spacer()
                                                
                                                Image(systemName: showCarrerasDropdown ? "chevron.up" : "chevron.down")
                                                    .foregroundColor(.textSecondary)
                                                    .font(.system(size: 12))
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 14)
                                        }
                                        .background(Color.inputBackground)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    showCarrerasDropdown ? Color.primaryOrange : Color.borderColor,
                                                    lineWidth: 1
                                                )
                                        )
                                        
                                        // Dropdown lista
                                        if showCarrerasDropdown {
                                            VStack(spacing: 0) {
                                                ScrollView {
                                                    LazyVStack(spacing: 0) {
                                                        ForEach(Carreras, id: \.self) { carrera in
                                                            Button(action: {
                                                                carreraSeleccionada = carrera
                                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                                    showCarrerasDropdown = false
                                                                }
                                                            }) {
                                                                HStack {
                                                                    Text(carrera)
                                                                        .font(.system(size: 16))
                                                                        .foregroundColor(.textPrimary)
                                                                    
                                                                    Spacer()
                                                                    
                                                                    if carreraSeleccionada == carrera {
                                                                        Image(systemName: "checkmark")
                                                                            .foregroundColor(.primaryOrange)
                                                                            .font(.system(size: 14))
                                                                    }
                                                                }
                                                                .padding(.horizontal, 16)
                                                                .padding(.vertical, 12)
                                                            }
                                                            .background(
                                                                carreraSeleccionada == carrera ? 
                                                                Color.primaryOrange.opacity(0.1) : 
                                                                Color.clear
                                                            )
                                                            
                                                            if carrera != Carreras.last {
                                                                Divider()
                                                                    .background(Color.borderColor)
                                                            }
                                                        }
                                                    }
                                                }
                                                .frame(maxHeight: 200)
                                            }
                                            .background(Color.inputBackground)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.primaryOrange, lineWidth: 1)
                                            )
                                            .padding(.top, 4)
                                        }
                                    }
                                }
                                
                                // Universidad
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Universidad (opcional)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "building.columns.fill")
                                            .foregroundColor(.textSecondary)
                                            .font(.system(size: 16))
                                            .frame(width: 20)
                                        
                                        TextField("Nombre de tu universidad", text: $universidad)
                                            .foregroundColor(.textPrimary)
                                            .tint(.primaryOrange)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.inputBackground)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                                }
                            }
                            
                            // Términos y condiciones
                            HStack(alignment: .top, spacing: 12) {
                                Button(action: {
                                    acceptTerms.toggle()
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(acceptTerms ? Color.primaryOrange : Color.borderColor, lineWidth: 2)
                                            .frame(width: 20, height: 20)
                                        
                                        if acceptTerms {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.primaryOrange)
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Acepto los")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                    + Text(" términos y condiciones")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primaryOrange)
                                    + Text(" y la")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                    + Text(" política de privacidad")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primaryOrange)
                                }
                                
                                Spacer()
                            }
                            .padding(.top, 8)
                            
                            // Mostrar error si existe
                            if let error = authVM.errorMessage {
                                HStack(spacing: 8) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 14))
                                    
                                    Text(error)
                                        .font(.system(size: 13))
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            // Botón de registro
                            Button(action: handleRegister) {
                                HStack(spacing: 8) {
                                    if authVM.isLoading || isUploadingFiles {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "person.badge.plus")
                                            .font(.system(size: 16))
                                    }
                                    
                                    Text(getButtonText())
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    isFormValid ? Color.primaryOrange : Color.gray.opacity(0.5)
                                )
                                .cornerRadius(8)
                            }
                            .disabled(!isFormValid || authVM.isLoading || isUploadingFiles)
                            .padding(.top, 8)
                            
                            // Link a login
                            HStack(spacing: 6) {
                                Text("¿Ya tienes cuenta?")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                                
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Inicia sesión")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primaryOrange)
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 20)
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
                if showCarrerasDropdown {
                    showCarrerasDropdown = false
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
        !telefono.isEmpty &&
        !paisSeleccionado.isEmpty &&
        !ubicacionSeleccionada.isEmpty &&
        !biografia.isEmpty &&
        !carreraSeleccionada.isEmpty &&
        acceptTerms &&
        password.count >= 6 &&
        passwordsMatch
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
                var cvInfo: (url: String, name: String)? = nil
                
                // Subir foto de perfil si existe
                if let profileImage = selectedProfileImage {
                    print("[DEBUG] Subiendo foto de perfil...")
                    fotoPerfilURL = try await uploadAvatar(profileImage, userId: userId)
                    print("[DEBUG] Foto subida: \(fotoPerfilURL ?? "nil")")
                }
                
                // Subir CV si existe
                if let document = selectedDocument {
                    print("[DEBUG] Subiendo CV...")
                    cvInfo = try await uploadPDF(document.data, fileName: document.name, userId: userId)
                    print("[DEBUG] CV subido: \(cvInfo?.url ?? "nil")")
                }
                
                // Registrar estudiante con los URLs de archivos
                try await authVM.registrarEstudianteConArchivos(
                    userId: userId, // Pasar el userId directamente
                    email: email,
                    password: password,
                    nombreCompleto: nombreCompleto,
                    carrera: carreraSeleccionada,
                    telefono: telefono,
                    biografia: biografia,
                    ubicacion: ubicacionSeleccionada,
                    pais: paisSeleccionado,
                    nombreComercial: nil,
                    universidadActual: universidad.isEmpty ? nil : universidad,
                    fotoPerfilURL: fotoPerfilURL,
                    cvURL: cvInfo?.url,
                    cvNombre: cvInfo?.name
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

// Image Picker Options
struct ImagePickerOptions: View {
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
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.primaryOrange, lineWidth: 3)
                    )
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                            
                            Text("Agregar foto")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    )
            }
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Seleccionar foto de perfil"),
                buttons: [
                    .default(Text("Galería")) {
                        showingImagePicker = true
                    },
                    .cancel(Text("Cancelar"))
                ]
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            PhotoPicker(selectedImage: $selectedImage)
        }
    }
}

// Photo Picker
struct PhotoPicker: UIViewControllerRepresentable {
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
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let uiImage = image as? UIImage {
                            self.parent.selectedImage = uiImage
                        }
                    }
                }
            }
        }
    }
}

// Document Picker Button
struct DocumentPickerButton: View {
    @Binding var selectedDocument: DocumentInfo?
    @State private var showingDocumentPicker = false
    
    var body: some View {
        Button(action: {
            showingDocumentPicker = true
        }) {
            VStack(spacing: 16) {
                if let document = selectedDocument {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.primaryOrange)
                        
                        VStack(spacing: 4) {
                            Text(document.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                                .lineLimit(2)
                            
                            Text(document.formattedSize)
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                        }
                        
                        Text("PDF seleccionado")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("Subir CV (PDF)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .sheet(isPresented: $showingDocumentPicker) {
            SimpleDocumentPicker(selectedDocument: $selectedDocument)
        }
    }
}

// Simple Document Picker
struct SimpleDocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedDocument: DocumentInfo?
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
        let parent: SimpleDocumentPicker
        
        init(_ parent: SimpleDocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            do {
                let data = try Data(contentsOf: url)
                let documentInfo = DocumentInfo(
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
extension RegistroEstudianteView {
    
    /// Sube una imagen de avatar y retorna la URL pública
    private func uploadAvatar(_ image: UIImage, userId: String) async throws -> String {
        print("[Storage] Subiendo avatar para usuario: \(userId)")
        
        // Comprimir y convertir imagen a Data
        guard let imageData = compressImage(image) else {
            throw StorageUploadError.imageCompressionFailed
        }
        
        // Generar nombre único del archivo
        let fileName = "avatar_\(userId)_\(UUID().uuidString).jpg"
        
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
            
            print("[Storage] Avatar subido exitosamente: \(publicURL)")
            return publicURL.absoluteString
            
        } catch {
            print("[Storage] Error subiendo avatar: \(error)")
            throw StorageUploadError.uploadFailed(error.localizedDescription)
        }
    }
    
    /// Sube un PDF y retorna la URL pública junto con el nombre del archivo
    private func uploadPDF(_ data: Data, fileName: String, userId: String) async throws -> (url: String, name: String) {
        print("[Storage] Subiendo PDF para usuario: \(userId)")
        
        // Validar que es un PDF
        guard isPDF(data) else {
            throw StorageUploadError.invalidPDFFormat
        }
        
        // Generar nombre único del archivo
        let cleanFileName = fileName.replacingOccurrences(of: " ", with: "_")
        let uniqueFileName = "cv_\(userId)_\(UUID().uuidString)_\(cleanFileName)"
        
        do {
            // Subir archivo al bucket 'docs'
            try await SupabaseManager.shared.client
                .storage
                .from("docs")
                .upload(path: uniqueFileName, file: data)
            
            // Obtener URL pública
            let publicURL = try SupabaseManager.shared.client
                .storage
                .from("docs")
                .getPublicURL(path: uniqueFileName)
            
            print("[Storage] PDF subido exitosamente: \(publicURL)")
            return (url: publicURL.absoluteString, name: fileName)
            
        } catch {
            print("[Storage] Error subiendo PDF: \(error)")
            throw StorageUploadError.uploadFailed(error.localizedDescription)
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

// MARK: - Storage Errors
enum StorageUploadError: Error, LocalizedError {
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
        RegistroEstudianteView()
            .environmentObject(AuthViewModel())
    }
}
