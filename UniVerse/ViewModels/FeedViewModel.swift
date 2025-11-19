// ViewModels/FeedViewModel.swift
import Foundation
import SwiftUI

@MainActor
class FeedViewModel: ObservableObject {
    @Published var feedItems: [FeedItem] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var isRefreshing = false
    @Published var errorMessage: String?
    @Published var hasMoreItems = true
    
    private let feedService = FeedService()
    private let pageSize = 20
    
    // MARK: - Public Methods
    
    /// Carga el feed inicial
    /// - Parameter idPerfil: ID del perfil del usuario actual
    func loadInitialFeed(idPerfil: Int) async {
        print("DEBUG FeedViewModel: loadInitialFeed called with idPerfil: \(idPerfil)")
        guard !isLoading else {
            print("DEBUG FeedViewModel: Already loading, skipping")
            return
        }
        
        isLoading = true
        errorMessage = nil
        print("DEBUG FeedViewModel: Starting feed load...")
        
        do {
            let items = try await feedService.getInitialFeed(idPerfil: idPerfil)
            print("DEBUG FeedViewModel: Received \(items.count) items")
            feedItems = items
            hasMoreItems = items.count >= pageSize
        } catch {
            print("DEBUG FeedViewModel: Error loading feed: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            feedItems = []
        }
        
        isLoading = false
        print("DEBUG FeedViewModel: Feed load completed, isLoading: \(isLoading)")
    }
    
    /// Carga más elementos del feed (paginación infinita)
    /// - Parameter idPerfil: ID del perfil del usuario actual
    func loadMoreFeed(idPerfil: Int) async {
        guard !isLoadingMore && hasMoreItems && !isLoading else { return }
        
        isLoadingMore = true
        
        do {
            let newItems = try await feedService.loadMoreFeed(
                idPerfil: idPerfil,
                currentCount: feedItems.count
            )
            
            if newItems.count < pageSize {
                hasMoreItems = false
            }
            
            // Evitar duplicados
            let uniqueNewItems = newItems.filter { newItem in
                !feedItems.contains { $0.uniqueId == newItem.uniqueId }
            }
            
            feedItems.append(contentsOf: uniqueNewItems)
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoadingMore = false
    }
    
    /// Refresca el feed completo (pull to refresh)
    /// - Parameter idPerfil: ID del perfil del usuario actual
    func refreshFeed(idPerfil: Int) async {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        errorMessage = nil
        
        do {
            let items = try await feedService.refreshFeed(idPerfil: idPerfil)
            feedItems = items
            hasMoreItems = items.count >= pageSize
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isRefreshing = false
    }
    
    /// Da like a una publicación y actualiza el estado local
    /// - Parameters:
    ///   - feedItem: Item del feed al que dar like
    ///   - idPerfil: ID del perfil del usuario actual
    func toggleLike(for feedItem: FeedItem, userProfileId: Int) async {
        guard feedItem.esPublicacion else { return }
        
        // Actualización optimista de la UI
        updateLikeStateOptimistically(for: feedItem.uniqueId)
        
        do {
            try await feedService.likePublicacion(
                idPublicacion: feedItem.id,
                idPerfil: userProfileId
            )
        } catch {
            // Revertir el cambio si falla
            updateLikeStateOptimistically(for: feedItem.uniqueId)
            errorMessage = "Error al dar like: \(error.localizedDescription)"
        }
    }
    
    /// Guarda o quita de guardados una publicación
    /// - Parameters:
    ///   - feedItem: Item del feed a guardar
    ///   - idPerfil: ID del perfil del usuario actual
    func toggleSave(for feedItem: FeedItem, userProfileId: Int) async {
        guard feedItem.esPublicacion else { return }
        
        // Actualización optimista de la UI
        updateSaveStateOptimistically(for: feedItem.uniqueId)
        
        do {
            try await feedService.savePublicacion(
                idPublicacion: feedItem.id,
                idPerfil: userProfileId
            )
        } catch {
            // Revertir el cambio si falla
            updateSaveStateOptimistically(for: feedItem.uniqueId)
            errorMessage = "Error al guardar: \(error.localizedDescription)"
        }
    }
    
    /// Incrementa las vistas de un anuncio
    /// - Parameter feedItem: Item del feed (anuncio) a marcar como visto
    func markAnuncioAsViewed(_ feedItem: FeedItem) async {
        guard feedItem.esAnuncio else { return }
        
        do {
            try await feedService.incrementVistaAnuncio(idAnuncio: feedItem.id)
            // Actualizar contador local si es necesario
            updateVistaCounterOptimistically(for: feedItem.uniqueId)
        } catch {
            // Error silencioso para las vistas, no interrumpir UX
            print("Error al incrementar vista: \(error.localizedDescription)")
        }
    }
    
    /// Limpia el mensaje de error
    func clearError() {
        errorMessage = nil
    }
    
    /// Obtiene un item específico por su ID único
    /// - Parameter uniqueId: ID único del item
    /// - Returns: FeedItem si existe
    func getFeedItem(by uniqueId: String) -> FeedItem? {
        return feedItems.first { $0.uniqueId == uniqueId }
    }
    
    // MARK: - Private Methods
    
    /// Actualiza el estado de like de un item de forma optimista
    /// - Parameter uniqueId: ID único del item
    private func updateLikeStateOptimistically(for uniqueId: String) {
        if let index = feedItems.firstIndex(where: { $0.uniqueId == uniqueId }) {
            // Por simplicidad, solo mostraremos feedback visual temporal
            // En una implementación real, necesitarías modificar el modelo para incluir estado local
            print("Like toggled for item: \(uniqueId)")
        }
    }
    
    /// Actualiza el estado de guardado de un item de forma optimista
    /// - Parameter uniqueId: ID único del item
    private func updateSaveStateOptimistically(for uniqueId: String) {
        if let index = feedItems.firstIndex(where: { $0.uniqueId == uniqueId }) {
            // Por simplicidad, solo mostraremos feedback visual temporal
            print("Save toggled for item: \(uniqueId)")
        }
    }
    
    /// Actualiza el contador de vistas de forma optimista
    /// - Parameter uniqueId: ID único del item
    private func updateVistaCounterOptimistically(for uniqueId: String) {
        if let index = feedItems.firstIndex(where: { $0.uniqueId == uniqueId }) {
            // Por simplicidad, solo mostraremos feedback visual temporal
            print("View registered for item: \(uniqueId)")
        }
    }
    
    // MARK: - Computed Properties
    
    /// Indica si hay alguna operación en progreso
    var isAnyLoading: Bool {
        isLoading || isLoadingMore || isRefreshing
    }
    
    /// Indica si el feed está vacío
    var isEmpty: Bool {
        feedItems.isEmpty && !isLoading
    }
    
    /// Obtiene solo las publicaciones del feed
    var publicaciones: [FeedItem] {
        feedItems.filter { $0.esPublicacion }
    }
    
    /// Obtiene solo los anuncios del feed
    var anuncios: [FeedItem] {
        feedItems.filter { $0.esAnuncio }
    }
}