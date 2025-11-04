import SwiftUI

struct ContentView: View {
    @StateObject private var supabaseManager = SupabaseManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("UniVerse App")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                Text("Estado de conexión:")
                    .font(.headline)
                
                Text(supabaseManager.connectionStatus)
                    .font(.subheadline)
                    .foregroundColor(getStatusColor())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Button(action: {
                    Task {
                        await supabaseManager.testConnection()
                    }
                }) {
                    HStack {
                        if supabaseManager.isConnecting {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "network")
                        }
                        Text(supabaseManager.isConnecting ? "Conectando..." : "Probar Conexión")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(supabaseManager.isConnecting ? Color.gray : Color.blue)
                    .cornerRadius(10)
                }
                .disabled(supabaseManager.isConnecting)
                
                // Nuevo botón para insertar usuario
                VStack(spacing: 10) {
                    Text("Insertar Usuario de Prueba:")
                        .font(.headline)
                    
                    Text(supabaseManager.insertStatus)
                        .font(.subheadline)
                        .foregroundColor(getInsertStatusColor())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Button(action: {
                        Task {
                            await supabaseManager.insertTestUser()
                        }
                    }) {
                        HStack {
                            if supabaseManager.isInserting {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "person.badge.plus")
                            }
                            Text(supabaseManager.isInserting ? "Insertando..." : "Insertar Usuario")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(supabaseManager.isInserting ? Color.gray : Color.green)
                        .cornerRadius(10)
                    }
                    .disabled(supabaseManager.isInserting)
                }
                
                // Botón para login de prueba
                VStack(spacing: 10) {
                    Text("Login de Prueba:")
                        .font(.headline)
                    
                    Text(supabaseManager.loginStatus)
                        .font(.subheadline)
                        .foregroundColor(getLoginStatusColor())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Button(action: {
                        Task {
                            await supabaseManager.loginTestUser()
                        }
                    }) {
                        HStack {
                            if supabaseManager.isLoggingIn {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "person.circle")
                            }
                            Text(supabaseManager.isLoggingIn ? "Logueando..." : "Login Test")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(supabaseManager.isLoggingIn ? Color.gray : Color.purple)
                        .cornerRadius(10)
                    }
                    .disabled(supabaseManager.isLoggingIn)
                }
            }
        }
        .padding()
    }
    
    private func getStatusColor() -> Color {
        if supabaseManager.connectionStatus.contains("✅") {
            return .green
        } else if supabaseManager.connectionStatus.contains("❌") {
            return .red
        } else {
            return .orange
        }
    }
    
    private func getInsertStatusColor() -> Color {
        if supabaseManager.insertStatus.contains("✅") {
            return .green
        } else if supabaseManager.insertStatus.contains("❌") {
            return .red
        } else {
            return .orange
        }
    }
    
    private func getLoginStatusColor() -> Color {
        if supabaseManager.loginStatus.contains("✅") {
            return .green
        } else if supabaseManager.loginStatus.contains("❌") {
            return .red
        } else {
            return .orange
        }
    }
}

#Preview {
    ContentView()
}
