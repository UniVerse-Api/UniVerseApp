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
                
                let userId = session.user.id
                await loadUserData(userId: userId)
                self.isAuthenticated = true
                self.initialView = .feed
                
                self.isLoading = false
                
            } catch {
                self.initialView = .auth
                self.isLoading = false
            }
        }
    }
    
    // Cargar datos del usuario (método principal - usa separación de consultas)
    private func loadUserData(userId: UUID) async {
        await loadUserDataFallback(userId: userId)
    }
    
    // Método alternativo de carga de datos (consultas separadas)
    private func loadUserDataFallback(userId: UUID) async {
        do {
            // 1. Cargar usuario base
            let userResponse: [Usuario] = try await supabase
                .from("usuario")
                .select("id_usuario, rol, estado, fecha_creacion")
                .eq("id_usuario", value: userId.uuidString)
                .execute()
                .value
            
            guard var usuario = userResponse.first else {
                self.errorMessage = "Usuario no encontrado"
                return
            }
            
            // 2. Cargar perfil base
            let perfilResponse: [Perfil] = try await supabase
                .from("perfil")
                .select("id_perfil, id_usuario, nombre_completo, foto_perfil, biografia, ubicacion, telefono, sitio_web, pais")  // AGREGADO pais
                .eq("id_usuario", value: userId.uuidString)
                .execute()
                .value
            
            if var perfil = perfilResponse.first {
                
                // 3. Cargar detalles específicos según el rol
                if usuario.rol == .estudiante {
                    let estudianteResponse: [PerfilEstudiante] = try await supabase
                        .from("perfil_estudiante")
                        .select("*")
                        .eq("id_perfil", value: perfil.id)
                        .execute()
                        .value
                    
                    perfil.perfilEstudiante = estudianteResponse.first
                    
                } else if usuario.rol == .empresa {
                    let empresaResponse: [PerfilEmpresa] = try await supabase
                        .from("perfil_empresa")
                        .select("*")
                        .eq("id_perfil", value: perfil.id)
                        .execute()
                        .value
                    
                    perfil.perfilEmpresa = empresaResponse.first
                }
                
                usuario.perfil = perfil
                
            } else {
                self.errorMessage = "Perfil no encontrado"
            }
            
            self.currentUser = usuario
            
        } catch {
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
        pais: String,  // NUEVO PARÁMETRO
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
            
            let userId = authResponse.user.id
            
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
                pSitioWeb: nil,
                pPais: pais  // NUEVO CAMPO
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
                throw AuthError.perfilNoCreado
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
            
            let userId = authResponse.user.id
            
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
                throw AuthError.perfilNoCreado
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
    
    // Función para recargar datos del usuario actual
    func reloadCurrentUser() async {
        do {
            let session = try await supabase.auth.session
            await loadUserData(userId: session.user.id)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

enum AuthError: LocalizedError {
    case registroFallido
    case perfilNoCreado
    
    var errorDescription: String? {
        switch self {
        case .registroFallido:
            return "No se pudo crear la cuenta"
        case .perfilNoCreado:
            return "Error al crear el perfil"
        }
    }
}
