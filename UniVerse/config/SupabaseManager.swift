// config/SupabaseManager.swift
import Foundation
import Supabase

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    @Published var connectionStatus: String = "No probado"
    @Published var isConnecting: Bool = false
    @Published var insertStatus: String = "No insertado"
    @Published var isInserting: Bool = false
    @Published var loginStatus: String = "No logueado"
    @Published var isLoggingIn: Bool = false
    @Published var lastCreatedEmail: String = ""
    
    private init() {
        // Leer credenciales desde Info.plist (que toma los valores de Config.xcconfig)
        guard let supabaseURL = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
              let supabaseKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
              !supabaseURL.isEmpty,
              !supabaseKey.isEmpty,
              !supabaseURL.contains("$("), // Verificar que las variables se resolvieron correctamente
              !supabaseKey.contains("$("),
              let url = URL(string: supabaseURL) else {
            fatalError("❌ Configuración de Supabase faltante. Verifica Config.xcconfig e Info.plist")
        }
        
        client = SupabaseClient(supabaseURL: url, supabaseKey: supabaseKey)
    }
    
    @MainActor
    func testConnection() async {
        isConnecting = true
        connectionStatus = "Conectando..."
        
        do {
            // Primero intentar con minúsculas (estándar PostgreSQL)
            let response = try await client
                .from("usuario")
                .select("*", head: true, count: .exact)
                .execute()
            
            let count = response.count ?? 0
            connectionStatus = "✅ Conexión exitosa - \(count) usuarios en BD"
            
        } catch {
            do {
                // Si falla, probar con mayúsculas (por si acaso)
                let response = try await client
                    .from("Usuario")
                    .select("*", head: true, count: .exact)
                    .execute()
                
                let count = response.count ?? 0
                connectionStatus = "✅ Conexión exitosa - \(count) usuarios en BD"
                
            } catch {
                do {
                    // Último intento: solo verificar acceso básico a la API
                    let _ = try await client
                        .from("usuario")
                        .select("id_usuario")
                        .limit(0)
                        .execute()
                    
                    connectionStatus = "✅ Conexión exitosa - API accesible"
                } catch {
                    connectionStatus = "❌ Error: \(error.localizedDescription)"
                }
            }
        }
        
        isConnecting = false
    }
    
    @MainActor
    func insertTestUser() async {
        isInserting = true
        insertStatus = "Creando usuario completo..."
        
        // Datos hardcodeados para el usuario de prueba - MISMO EMAIL PARA AMBAS OPERACIONES
        let testEmail = "oscar.aguilar1@catolica.edu.sv"
        let testPassword = "Password123!"
        
        do {
            // Paso 1: Crear usuario en el sistema de autenticación de Supabase
            let authResponse = try await client.auth.signUp(
                email: testEmail,
                password: testPassword
            )
            
            let userId = authResponse.user.id
            
            // Paso 2: Insertar en la tabla Usuario con el ID del auth.users
            let testUser = UsuarioInsert(
                id_usuario: userId.uuidString,
                rol: "estudiante",
                estado: "activo"
            )
            
            // Intentar insertar primero con minúsculas
            do {
                let _ = try await client
                    .from("usuario")
                    .insert(testUser)
                    .execute()
                
                lastCreatedEmail = testEmail
                insertStatus = "✅ Usuario creado: \(testEmail)"
                
            } catch {
                // Si falla, intentar con mayúsculas
                let _ = try await client
                    .from("Usuario")
                    .insert(testUser)
                    .execute()
                
                lastCreatedEmail = testEmail
                insertStatus = "✅ Usuario creado: \(testEmail)"
            }
            
        } catch {
            insertStatus = "❌ Error al crear usuario: \(error.localizedDescription)"
        }
        
        isInserting = false
    }
    
    @MainActor
    func loginTestUser() async {
        isLoggingIn = true
        loginStatus = "Intentando login..."
        
        // Usar el último email creado o uno fijo si no hay ninguno
        let testEmail = lastCreatedEmail.isEmpty ? "oscar.aguilar1@catolica.edu.sv" : lastCreatedEmail
        let testPassword = "Password123!"
        
        do {
            let response = try await client.auth.signIn(
                email: testEmail,
                password: testPassword
            )
            
            let user = response.user
            loginStatus = "✅ Login exitoso: \(user.email ?? "Sin email")"
            
        } catch {
            loginStatus = "❌ Error de login: \(error.localizedDescription)"
        }
        
        isLoggingIn = false
    }
    
    @MainActor
    func insertRandomUser() async {
        isInserting = true
        insertStatus = "Creando usuario aleatorio..."
        
        // Email aleatorio para crear múltiples usuarios de prueba
        let randomEmail = "usuario.prueba.\(Int.random(in: 1000...9999))@test.com"
        let testPassword = "Password123!"
        
        do {
            let authResponse = try await client.auth.signUp(
                email: randomEmail,
                password: testPassword
            )
            
            let userId = authResponse.user.id
            
            let testUser = UsuarioInsert(
                id_usuario: userId.uuidString,
                rol: "estudiante",
                estado: "activo"
            )
            
            do {
                let _ = try await client
                    .from("usuario")
                    .insert(testUser)
                    .execute()
                
                lastCreatedEmail = randomEmail
                insertStatus = "✅ Usuario aleatorio creado: \(randomEmail)"
                
            } catch {
                let _ = try await client
                    .from("Usuario")
                    .insert(testUser)
                    .execute()
                
                lastCreatedEmail = randomEmail
                insertStatus = "✅ Usuario aleatorio creado: \(randomEmail)"
            }
            
        } catch {
            insertStatus = "❌ Error al crear usuario aleatorio: \(error.localizedDescription)"
        }
        
        isInserting = false
    }
}

// Estructura para leer usuarios
struct Usuario: Codable {
    let id_usuario: String?
    let rol: String?
    let fecha_creacion: String?
    let estado: String?
    
    private enum CodingKeys: String, CodingKey {
        case id_usuario = "id_usuario"
        case rol = "rol"
        case fecha_creacion = "fecha_creacion"
        case estado = "estado"
    }
}

// Estructura para insertar usuarios (sin fecha_creacion porque es automática)
struct UsuarioInsert: Codable {
    let id_usuario: String
    let rol: String
    let estado: String
    
    private enum CodingKeys: String, CodingKey {
        case id_usuario = "id_usuario"
        case rol = "rol"
        case estado = "estado"
    }
}