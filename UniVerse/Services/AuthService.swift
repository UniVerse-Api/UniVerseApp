// Services/AuthService.swift
import Supabase

class AuthService {
    private let client = SupabaseManager.shared.client
    
    // Registro completo
    func registrarEstudiante(
        email: String,
        password: String,
        datos: RegistroEstudianteRequest
    ) async throws -> RegistroResponse {
        
        // 1. Crear usuario en auth
        let authResponse = try await client.auth.signUp(
            email: email,
            password: password
        )
        
        let userId = authResponse.user.id
        
        // 2. Llamar a la function de Supabase
        var datosCompletos = RegistroEstudianteRequest(
            pIdUsuario: userId,
            pNombreCompleto: datos.pNombreCompleto,
            pBiografia: datos.pBiografia,
            pUbicacion: datos.pUbicacion,
            pTelefono: datos.pTelefono,
            pNombreComercial: datos.pNombreComercial,
            pCarrera: datos.pCarrera,
            pUniversidadActual: datos.pUniversidadActual,
            pFotoPerfil: datos.pFotoPerfil,
            pSitioWeb: datos.pSitioWeb,
            pPais: datos.pPais
        )   
        
        let response: RegistroResponse = try await client
            .rpc("registrar_estudiante", params: datosCompletos)
            .execute()
            .value
        
        return response
    }
    
    // Login simple
    func login(email: String, password: String) async throws {
        try await client.auth.signIn(
            email: email,
            password: password
        )
    }
    
    // Logout
    func logout() async throws {
        try await client.auth.signOut()
    }
}

