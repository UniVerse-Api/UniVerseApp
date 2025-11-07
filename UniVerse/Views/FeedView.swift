// Views/FeedView.swift
import SwiftUI

struct FeedView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Welcome Card
                        welcomeCard
                        
                        // Feed Title Section
                        feedTitleSection
                        
                        // Posts Feed
                        ForEach(1...5, id: \.self) { index in
                            postCard(index: index)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                // Logo
                HStack(spacing: 8) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.primaryOrange)
                    
                    Text("UniVerse")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        Task {
                            await authVM.reloadCurrentUser()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16))
                            .foregroundColor(.primaryOrange)
                            .padding(8)
                            .background(Color.primaryOrange.opacity(0.15))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        Task {
                            try? await authVM.signOut()
                        }
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.red.opacity(0.15))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.backgroundDark.opacity(0.8))
        .backdrop()
    }
    
    // MARK: - Welcome Card
    private var welcomeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bienvenido")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textSecondary)
            
            if let user = authVM.currentUser {
                if let perfil = user.perfil {
                    Text(perfil.nombreCompleto)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.orange)
                        
                        Text("Perfil no disponible")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
            } else {
                HStack(spacing: 12) {
                    ProgressView()
                        .tint(.primaryOrange)
                    
                    Text("Cargando...")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.primaryOrange.opacity(0.15),
                    Color.primaryOrange.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Feed Title Section
    private var feedTitleSection: some View {
        VStack(spacing: 8) {
            Text("Feed de UniVerse")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
            
            Text("Aquí aparecerán las publicaciones, ofertas de trabajo y contenido de la red social.")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Post Card
    private func postCard(index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text("U\(index)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Usuario \(index)")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("hace 2 horas")
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                        .rotationEffect(.degrees(90))
                }
            }
            .padding(16)
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                Text("Esta es una publicación de ejemplo #\(index). Aquí los usuarios podrán compartir sus experiencias, proyectos y conectar con empresas.")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
                .padding(.horizontal, 16)
            
            // Actions
            HStack(spacing: 0) {
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "heart")
                            .font(.system(size: 16))
                        
                        Text("Me gusta")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "message")
                            .font(.system(size: 16))
                        
                        Text("Comentar")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16))
                        
                        Text("Compartir")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationView {
        FeedView()
            .environmentObject(AuthViewModel())
    }
    .preferredColorScheme(.dark)
}
