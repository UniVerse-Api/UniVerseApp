// ViewModels/AuthViewModel.swift
import Foundation
import Supabase

enum InitialView {
    case auth    // Pantalla de login/registro
    case feed    // Pantalla principal (feed de publicaciones)
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var isAuthenticated = false
    @Published var initialView: InitialView = .auth
    @Published var errorMessage: String?
    @Published var currentUser: Usuario?
    
    private let supabase = SupabaseManager.shared.client
    
    // ejecuta automaticamente al crear el ViewModel
    init() {
        checkAuth()
    }
    
    // Verificar si hay sesion activa
    func checkAuth() {
        Task {
            do {
                let session = try await supabase.auth.session
                
                if let userId = session.user.id {
                    await loadUserData(userId: userId)
                    self.isAuthenticated = true
                    self.initialView = .feed
                }
                
                self.isLoading = false
                
            } catch {
                self.initialView = .auth
                self.isLoading = false
            }
        }
    }
    
    // Cargar datos del usuario
    private func loadUserData(userId: UUID) async {
        do {
            let response: [Usuario] = try await supabase
                .from("Usuario")
                .select("*, Perfil(*)")
                .eq("id_usuario", value: userId.uuidString)
                .execute()
                .value
            
            self.currentUser = response.first
            
        } catch {
            print("Error cargando usuario: \(error)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    // REGISTRO ESTUDIANTE
    func registrarEstudiante(
        email: String,
        password: String,
        nombreCompleto: String,
        carrera: String,
        telefono: String,
        biografia: String,
        ubicacion: String,
        nombreComercial: String?,
        universidadActual: String?
    ) async throws {
        
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Crear usuario en auth
            let authResponse = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            
            guard let userId = authResponse.user.id else {
                throw AuthError.registroFallido
            }
            
            // 2. Llamar function de Supabase
            let datos = RegistroEstudianteRequest(
                pIdUsuario: userId,
                pNombreCompleto: nombreCompleto,
                pBiografia: biografia,
                pUbicacion: ubicacion,
                pTelefono: telefono,
                pNombreComercial: nombreComercial ?? "",
                pCarrera: carrera,
                pUniversidadActual: universidadActual,
                pFotoPerfil: nil,
                pSitioWeb: nil
            )
            
            let response: RegistroResponse = try await supabase
                .rpc("registrar_estudiante", params: datos)
                .execute()
                .value
            
            if response.success {
                await loadUserData(userId: userId)
                self.isAuthenticated = true
                self.initialView = .feed
            } else {
                throw AuthError.errorEnPerfil(response.error ?? "Error desconocido")
            }
            
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            throw error
        }
    }
    
    // REGISTRO EMPRESA
    func registrarEmpresa(
        email: String,
        password: String,
        nombreCompleto: String,
        nombreEmpresa: String,
        telefono: String,
        biografia: String,
        ubicacion: String,
        sitioWeb: String?
    ) async throws {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let authResponse = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            
            guard let userId = authResponse.user.id else {
                throw AuthError.registroFallido
            }
            
            // Aquí llamarías a tu function registrar_empresa
            let datos = RegistroEmpresaRequest(
                pIdUsuario: userId,
                pNombreCompleto: nombreCompleto,
                pNombreEmpresa: nombreEmpresa,
                pBiografia: biografia,
                pUbicacion: ubicacion,
                pTelefono: telefono,
                pSitioWeb: sitioWeb,
                pFotoPerfil: nil
            )
            
            let response: RegistroResponse = try await supabase
                .rpc("registrar_empresa", params: datos)
                .execute()
                .value
            
            if response.success {
                await loadUserData(userId: userId)
                self.isAuthenticated = true
                self.initialView = .feed
            } else {
                throw AuthError.errorEnPerfil(response.error ?? "Error desconocido")
            }
            
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            throw error
        }
    }
    
    // LOGIN (para todos)
    func signIn(email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            
            await loadUserData(userId: response.user.id)
            
            self.isAuthenticated = true
            self.initialView = .feed
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            throw error
        }
    }
    
    // LOGOUT (para todos)
    func signOut() async throws {
        do {
            try await supabase.auth.signOut()
            
            self.isAuthenticated = false
            self.currentUser = nil
            self.initialView = .auth
            
        } catch {
            throw error
        }
    }
}

enum AuthError: LocalizedError {
    case registroFallido
    case errorEnPerfil(String)
    
    var errorDescription: String? {
        switch self {
        case .registroFallido:
            return "No se pudo crear la cuenta"
        case .errorEnPerfil(let mensaje):
            return "Error al crear perfil: \(mensaje)"
        }
    }
}