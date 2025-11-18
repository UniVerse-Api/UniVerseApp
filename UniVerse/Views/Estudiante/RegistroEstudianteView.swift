// Views/RegistroEstudianteView.swift
import SwiftUI

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
    @State private var acceptTerms = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var emailValidationMessage = ""
    
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
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "location.fill")
                                            .foregroundColor(.textSecondary)
                                            .font(.system(size: 16))
                                            .frame(width: 20)
                                        
                                        TextField("Ciudad, País", text: $ubicacion)
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
                                    // Avatar placeholder/preview
                                    Button(action: {
                                        // TODO: Implementar selección de foto
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.inputBackground)
                                                .frame(width: 80, height: 80)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.borderColor, lineWidth: 2)
                                                )
                                            
                                            VStack(spacing: 4) {
                                                Image(systemName: "camera.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.textSecondary)
                                                
                                                Text("Foto")
                                                    .font(.system(size: 10))
                                                    .foregroundColor(.textSecondary)
                                            }
                                        }
                                    }
                                    
                                    Text("Toca para seleccionar una foto de perfil")
                                        .font(.system(size: 13))
                                        .foregroundColor(.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            
                            // CV/Currículum
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Currículum (opcional)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                // Drop zone para CV
                                Button(action: {
                                    // TODO: Implementar selección de CV
                                }) {
                                    VStack(spacing: 12) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "doc.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.textSecondary)
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Arrastra tu CV aquí o haz clic para seleccionar")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.textPrimary)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Text("Formatos soportados: PDF, DOC, DOCX")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.textSecondary)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "plus.circle")
                                                .font(.system(size: 20))
                                                .foregroundColor(.primaryOrange)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 20)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, style: StrokeStyle(lineWidth: 2, dash: [5]))
                                            .background(Color.inputBackground.opacity(0.3))
                                    )
                                    .cornerRadius(8)
                                }
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
                                    
                                    HStack(spacing: 12) {
                                        Image(systemName: "graduationcap.fill")
                                            .foregroundColor(.textSecondary)
                                            .font(.system(size: 16))
                                            .frame(width: 20)
                                        
                                        TextField("Ingeniería en Sistemas, Diseño Gráfico, etc.", text: $carrera)
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
                                    if authVM.isLoading {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "person.badge.plus")
                                            .font(.system(size: 16))
                                    }
                                    
                                    Text(authVM.isLoading ? "Registrando..." : "Crear cuenta")
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
                            .disabled(!isFormValid || authVM.isLoading)
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
            // Cerrar dropdown si se toca fuera
            if showPaisesDropdown {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showPaisesDropdown = false
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
    
    private var isFormValid: Bool {
        !email.isEmpty &&
        isValidEmail &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        !nombreCompleto.isEmpty &&
        !telefono.isEmpty &&
        !paisSeleccionado.isEmpty &&
        !ubicacion.isEmpty &&
        !biografia.isEmpty &&
        !carrera.isEmpty &&
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
            do {
                try await authVM.registrarEstudiante(
                    email: email,
                    password: password,
                    nombreCompleto: nombreCompleto,
                    carrera: carrera,
                    telefono: telefono,
                    biografia: biografia,
                    ubicacion: ubicacion,
                    pais: paisSeleccionado,
                    nombreComercial: nil,
                    universidadActual: universidad.isEmpty ? nil : universidad
                )
                
                // Registro exitoso -> volver al login
                // (AuthViewModel publica registrationSuccessMessage que puede ser leída en la pantalla de login)
                presentationMode.wrappedValue.dismiss()
                
            } catch {
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
}

#Preview {
    NavigationView {
        RegistroEstudianteView()
            .environmentObject(AuthViewModel())
    }
}
