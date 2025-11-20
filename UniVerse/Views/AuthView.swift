// Views/AuthView.swift
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            // Fondo claro
            Color.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Card de login
                VStack(spacing: 20) {
                    // Título
                    VStack(spacing: 4) {
                        Text("Accede")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Inicia sesión en tu cuenta")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, 28)
                    
                    // Formulario
                    VStack(spacing: 12) {
                        // Campo de correo/usuario
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Correo o usuario")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                            
                            HStack(spacing: 10) {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.textSecondary)
                                    .font(.system(size: 14))
                                    .frame(width: 20)
                                
                                TextField("", text: $email)
                                    .foregroundColor(.textPrimary)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .tint(.primaryOrange)
                                    .onChange(of: email) { _ in
                                        // Limpiar error cuando el usuario empiece a escribir
                                        if authVM.errorMessage != nil {
                                            authVM.errorMessage = nil
                                        }
                                    }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(Color.inputBackground)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.borderColor, lineWidth: 1)
                            )
                        }
                        
                        // Campo de contraseña
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Contraseña")
                                    .font(.system(size: 13))
                                    .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                Button(action: {
                                    showPassword.toggle()
                                }) {
                                    Text("Mostrar")
                                        .font(.system(size: 12))
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            
                            HStack(spacing: 10) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.textSecondary)
                                    .font(.system(size: 14))
                                    .frame(width: 20)
                                
                                if showPassword {
                                    TextField("", text: $password)
                                        .foregroundColor(.textPrimary)
                                        .tint(.primaryOrange)
                                        .onChange(of: password) { _ in
                                            // Limpiar error cuando el usuario empiece a escribir
                                            if authVM.errorMessage != nil {
                                                authVM.errorMessage = nil
                                            }
                                        }
                                } else {
                                    SecureField("", text: $password)
                                        .foregroundColor(.textPrimary)
                                        .tint(.primaryOrange)
                                        .onChange(of: password) { _ in
                                            // Limpiar error cuando el usuario empiece a escribir
                                            if authVM.errorMessage != nil {
                                                authVM.errorMessage = nil
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(Color.inputBackground)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.borderColor, lineWidth: 1)
                            )
                        }
                        
                        // Recordarme y olvidaste contraseña
                        HStack {
                            Button(action: {
                                rememberMe.toggle()
                            }) {
                                HStack(spacing: 6) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(rememberMe ? Color.primaryOrange : Color.borderColor, lineWidth: 1.5)
                                            .frame(width: 16, height: 16)
                                        
                                        if rememberMe {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.primaryOrange)
                                                .frame(width: 14, height: 14)
                                        }
                                    }
                                    
                                    Text("Recordarme")
                                        .font(.system(size: 13))
                                        .foregroundColor(.textPrimary)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("¿Olvidaste tu contraseña?")
                                    .font(.system(size: 13))
                                    .foregroundColor(.primaryOrange)
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 20)
                    
                    // Mostrar error de autenticación
                    if let error = authVM.errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                            
                            Text(error)
                                .font(.system(size: 13))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    // Botón de entrar
                    Button(action: handleAuth) {
                        HStack {
                            if authVM.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            }
                            Text("Entrar")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.primaryOrange)
                        .cornerRadius(6)
                    }
                    .disabled(authVM.isLoading)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // Registro
                    HStack(spacing: 4) {
                        Text("¿No tienes cuenta?")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                        
                        NavigationLink(destination: SeleccionTipoRegistroView().environmentObject(authVM)) {
                            Text("Registrarse")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.primaryOrange)
                        }
                    }
                    NavigationLink(destination: LoginEmpresaView().environmentObject(authVM)) {
                                            HStack(spacing: 6) {
                                                Image(systemName: "building.2.fill")
                                                    .font(.system(size: 12))
                                                Text("Iniciar sesión como empresa")
                                                    .font(.system(size: 13, weight: .medium))
                                            }
                                            .foregroundColor(.textSecondary)
                                            .padding(.top, 8)
                                        }
                    .padding(.bottom, 28)
                }
                .background(Color.cardBackground)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                // Planes y suscripciones
                Button(action: {}) {
                    Text("Planes y suscripciones")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                        .padding(.top, 28)
                }
                
                Spacer()
            }
        }
    }
    
    private func handleAuth() {
        // Limpiar errores previos
        authVM.errorMessage = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            authVM.errorMessage = "Por favor completa todos los campos"
            return
        }
        
        Task {
            do {
                try await authVM.signIn(email: email, password: password)
                // Si llegamos aquí, el login fue exitoso
            } catch {
                // Mostrar mensaje de error más claro
                let errorMessage = parseAuthError(error)
                authVM.errorMessage = errorMessage
            }
        }
    }
    
    private func parseAuthError(_ error: Error) -> String {
        let errorDescription = error.localizedDescription.lowercased()
        
        if errorDescription.contains("invalid login credentials") ||
           errorDescription.contains("invalid_grant") ||
           errorDescription.contains("email not confirmed") {
            return "Email o contraseña incorrectos. Por favor verifica tus credenciales."
        } else if errorDescription.contains("user not found") ||
                  errorDescription.contains("email_not_found") {
            return "No existe una cuenta con este email. Verifica el email o regístrate."
        } else if errorDescription.contains("too_many_requests") {
            return "Demasiados intentos. Espera unos minutos antes de intentar nuevamente."
        } else if errorDescription.contains("network") ||
                  errorDescription.contains("connection") {
            return "Error de conexión. Verifica tu internet e intenta nuevamente."
        } else {
            return "Error al iniciar sesión. Verifica tus credenciales e intenta nuevamente."
        }
    }
}

#Preview {
    NavigationView {
        AuthView()
            .environmentObject(AuthViewModel())
    }
}
