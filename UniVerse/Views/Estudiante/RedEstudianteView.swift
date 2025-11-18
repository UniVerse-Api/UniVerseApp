// Views/Estudiante/DescubrirPerfilesView.swift
import SwiftUI

enum ProfileFilter: String, CaseIterable {
    case todos = "Todos"
    case estudiantes = "Estudiantes"
    case empresas = "Empresas"
    case universidades = "Universidades"
    case profesores = "Profesores"
}

enum ProfileType {
    case student(isPremium: Bool)
    case company(isVerified: Bool)
    case university
    case professor
}

struct Profile: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageUrl: String
    let type: ProfileType
    var isFollowing: Bool
}

struct RedEstudianteView: View {
    @State private var searchText = ""
    @State private var selectedFilter: ProfileFilter = .todos
    @State private var profiles = [
        Profile(
            name: "Maya Rodriguez",
            description: "Ciencias de la Computación @ Universidad Stanford",
            imageUrl: "person.crop.circle.fill",
            type: .student(isPremium: true),
            isFollowing: true
        ),
        Profile(
            name: "Innovate Inc.",
            description: "Industria Tecnológica - San Francisco, CA",
            imageUrl: "building.2.fill",
            type: .company(isVerified: true),
            isFollowing: false
        ),
        Profile(
            name: "Alex Chen",
            description: "Ingeniería Mecánica @ MIT",
            imageUrl: "person.crop.circle.fill",
            type: .student(isPremium: false),
            isFollowing: true
        ),
        Profile(
            name: "Universidad Redwood",
            description: "Universidad Pública de Investigación - Oakland, CA",
            imageUrl: "building.columns.fill",
            type: .university,
            isFollowing: false
        ),
        Profile(
            name: "Dra. Evelyn Reed",
            description: "Profesora de Psicología, NYU",
            imageUrl: "person.crop.circle.fill",
            type: .professor,
            isFollowing: false
        )
    ]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                
                // MARK: - Search and Filters
                searchAndFiltersSection
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(profiles.indices, id: \.self) { index in
                            ProfileCard(
                                profile: profiles[index],
                                onFollowTap: {
                                    toggleFollow(at: index)
                                }
                            )
                        }
                        
                        // Loading skeleton
                        LoadingProfileSkeleton()
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
                .background(Color.backgroundLight.opacity(0.3))
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Toggle Follow
    private func toggleFollow(at index: Int) {
        profiles[index].isFollowing.toggle()
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            Text("Descubrir")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.backgroundLight.opacity(0.95))
        .backdrop()
    }
    
    // MARK: - Search and Filters Section
    private var searchAndFiltersSection: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                
                TextField("Buscar por nombre, habilidad o universidad...", text: $searchText)
                    .font(.system(size: 14))
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.inputBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
            
            // Filter Buttons
            HStack(spacing: 8) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ProfileFilter.allCases, id: \.self) { filter in
                            FilterButtonRedEstudiante(
                                title: filter.rawValue,
                                isSelected: selectedFilter == filter
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedFilter = filter
                                }
                            }
                        }
                    }
                }
                
                Button(action: {}) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                        .frame(width: 40, height: 40)
                        .background(Color.inputBackground)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.backgroundLight)
    }
}

// MARK: - Filter Button
struct FilterButtonRedEstudiante: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? .black : .textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(isSelected ? Color.primaryOrange : Color.inputBackground)
                .cornerRadius(20)
        }
    }
}

// MARK: - Profile Card
struct ProfileCard: View {
    let profile: Profile
    let onFollowTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image with Badge
            ZStack(alignment: .topTrailing) {
                profileImage
                
                // Badge overlay
                if case .student(let isPremium) = profile.type, isPremium {
                    premiumBadge
                } else if case .company(let isVerified) = profile.type, isVerified {
                    verifiedBadge
                }
            }
            
            // Profile Info
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(profile.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    if case .company(let isVerified) = profile.type, isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.yellow)
                    }
                }
                
                Text(profile.description)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Follow Button
            Button(action: onFollowTap) {
                Text(profile.isFollowing ? "Siguiendo" : "Seguir")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(profile.isFollowing ? .textSecondary : .black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(profile.isFollowing ? Color.gray.opacity(0.2) : Color.primaryOrange)
                    .cornerRadius(20)
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private var profileImage: some View {
        switch profile.type {
        case .student(let isPremium):
            if isPremium {
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple, Color.indigo]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: profile.imageUrl)
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                }
            } else {
                Image(systemName: profile.imageUrl)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
            }
            
        case .company:
            Image(systemName: profile.imageUrl)
                .font(.system(size: 28))
                .foregroundColor(.blue)
                .frame(width: 64, height: 64)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
        case .university:
            Image(systemName: profile.imageUrl)
                .font(.system(size: 28))
                .foregroundColor(.indigo)
                .frame(width: 64, height: 64)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
        case .professor:
            Image(systemName: profile.imageUrl)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .frame(width: 64, height: 64)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
        }
    }
    
    private var premiumBadge: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 24, height: 24)
            
            Image(systemName: "diamond.fill")
                .font(.system(size: 12))
                .foregroundColor(.white)
        }
        .offset(x: 2, y: -2)
        .shadow(radius: 4)
    }
    
    private var verifiedBadge: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.yellow, Color.orange]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 20, height: 20)
            
            Image(systemName: "checkmark")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
        }
        .offset(x: 48, y: -2)
        .shadow(radius: 4)
    }
}

// MARK: - Loading Profile Skeleton
struct LoadingProfileSkeleton: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)
                    .frame(maxWidth: .infinity)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 12)
                    .frame(width: 150)
            }
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 70, height: 32)
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .opacity(isAnimating ? 0.5 : 1.0)
        .animation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        RedEstudianteView()
    }
    .preferredColorScheme(.light)
}
