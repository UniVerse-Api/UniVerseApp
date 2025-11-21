// Views/FeedView.swift
import SwiftUI
import Foundation

struct FeedView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var feedVM = FeedViewModel()
    
    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                
                // MARK: - Main Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Welcome Card
                        welcomeCard
                        
                        // Error Message
                        if let errorMessage = feedVM.errorMessage {
                            errorCard(message: errorMessage)
                        }
                        
                        // Feed Content
                        feedContent
                        
                        // Loading More Indicator
                        if feedVM.isLoadingMore {
                            loadingMoreIndicator
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .refreshable {
                    await refreshFeed()
                }
                .onAppear {
                    loadFeedIfNeeded()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Feed Content
    @ViewBuilder
    private var feedContent: some View {
        if feedVM.isLoading {
            loadingIndicator
        } else if feedVM.isEmpty {
            emptyFeedView
        } else {
            ForEach(feedVM.feedItems, id: \.uniqueId) { feedItem in
                feedItemCard(feedItem)
                    .onAppear {
                        // Load more when approaching the end
                        if feedItem.uniqueId == feedVM.feedItems.last?.uniqueId {
                            loadMoreIfNeeded()
                        }
                        
                        // Mark anuncio as viewed
                        if feedItem.esAnuncio {
                            Task {
                                await feedVM.markAnuncioAsViewed(feedItem)
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - Loading Indicator
    private var loadingIndicator: some View {
        VStack(spacing: 16) {
            ForEach(0..<3, id: \.self) { _ in
                skeletonCard
            }
        }
    }
    
    // MARK: - Loading More Indicator
    private var loadingMoreIndicator: some View {
        HStack {
            Spacer()
            ProgressView()
                .tint(.primaryOrange)
            Text("Cargando más...")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
            Spacer()
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Empty Feed View
    private var emptyFeedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundColor(.textSecondary)
            
            Text("No hay publicaciones")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("Sigue a más personas o empresas para ver contenido en tu feed")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.vertical, 40)
    }
    
    // MARK: - Error Card
    private func errorCard(message: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 20))
                .foregroundColor(.red)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button("Reintentar") {
                loadFeedIfNeeded()
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.primaryOrange)
        }
        .padding(16)
        .background(Color.red.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Skeleton Card
    private var skeletonCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 12)
                        .cornerRadius(6)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 10)
                        .cornerRadius(5)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 12)
                    .cornerRadius(6)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 12)
                    .cornerRadius(6)
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .redacted(reason: .placeholder)
    }
    
    // MARK: - Feed Item Card
    private func feedItemCard(_ feedItem: FeedItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                // Profile Image - Clickeable
                NavigationLink(
                    destination: ProfileDestinationView(
                        idPerfil: feedItem.idPerfil,
                        nombreCompleto: feedItem.nombreCompleto,
                        fotoPerfil: feedItem.fotoPerfil,
                        esEmpresa: feedItem.esEmpresa
                    )
                    .environmentObject(authVM)
                ) {
                    profileImageView(feedItem)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        // Nombre - Clickeable
                        NavigationLink(
                            destination: ProfileDestinationView(
                                idPerfil: feedItem.idPerfil,
                                nombreCompleto: feedItem.nombreCompleto,
                                fotoPerfil: feedItem.fotoPerfil,
                                esEmpresa: feedItem.esEmpresa
                            )
                            .environmentObject(authVM)
                        ) {
                            Text(feedItem.nombreCompleto)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.textPrimary)
                        }
                        
                        // Badges
                        if feedItem.esAnuncio {
                            Text("Anuncio")
                                .font(.system(size: 10, weight: .medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.primaryOrange.opacity(0.2))
                                .foregroundColor(.primaryOrange)
                                .cornerRadius(4)
                        }
                        
                        // Badge de empresa verificada
                        if feedItem.esEmpresa {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundColor(feedItem.esPremium ? .yellow : .blue)
                        }
                        
                        if feedItem.esSeguido {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.green)
                        }
                        
                        if feedItem.esFavorito {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                        }
                        
                        if feedItem.esDestacado {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Text(timeAgoString(from: feedItem.fechaPublicacion))
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary)
                        
                        if let vistaContador = feedItem.vistaContador {
                            Text("• \(vistaContador) vistas")
                                .font(.system(size: 11))
                                .foregroundColor(.textSecondary)
                        }
                    }
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
            
            // Title (if exists)
            if let titulo = feedItem.titulo, !titulo.isEmpty {
                Text(titulo)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }
            
            // Content
            Text(feedItem.descripcion)
                .font(.system(size: 14))
                .foregroundColor(.textPrimary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            
            // Resources (if any)
            if !feedItem.recursos.isEmpty {
                resourcesView(feedItem.recursos)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
            
            // Date range for anuncios
            if feedItem.esAnuncio, let fechaInicio = feedItem.fechaInicio, let fechaFin = feedItem.fechaFin {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                    
                    Text("Válido del \(dateString(fechaInicio)) al \(dateString(fechaFin))")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
                .padding(.horizontal, 16)
            
            // Actions
            if feedItem.esPublicacion {
                publicacionActions(feedItem)
            } else {
                anuncioActions(feedItem)
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
    
    // MARK: - Resources View
    private func resourcesView(_ recursos: [RecursoItem]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(Array(recursos.enumerated()), id: \.offset) { index, recurso in
                    AsyncImage(url: URL(string: recurso.url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 24))
                                    .foregroundColor(.textSecondary)
                            )
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    // MARK: - Actions for Publicaciones
    private func publicacionActions(_ feedItem: FeedItem) -> some View {
        let esPublicacionPropia = isOwnPost(feedItem)
        
        return HStack(spacing: 0) {
            // Botón de Like - Solo mostrar si NO es publicación propia
            if !esPublicacionPropia {
                Button(action: {
                    handleLike(feedItem)
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: feedItem.tieneLikeUsuario ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(feedItem.tieneLikeUsuario ? .red : .textSecondary)
                        
                        Text("Me gusta")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(feedItem.tieneLikeUsuario ? .red : .textSecondary)
                        
                        if let likes = feedItem.likesContador, likes > 0 {
                            Text("(\(likes))")
                                .font(.system(size: 11))
                                .foregroundColor(feedItem.tieneLikeUsuario ? .red : .textSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                
                // Botón de Comentario - Solo mostrar si NO es publicación propia
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "message")
                            .font(.system(size: 16))
                        
                        Text("Comentar")
                            .font(.system(size: 13, weight: .medium))
                        
                        if let comentarios = feedItem.comentariosContador, comentarios > 0 {
                            Text("(\(comentarios))")
                                .font(.system(size: 11))
                        }
                    }
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
            
            // Botón de Guardar - Siempre mostrar (tanto para propias como ajenas)
            Button(action: {
                handleSave(feedItem)
            }) {
                HStack(spacing: 6) {
                    Image(systemName: feedItem.estaGuardado ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16))
                        .foregroundColor(feedItem.estaGuardado ? .primaryOrange : .textSecondary)
                    
                    Text("Guardar")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(feedItem.estaGuardado ? .primaryOrange : .textSecondary)
                }
                .frame(maxWidth: esPublicacionPropia ? .infinity : .infinity)
                .padding(.vertical, 12)
            }
            
            // Si es publicación propia, agregar botón de opciones/editar
            if esPublicacionPropia {
                Button(action: {
                    // TODO: Implementar acciones de editar/eliminar
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16))
                        
                        Text("Opciones")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
    }
    
    // MARK: - Actions for Anuncios
    private func anuncioActions(_ feedItem: FeedItem) -> some View {
        let esAnuncioPropio = isOwnPost(feedItem)
        
        return HStack(spacing: 12) {
            // Botón "Ver detalles" - Solo mostrar si NO es anuncio propio
            if !esAnuncioPropio {
                Button(action: {}) {
                    Text("Ver detalles")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.primaryOrange)
                        .cornerRadius(8)
                }
            }
            
            // Botón de Guardar - Siempre mostrar
            Button(action: {
                handleSave(feedItem)
            }) {
                HStack(spacing: 6) {
                    Image(systemName: feedItem.estaGuardado ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16))
                    
                    Text("Guardar")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundColor(feedItem.estaGuardado ? .white : .primaryOrange)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(feedItem.estaGuardado ? Color.primaryOrange : Color.primaryOrange.opacity(0.1))
                .cornerRadius(8)
            }
            
            // Si es anuncio propio, mostrar botón de gestión
            if esAnuncioPropio {
                Button(action: {
                    // TODO: Implementar acciones de gestionar anuncio
                }) {
                    Text("Gestionar")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.gray)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Helper Methods
    
    /// Vista del avatar de perfil con efectos premium
    private func profileImageView(_ feedItem: FeedItem) -> some View {
        ZStack {
            // Premium gradient border - SIEMPRE mostrar si es premium
            if feedItem.esPremium {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple, .indigo],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 52, height: 52)
                    .blur(radius: 0.5)
                    .opacity(0.8)
            }
            
            AsyncImage(url: URL(string: feedItem.fotoPerfil ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(
                        feedItem.esPremium ?
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [.gray, .gray]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Text(String(feedItem.nombreCompleto.prefix(2)).uppercased())
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
            .frame(width: 48, height: 48)
            .clipShape(Circle())
            
            // Premium crown - SIEMPRE mostrar si es premium
            if feedItem.esPremium {
                VStack {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 16, height: 16)
                            .overlay(
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.white)
                            )
                    }
                    Spacer()
                }
                .frame(width: 48, height: 48)
            }
        }
    }
    
    /// Determina si una publicación pertenece al usuario actual
    /// - Parameter feedItem: Item del feed a verificar
    /// - Returns: true si la publicación es del usuario actual, false en caso contrario
    private func isOwnPost(_ feedItem: FeedItem) -> Bool {
        guard let currentUser = authVM.currentUser,
              let perfil = currentUser.perfil else {
            return false
        }
        
        return feedItem.idPerfil == perfil.id
    }
    
    private func loadFeedIfNeeded() {
        
        
        guard let currentUser = authVM.currentUser,
              let perfil = currentUser.perfil else {
            print("DEBUG: No user or profile, trying with dummy ID for testing")
            // Para pruebas, usar un ID dummy si no hay usuario
            if feedVM.feedItems.isEmpty && !feedVM.isLoading {
                Task {
                    await feedVM.loadInitialFeed(idPerfil: 1) // ID dummy para testing
                }
            }
            return
        }
 
        if feedVM.feedItems.isEmpty && !feedVM.isLoading {
            Task {
                await feedVM.loadInitialFeed(idPerfil: perfil.id)
            }
        }
    }
    
    private func loadMoreIfNeeded() {
        guard let currentUser = authVM.currentUser,
              let perfil = currentUser.perfil else {
            print("DEBUG: loadMoreIfNeeded - No user or profile")
            return
        }
        
        print("DEBUG: loadMoreIfNeeded - Using profile ID: \(perfil.id)")
        Task {
            await feedVM.loadMoreFeed(idPerfil: perfil.id)
        }
    }
    
    @MainActor
    private func refreshFeed() async {
        guard let currentUser = authVM.currentUser,
              let perfil = currentUser.perfil else {
            print("DEBUG: refreshFeed - No user or profile")
            return
        }
        
        print("DEBUG: refreshFeed - Using profile ID: \(perfil.id)")
        await feedVM.refreshFeed(idPerfil: perfil.id)
    }
    
    private func handleLike(_ feedItem: FeedItem) {
        guard let currentUser = authVM.currentUser,
              let perfil = currentUser.perfil else { return }
        
        // Validar que no sea publicación propia
        guard !isOwnPost(feedItem) else {
            print("DEBUG: Cannot like own post")
            return
        }
        
        Task {
            await feedVM.toggleLike(for: feedItem, userProfileId: perfil.id)
        }
    }
    
    private func handleSave(_ feedItem: FeedItem) {
        guard let currentUser = authVM.currentUser,
              let perfil = currentUser.perfil else { return }
        
        Task {
            await feedVM.toggleSave(for: feedItem, userProfileId: perfil.id)
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        let minutes = Int(timeInterval / 60)
        let hours = Int(timeInterval / 3600)
        let days = Int(timeInterval / 86400)
        
        if days > 0 {
            return "\(days)d"
        } else if hours > 0 {
            return "\(hours)h"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "Ahora"
        }
    }
    
    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
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
                        .foregroundColor(.textPrimary)
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
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.backgroundLight.opacity(0.95))
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
                        .foregroundColor(.textPrimary)
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
    
}

// MARK: - Profile Destination View
struct ProfileDestinationView: View {
    let idPerfil: Int
    let nombreCompleto: String
    let fotoPerfil: String?
    let esEmpresa: Bool
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        destinationView
    }
    
    @ViewBuilder
    private var destinationView: some View {
        if esEmpresa {
            PerfilEmpresaView(idPerfil: idPerfil)
                .environmentObject(authVM)
        } else {
            EstudiantePerfilFreeView(idPerfil: idPerfil)
                .environmentObject(authVM)
        }
    }
    

}

// MARK: - Preview
#Preview {
    NavigationView {
        FeedView()
            .environmentObject(AuthViewModel())
    }
    .preferredColorScheme(.dark)
}
