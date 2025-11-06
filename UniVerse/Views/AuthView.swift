// Views/AuthView.swift
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo o título
                Text("UniVerse")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Spacer()
                
                // Formulario
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Contraseña", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if !isLoginMode {
                        SecureField("Confirmar contraseña", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding(.horizontal, 40)
                
                // Botones
                VStack(spacing: 10) {
                    Button(action: handleAuth) {
                        HStack {
                            if authVM.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            }
                            Text(isLoginMode ? "Iniciar sesión" : "Crear cuenta")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .disabled(authVM.isLoading)
                    
                    Button(action: {
                        isLoginMode.toggle()
                    }) {
                        Text(isLoginMode ? "¿No tienes cuenta? Regístrate" : "¿Ya tienes cuenta? Inicia sesión")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 40)
                
                if !isLoginMode {
                    NavigationLink("Registrarse como Estudiante", destination: RegistroEstudianteView())
                        .padding()
                        .foregroundColor(.green)
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
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
        
        if isLoginMode {
            Task {
                do {
                    try await authVM.signIn(email: email, password: password)
                } catch {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        } else {
            alertMessage = "Para registrarte, selecciona el tipo de cuenta"
            showingAlert = true
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}