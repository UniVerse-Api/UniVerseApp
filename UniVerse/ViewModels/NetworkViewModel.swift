// ViewModels/NetworkViewModel.swift
import SwiftUI
import Combine

class NetworkViewModel: ObservableObject {
    @Published var perfiles: [PerfilRed] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var searchText = ""
    @Published var selectedFilter: TipoFiltro = .todos
    @Published var errorMessage: String?
    @Published var hasMoreData = true

    private let networkService = NetworkService.shared
    private var currentOffset = 0
    private let pageSize = 50
    private var currentUserProfileId: Int?

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSearchDebounce()
    }

    // MARK: - Setup

    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.performSearch(query: searchText)
            }
            .store(in: &cancellables)

        $selectedFilter
            .sink { [weak self] _ in
                self?.performFilterChange()
            }
            .store(in: &cancellables)
    }

    // MARK: - Data Loading

    func loadInitialData(userProfileId: Int?) {
        currentUserProfileId = userProfileId
        currentOffset = 0
        hasMoreData = true
        perfiles = []
        errorMessage = nil

        Task {
            await loadPerfiles(refresh: true)
        }
    }

    func loadMoreData() {
        guard !isLoading && !isLoadingMore && hasMoreData else { return }

        Task {
            await loadPerfiles(refresh: false)
        }
    }

    private func loadPerfiles(refresh: Bool) async {
        if refresh {
            isLoading = true
        } else {
            isLoadingMore = true
        }

        do {
            let newPerfiles = try await networkService.getPerfilesRed(
                idPerfilVisitante: currentUserProfileId,
                tipoFiltro: selectedFilter,
                busqueda: searchText.isEmpty ? nil : searchText,
                limit: pageSize,
                offset: refresh ? 0 : currentOffset
            )

            await MainActor.run {
                if refresh {
                    perfiles = newPerfiles
                    currentOffset = newPerfiles.count
                } else {
                    perfiles.append(contentsOf: newPerfiles)
                    currentOffset += newPerfiles.count
                }

                hasMoreData = newPerfiles.count == pageSize
                errorMessage = nil
            }

        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                if refresh {
                    perfiles = []
                }
            }
        }

        await MainActor.run {
            isLoading = false
            isLoadingMore = false
        }
    }

    // MARK: - Search and Filter

    private func performSearch(query: String) {
        currentOffset = 0
        hasMoreData = true

        Task {
            await loadPerfiles(refresh: true)
        }
    }

    private func performFilterChange() {
        currentOffset = 0
        hasMoreData = true

        Task {
            await loadPerfiles(refresh: true)
        }
    }

    // MARK: - Follow/Unfollow

    func toggleFollow(for perfil: PerfilRed) async {
        guard let userProfileId = currentUserProfileId else { return }

        do {
            let newFollowState = try await networkService.toggleSeguir(
                idSeguidor: userProfileId,
                idSeguido: perfil.id
            )

            // Update local state
            if let index = perfiles.firstIndex(where: { $0.id == perfil.id }) {
                perfiles[index].sigoAEstePerfil = newFollowState

                // Update follower count
                if newFollowState {
                    perfiles[index].seguidoresCount += 1
                } else {
                    perfiles[index].seguidoresCount = max(0, perfiles[index].seguidoresCount - 1)
                }
            }

        } catch {
            // Handle error - could show alert or revert UI
            print("Error toggling follow: \(error.localizedDescription)")
        }
    }

    // MARK: - Helper Methods

    func refresh() {
        currentOffset = 0
        hasMoreData = true

        Task {
            await loadPerfiles(refresh: true)
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
