// Views/NetworkView.swift
import SwiftUI

struct NetworkView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var viewModel = NetworkViewModel()

    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerSection

                // Search Bar
                searchSection

                // Filters
                filterSection

                // Content
                contentSection
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadInitialData()
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    // Navigate back - this would be handled by navigation
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.textPrimary)
                }

                Spacer()

                Text("Red")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)

                Spacer()

                Button(action: {
                    viewModel.refresh()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.primaryOrange)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.cardBackground.opacity(0.95))
    }

    // MARK: - Search Section
    private var searchSection: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 16))

                TextField("Buscar personas...", text: $viewModel.searchText)
                    .foregroundColor(.textPrimary)
                    .font(.system(size: 16))

                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textSecondary)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.inputBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
    }

    // MARK: - Filter Section
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TipoFiltro.allCases) { filtro in
                    NetworkFilterButton(
                        title: filtro.displayName,
                        isSelected: viewModel.selectedFilter == filtro,
                        action: {
                            viewModel.selectedFilter = filtro
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color.cardBackground)
        .overlay(
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1),
            alignment: .bottom
        )
    }

    // MARK: - Content Section
    private var contentSection: some View {
        ZStack {
            if viewModel.isLoading && viewModel.perfiles.isEmpty {
                loadingView
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else if viewModel.perfiles.isEmpty {
                emptyView
            } else {
                profilesList
            }
        }
    }

    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ForEach(0..<5, id: \.self) { _ in
                ProfileCardSkeleton()
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red)

            Text("Error al cargar perfiles")
                .font(.headline)
                .foregroundColor(.textPrimary)

            Text(message)
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button("Reintentar") {
                viewModel.clearError()
                loadInitialData()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 8)
        }
        .padding(.vertical, 40)
    }

    // MARK: - Empty View
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2")
                .font(.system(size: 48))
                .foregroundColor(.textSecondary)

            Text(viewModel.searchText.isEmpty ? "No hay perfiles disponibles" : "No se encontraron resultados")
                .font(.headline)
                .foregroundColor(.textPrimary)

            Text(viewModel.searchText.isEmpty ?
                 "Sé el primero en conectarte con otros usuarios" :
                 "Intenta con otros términos de búsqueda")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding(.vertical, 40)
    }

    // MARK: - Profiles List
    private var profilesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.perfiles) { perfil in
                    ProfileCardView(
                        perfil: perfil,
                        onFollowToggle: {
                            Task {
                                await viewModel.toggleFollow(for: perfil)
                            }
                        }
                    )
                    .onAppear {
                        // Load more when approaching the end
                        if perfil.id == viewModel.perfiles.last?.id {
                            viewModel.loadMoreData()
                        }
                    }
                }

                // Loading more indicator
                if viewModel.isLoadingMore {
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
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .refreshable {
            viewModel.refresh()
        }
    }

    // MARK: - Helper Methods

    private func loadInitialData() {
        let userProfileId = authVM.currentUser?.perfil?.id
        viewModel.loadInitialData(userProfileId: userProfileId)
    }

    private func navigateToProfile(_ perfil: PerfilRed) {
        // This will be handled by NavigationLink in ProfileCardView
        // The ProfileCardView should be wrapped in NavigationLink
    }
}

// MARK: - Supporting Views

struct NetworkFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    Color.primaryOrange :
                    Color.inputBackground
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.primaryOrange : Color.borderColor, lineWidth: 1)
                )
        }
    }
}

struct ProfileCardSkeleton: View {
    var body: some View {
        HStack(spacing: 16) {
            // Avatar skeleton
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 8) {
                // Name skeleton
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 16)
                    .cornerRadius(4)

                // Bio skeleton
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 12)
                    .cornerRadius(4)

                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 150, height: 12)
                    .cornerRadius(4)

                Spacer()

                // Button skeleton
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 28)
                    .cornerRadius(14)
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .redacted(reason: .placeholder)
    }
}

#Preview {
    NavigationView {
        NetworkView()
            .environmentObject(AuthViewModel())
    }
}
