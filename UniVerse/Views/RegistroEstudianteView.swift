// Views/RegistroEstudianteView.swift
import SwiftUI

struct RegistroEstudianteView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var nombreCompleto = ""
    @State private var carrera = ""
    @State private var telefono = ""
    @State private var biografia = ""
    @State private var ubicacion = ""
    @State private var universidad = ""
    
    var body: some View {
        Form {
            Section("Cuenta") {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                SecureField("Contraseña", text: $password)
            }
            
            Section("Información Personal") {
                TextField("Nombre completo", text: $nombreCompleto)
                TextField("Teléfono", text: $telefono)
                TextField("Ubicación", text: $ubicacion)
                TextField("Biografía", text: $biografia)
            }
            
            Section("Información Académica") {
                TextField("Carrera", text: $carrera)
                TextField("Universidad (opcional)", text: $universidad)
            }
            
            if let error = authVM.errorMessage {
                Section {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            
            Button("Registrar") {
                Task {
                    try? await authVM.registrarEstudiante(
                        email: email,
                        password: password,
                        nombreCompleto: nombreCompleto,
                        carrera: carrera,
                        telefono: telefono,
                        biografia: biografia,
                        ubicacion: ubicacion,
                        nombreComercial: nil,
                        universidadActual: universidad.isEmpty ? nil : universidad
                    )
                }
            }
            .disabled(authVM.isLoading)
        }
        .navigationTitle("Registro Estudiante")
    }
}
