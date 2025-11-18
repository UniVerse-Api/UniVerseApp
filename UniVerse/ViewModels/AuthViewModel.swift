// ViewModels/AuthViewModel.swift
import Foundation
import Supabase

enum InitialView {
    case auth           // Pantalla de login/registro
    case feed          // Pantalla principal (feed de publicaciones)
    case studentDashboard // Dashboard del estudiante con navbar
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var isAuthenticated = false
    @Published var initialView: InitialView = .auth
    @Published var errorMessage: String?
    @Published var currentUser: Usuario?
    @Published var registrationSuccessMessage: String? = nil   // <- nuevo

    private let supabase = SupabaseManager.shared.client
    
    // ejecuta automaticamente al crear el ViewModel
    init() {
        checkAuth()
    }
    
    // Verificar si hay sesion activa
    func checkAuth() {
        print("[DEBUG] Verificando autenticación...")
        Task {
            do {
                let session = try await supabase.auth.session
                print("[DEBUG] Sesión encontrada para usuario: \(session.user.id)")
                
                let userId = session.user.id
                await loadUserData(userId: userId)
                
                // Validar estado del usuario
                guard let user = self.currentUser else {
                    print("[DEBUG] No se pudo cargar el usuario, redirigiendo a auth")
                    self.initialView = .auth
                    self.isLoading = false
                    return
                }
                
                guard user.estado == .activo else {
                    print("[DEBUG] Usuario no activo, cerrando sesión")
                    // Si el usuario no está activo, cerrar sesión
                    try await supabase.auth.signOut()
                    self.initialView = .auth
                    self.isLoading = false
                    return
                }
                
                self.isAuthenticated = true
                print("[DEBUG] Usuario autenticado, rol: \(user.rol)")
                
                // Determinar vista inicial según el rol
                switch user.rol {
                case .estudiante:
                    print("[DEBUG] Configurando vista inicial para estudiante")
                    self.initialView = .studentDashboard
                case .empresa:
                    print("[DEBUG] Configurando vista inicial para empresa")
                    self.initialView = .feed
                default:
                    print("[DEBUG] Configurando vista inicial por defecto")
                    self.initialView = .feed
                }
                
                self.isLoading = false
                
            } catch {
                print("[DEBUG] Error en checkAuth o no hay sesión: \(error)")
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
        print("[DEBUG] Iniciando carga de datos para usuario: \(userId)")
        
        do {
            print("[DEBUG] Consultando tabla usuario...")
            // 1. Cargar usuario base
            let userResponse: [Usuario] = try await supabase
                .from("usuario")
                .select("id_usuario, rol, estado, fecha_creacion")
                .eq("id_usuario", value: userId.uuidString)
                .execute()
                .value
            
            print("[DEBUG] Respuesta de usuario: \(userResponse)")
            
            guard var usuario = userResponse.first else {
                print("[ERROR] No se encontró usuario con ID: \(userId)")
                self.errorMessage = "Usuario no encontrado"
                return
            }
            
            print("[DEBUG] Usuario encontrado: \(usuario.rol)")
            
            // 2. Cargar perfil base
            print("[DEBUG] Consultando tabla perfil...")
            let perfilResponse: [Perfil] = try await supabase
                .from("perfil")
                .select("id_perfil, id_usuario, nombre_completo, foto_perfil, biografia, ubicacion, telefono, sitio_web, pais")
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
                    
                } else if usuario.rol == .universidad || usuario.rol == .docente || usuario.rol == .admin {
                    // Estos roles no necesitan datos específicos ya que no pueden acceder
                    print("Usuario con rol restringido detectado: \(usuario.rol)")
                }
                
                usuario.perfil = perfil
                
            } else {
                self.errorMessage = "Perfil no encontrado"
            }
            
            self.currentUser = usuario
            print("[DEBUG] Usuario cargado exitosamente: \(usuario.perfil?.nombreCompleto ?? "Sin nombre")")
            
        } catch {
            print("[ERROR] Error al cargar datos del usuario: \(error)")
            print("[ERROR] Error detallado en loadUserDataFallback: \(error)")
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
        registrationSuccessMessage = nil   // limpiar previo
        
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
                // No iniciar sesión automáticamente.
                // Dejar al usuario en la pantalla de login y mostrar mensaje de éxito.
                self.registrationSuccessMessage = "Registro exitoso. Por favor, inicia sesión."
                self.isAuthenticated = false
                self.initialView = .auth
            } else {
                throw AuthError.perfilNoCreado
            }
            
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            throw error
        }
    }
    
    // REGISTRO ESTUDIANTE CON ARCHIVOS
    func registrarEstudianteConArchivos(
        userId: String,
        email: String,
        password: String,
        nombreCompleto: String,
        carrera: String,
        telefono: String,
        biografia: String,
        ubicacion: String,
        pais: String,
        nombreComercial: String?,
        universidadActual: String?,
        fotoPerfilURL: String?,
        cvURL: String?,
        cvNombre: String?
    ) async throws {
        
        print("[DEBUG] Registrando estudiante con archivos...")
        print("[DEBUG] Foto URL: \(fotoPerfilURL ?? "nil")")
        print("[DEBUG] CV URL: \(cvURL ?? "nil")")
        
        isLoading = true
        errorMessage = nil
        registrationSuccessMessage = nil
        
        do {
            // Usar el userId pasado como parámetro
            guard let userUUID = UUID(uuidString: userId) else {
                throw AuthError.registrationFailed("ID de usuario inválido")
            }
            
            // Llamar function de Supabase con URLs de archivos
            let datos = RegistroEstudianteRequest(
                pIdUsuario: userUUID,
                pNombreCompleto: nombreCompleto,
                pBiografia: biografia,
                pUbicacion: ubicacion,
                pTelefono: telefono,
                pNombreComercial: nombreComercial ?? "",
                pCarrera: carrera,
                pUniversidadActual: universidadActual,
                pFotoPerfil: fotoPerfilURL,
                pSitioWeb: nil,
                pPais: pais
            )
            
            let response: RegistroResponse = try await supabase
                .rpc("registrar_estudiante", params: datos)
                .execute()
                .value
            
            if response.success {
                // Si hay CV, insertar en la tabla CV_archivo
                if let cvURL = cvURL, let cvNombre = cvNombre {
                    print("[DEBUG] Insertando CV en base de datos...")
                    
                    // Primero obtener el id_perfil del perfil recién creado
                    let perfilResponse: [Perfil] = try await supabase
                        .from("perfil")
                        .select("id_perfil")
                        .eq("id_usuario", value: userId)
                        .execute()
                        .value
                    
                    if let perfil = perfilResponse.first {
                        // Crear estructura para insertar CV
                        struct CVInsert: Codable {
                            let id_perfil: Int
                            let nombre: String
                            let url_cv: String
                            let visible: String
                        }
                        
                        let cvInsert = CVInsert(
                            id_perfil: perfil.id,
                            nombre: cvNombre,
                            url_cv: cvURL,
                            visible: "si"
                        )
                        
                        let _: [CVArchivo] = try await supabase
                            .from("cv_archivo")
                            .insert(cvInsert)
                            .execute()
                            .value
                        
                        print("[DEBUG] CV insertado exitosamente")
                    }
                }
                
                self.registrationSuccessMessage = "Registro exitoso. Por favor, inicia sesión."
                self.isAuthenticated = false
                self.initialView = .auth
            } else {
                throw AuthError.perfilNoCreado
            }
            
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            print("[ERROR] Error en registro con archivos: \(error)")
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
        print("[DEBUG] Iniciando login para: \(email)")
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            
            print("[DEBUG] Autenticación exitosa, ID de usuario: \(response.user.id)")
            
            // Cargar datos del usuario para validaciones
            await loadUserData(userId: response.user.id)
            
            // Validar que el usuario esté cargado
            guard let user = self.currentUser else {
                print("[DEBUG] Error: No se pudo cargar el usuario después de la autenticación")
                throw AuthError.usuarioNoEncontrado
            }
            
            print("[DEBUG] Usuario cargado correctamente: \(user.rol)")
            
            // Validar estado del usuario
            guard user.estado == .activo else {
                print("[DEBUG] Usuario no está activo: \(user.estado)")
                // Cerrar sesión si el usuario no está activo
                try await supabase.auth.signOut()
                throw AuthError.usuarioInactivo
            }
            
            // Validar que tenga perfil
            guard user.perfil != nil else {
                print("[DEBUG] Usuario no tiene perfil")
                throw AuthError.perfilNoEncontrado
            }
            
            self.isAuthenticated = true
            print("[DEBUG] Autenticación completada, determinando vista inicial...")
            
            // Determinar vista inicial según el rol
            switch user.rol {
            case .estudiante:
                print("[DEBUG] Configurando vista para estudiante")
                self.initialView = .studentDashboard
            case .empresa:
                print("[DEBUG] Configurando vista para empresa")
                self.initialView = .feed
            default:
                print("[DEBUG] Configurando vista por defecto")
                self.initialView = .feed
            }
            
            self.isLoading = false
            print("[DEBUG] Login exitoso para rol: \(user.rol)")
            
        } catch {
            self.isLoading = false
            print("[DEBUG] Error en signIn: \(error)")
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
    case usuarioNoEncontrado
    case usuarioInactivo
    case perfilNoEncontrado
    case registrationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .registroFallido:
            return "No se pudo crear la cuenta"
        case .perfilNoCreado:
            return "Error al crear el perfil"
        case .usuarioNoEncontrado:
            return "Usuario no encontrado en la base de datos"
        case .usuarioInactivo:
            return "Tu cuenta está inactiva. Contacta al administrador para más información."
        case .perfilNoEncontrado:
            return "No se encontró el perfil del usuario. Contacta al soporte técnico."
        case .registrationFailed(let message):
            return "Error en el registro: \(message)"
        }
    }
}
