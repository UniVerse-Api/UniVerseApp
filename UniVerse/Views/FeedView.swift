// Views/FeedView.swift
import SwiftUI

struct FeedView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Header con información del usuario
                if let user = authVM.currentUser {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Bienvenido")
                                .font(.headline)
                            Text(user.perfil?.nombreCompleto ?? "Usuario")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        Button("Cerrar sesión") {
                            Task {
                                try? await authVM.signOut()
                            }
                        }
                        .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                }
                
                // Contenido principal del feed
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Feed de UniVerse")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        Text("Aquí aparecerán las publicaciones, ofertas de trabajo y contenido de la red social.")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        // Placeholder para el contenido del feed
                        ForEach(1...5, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Usuario \(index)")
                                            .fontWeight(.semibold)
                                        Text("hace 2 horas")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                
                                Text("Esta es una publicación de ejemplo #\(index). Aquí los usuarios podrán compartir sus experiencias, proyectos y conectar con empresas.")
                                    .lineLimit(nil)
                                
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "heart")
                                        Text("Me gusta")
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {}) {
                                        Image(systemName: "message")
                                        Text("Comentar")
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {}) {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("Compartir")
                                    }
                                }
                                .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    FeedView()
        .environmentObject(AuthViewModel())
}