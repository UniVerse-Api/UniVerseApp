// Views/AuthView.swift
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showPassword = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // Fondo oscuro
            Color.backgroundDark
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Card de login
                VStack(spacing: 20) {
                    // Título
                    VStack(spacing: 4) {
                        Text("Accede")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                        
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
                                    .foregroundColor(.white)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .tint(.primaryOrange)
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
                                        .foregroundColor(.white)
                                        .tint(.primaryOrange)
                                } else {
                                    SecureField("", text: $password)
                                        .foregroundColor(.white)
                                        .tint(.primaryOrange)
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
                                        .foregroundColor(.white)
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
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func handleAuth() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa todos los campos"
            showingAlert = true
            return
        }
        
        Task {
            do {
                try await authVM.signIn(email: email, password: password)
            } catch {
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
}

#Preview {
    NavigationView {
        AuthView()
            .environmentObject(AuthViewModel())
    }
}
