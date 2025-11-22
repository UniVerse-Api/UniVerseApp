import SwiftUI

struct MiPerfilView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab: ProfileTab = .general
    @State private var selectedActivityTab: ActivityTab = .posts
    @State private var showEditProfile = false
    @State private var showSettings = false
    @State private var showAddCertification = false
    
    @State private var showExperiences = false
    
    @StateObject private var perfilService = PerfilService()
    @State private var myProfile: MyProfileResponse?
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()
            
            if isLoading {
                ProgressView()
            } else {
                VStack(spacing: 0) {
                    // MARK: - Header
                    profileHeader
                    
                    // MARK: - Main Content
                    ScrollView {
                        VStack(spacing: 0) {
                            // Profile Info
                            profileInfoSection
                            
                            // Quick Stats
                            quickStatsSection
                            
                            // Tabs
                            tabsSection
                            
                            // Tab Content
                            tabContentSection
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await loadProfile()
        }
        .sheet(isPresented: $showAddCertification) {
            if let perfil = myProfile?.perfil {
                AddCertificationView(
                    perfilId: perfil.idPerfil,
                    onCertificationAdded: {
                        Task {
                            await loadProfile()
                        }
                    }
                )
            }
        }
        .sheet(isPresented: $showExperiences) {
            if let perfil = myProfile?.perfil {
                ExperienciasView(perfilId: perfil.idPerfil)
            }
        }
    }
    
    private func loadProfile() async {
        guard let userId = authVM.currentUser?.id else { return }
        do {
            myProfile = try await perfilService.getMyProfile(userId: userId)
            isLoading = false
        } catch {
            print("Error loading profile: \(error)")
            isLoading = false
        }
    }
    
    // MARK: - Header
    private var profileHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    // Navigate back
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .foregroundColor(.textPrimary)
                        .padding(8)
                }
                
                Spacer()
                
                Text("Mi Perfil")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.textPrimary)
                            .padding(8)
                    }
                    
                    Button(action: {
                        Task {
                            try? await authVM.signOut()
                        }
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                            .padding(8)
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
    
    // MARK: - Profile Info Section
    private var profileInfoSection: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                // Profile Picture
                ZStack {
                    // Animated gradient border if premium
                    if myProfile?.suscripcion?.esPremium == true {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple, .indigo]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(width: 100, height: 100)
                            .blur(radius: 2)
                    }
                    
                    // Profile image
                    if let photoUrl = myProfile?.perfil?.fotoPerfil, let url = URL(string: photoUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 94, height: 94)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 94, height: 94)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                )
                        }
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 94, height: 94)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                    }
                    
                    // Premium badge
                    if myProfile?.suscripcion?.esPremium == true {
                        Image(systemName: "diamond.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .padding(6)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.backgroundLight, lineWidth: 2)
                            )
                            .offset(x: 35, y: -35)
                    }
                    
                    // Edit button
                    Button(action: {
                        // Edit photo
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.primaryOrange)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.backgroundLight, lineWidth: 2)
                            )
                    }
                    .offset(x: 35, y: 35)
                }
                
                // User Info
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(myProfile?.perfil?.nombreCompleto ?? "Usuario")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        let isPremium = myProfile?.suscripcion?.esPremium ?? false
                        Text("ESTUDIANTE")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(isPremium ? .primaryOrange : .blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background((isPremium ? Color.primaryOrange : Color.blue).opacity(0.15))
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke((isPremium ? Color.primaryOrange : Color.blue).opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    if let carrera = myProfile?.perfil?.carrera {
                        Text(carrera)
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                    
                    if let uni = myProfile?.perfil?.universidadActual {
                        Text("@ \(uni)")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary)
                        
                        Text("\(myProfile?.perfil?.ubicacion ?? ""), \(myProfile?.perfil?.pais ?? "")")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, 2)
                }
                
                Spacer()
            }
            
            // Action Buttons
            HStack(spacing: 12) {
                Button(action: {
                    showEditProfile = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                        Text("Editar Perfil")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.primaryOrange)
                    .cornerRadius(8)
                }
                
                Button(action: {
                    // Share profile
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14))
                        .foregroundColor(.textPrimary)
                        .padding(10)
                        .background(Color.cardBackground)
                        .cornerRadius(8)
                }
            }
        }

        .padding(16)
        .background(Color.backgroundLight)
    }
    
    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        HStack(spacing: 0) {
            StatItem(value: "\(myProfile?.estadisticas?.seguidores ?? 0)", label: "Seguidores")
            StatItem(value: "\(myProfile?.estadisticas?.siguiendo ?? 0)", label: "Siguiendo")
            StatItem(value: "\(myProfile?.estadisticas?.publicaciones ?? 0)", label: "Publicaciones")
            StatItem(value: "\(myProfile?.estadisticas?.guardados ?? 0)", label: "Guardados")
        }
        .padding(.vertical, 16)
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.backgroundLight)
    }
    
    // MARK: - Tabs Section
    private var tabsSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TabButtonMiPerfil(
                    title: "General",
                    isSelected: selectedTab == .general,
                    action: { selectedTab = .general }
                )
                
                TabButtonMiPerfil(
                    title: "Actividad",
                    isSelected: selectedTab == .activity,
                    action: { selectedTab = .activity }
                )
                
                TabButtonMiPerfil(
                    title: "Plan",
                    isSelected: selectedTab == .plan,
                    action: { selectedTab = .plan }
                )
            }
            .background(Color.backgroundLight)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
    }
    
    // MARK: - Tab Content Section
    private var tabContentSection: some View {
        VStack(spacing: 16) {
            switch selectedTab {
            case .general:
                generalTabContent
            case .activity:
                activityTabContent
            case .plan:
                planTabContent
            }
        }

        .padding(16)
        .background(Color.backgroundLight)
    }
    
    // MARK: - General Tab Content
    private var generalTabContent: some View {
        VStack(spacing: 16) {
            // Quick Actions
            quickActionsCard
            
            // My Documents
            myDocumentsCard
            
            // Profile Completion
            profileCompletionCard
            
            // Recent Activity
            recentActivityCard
        }
    }
    
    private var quickActionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Acciones Rápidas")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                // Removed CV upload button
                QuickActionButton(icon: "checkmark.seal.fill", title: "Certificación", color: .green, action: {
                    showAddCertification = true
                })
                QuickActionButton(icon: "briefcase.fill", title: "Experiencia", color: .purple, action: {
                    showExperiences = true
                })
                QuickActionButton(icon: "flask.fill", title: "Investigación", color: .orange, action: {})
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
    
    private var myDocumentsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.primaryOrange)
                    
                    
                    Text("Mis Certificaciones")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                Button(action: {
                    showAddCertification = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 12))
                        Text("Agregar")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
            
            VStack(spacing: 12) {
                if let certs = myProfile?.certificaciones, !certs.isEmpty {
                    ForEach(certs) { cert in
                        DocumentRow(
                            icon: "checkmark.seal.fill",
                            iconColor: .blue,
                            title: cert.titulo,
                            subtitle: "\(cert.institucion) • \(cert.fecha)",
                            backgroundColor: Color(hex: "0D1117").opacity(0.05)
                        )
                    }
                } else {
                    Text("No tienes certificaciones registradas.")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                        .padding(.vertical, 8)
                }
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
    
    private var profileCompletionCard: some View {
        let skillsCount = myProfile?.progreso?.habilidadesCount ?? 0
        let certsCount = myProfile?.progreso?.certificacionesCount ?? 0
        let langsCount = myProfile?.progreso?.idiomasCount ?? 0
        
        let skillsTarget = 3
        let certsTarget = 1
        let langsTarget = 1
        
        let skillsProgress = min(skillsCount, skillsTarget)
        let certsProgress = min(certsCount, certsTarget)
        let langsProgress = min(langsCount, langsTarget)
        
        let totalProgress = Double(skillsProgress + certsProgress + langsProgress) / Double(skillsTarget + certsTarget + langsTarget)
        let percentage = Int(totalProgress * 100)
        
        return Group {
            if percentage < 100 {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Completar Perfil")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Text("\(percentage)%")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primaryOrange)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.primaryOrange)
                                .frame(width: geometry.size.width * CGFloat(totalProgress), height: 8)
                        }
                    }
                    .frame(height: 8)
                    
                    Text("¡Casi listo! Completa tu perfil para aumentar tus oportunidades.")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                    
                    VStack(spacing: 8) {
                        if skillsCount < skillsTarget {
                            CompletionTaskRow(task: "Agregar \(skillsTarget - skillsCount) habilidades más")
                        }
                        if certsCount < certsTarget {
                            CompletionTaskRow(task: "Agregar una certificación")
                        }
                        if langsCount < langsTarget {
                            CompletionTaskRow(task: "Agregar un idioma")
                        }
                    }
                }
                .padding(16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.primaryOrange.opacity(0.1),
                            Color.orange.opacity(0.05)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
                )
            } else {
                EmptyView()
            }
        }
    }
    
    private var recentActivityCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Actividad Reciente")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: 12) {
                if let activities = myProfile?.actividadReciente, !activities.isEmpty {
                    ForEach(activities) { activity in
                        ActivityItem(
                            icon: "doc.text.fill", // Assuming all are posts for now as per RPC
                            iconColor: .blue,
                            text: "Publicaste: \(activity.titulo)",
                            time: activity.fecha // You might want to format this date
                        )
                    }
                } else {
                    Text("No hay actividad reciente.")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
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
    
    // MARK: - Activity Tab Content
    private var activityTabContent: some View {
        VStack(spacing: 16) {
            // Activity Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ActivityTabButton(
                        title: "Publicaciones",
                        isSelected: selectedActivityTab == .posts,
                        action: { selectedActivityTab = .posts }
                    )
                    
                    ActivityTabButton(
                        title: "Guardados",
                        isSelected: selectedActivityTab == .saved,
                        action: { selectedActivityTab = .saved }
                    )
                    
                    ActivityTabButton(
                        title: "Siguiendo",
                        isSelected: selectedActivityTab == .following,
                        action: { selectedActivityTab = .following }
                    )
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, -16)
            
            // Activity Content
            switch selectedActivityTab {
            case .posts:
                postsContent
            case .saved:
                savedContent
            case .following:
                followingContent
            case .followers:
                followersContent
            }
        }
    }
    
    private var postsContent: some View {
        PostCard(
            authorName: "Alexandra Chen",
            timeAgo: "Hace 2 días",
            content: "Emocionada de compartir que completé mi certificación en AWS Cloud! 💪 Gracias al equipo de la universidad por el apoyo.",
            likes: 23,
            comments: 5
        )
    }
    
    private var savedContent: some View {
        SavedPostCard(
            authorName: "Dr. Evelyn Reed",
            timeAgo: "Guardado hace 1 día",
            content: "Nuevo artículo sobre recuperación económica post-pandemia..."
        )
    }
    
    private var followingContent: some View {
        UserCard(
            name: "Alex Johnson",
            subtitle: "Candidato a PhD @ Stanford",
            buttonTitle: "Siguiendo",
            buttonStyle: .secondary
        )
    }
    
    private var followersContent: some View {
        UserCard(
            name: "Maria Rodriguez",
            subtitle: "Estudiante de Ingeniería",
            buttonTitle: "Seguir de vuelta",
            buttonStyle: .primary
        )
    }
    
    // MARK: - Plan Tab Content
    private var planTabContent: some View {
        VStack(spacing: 16) {
            // Current Plan Card
            currentPlanCard
            
            // Plan Usage Card
            planUsageCard
            
            // Benefits Card
            benefitsCard
        }
    }
    
    private var currentPlanCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Plan Premium")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Plan actual")
                        .font(.system(size: 13))
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("ACTIVO")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(20)
            }
            
            HStack(spacing: 12) {
                // Removed CV stats
                PlanStatBox(value: "5", label: "Pub. por día")
            }
            
            VStack(spacing: 8) {
                PlanFeature(text: "Prioridad alta en búsquedas")
                PlanFeature(text: "Sin anuncios")
                PlanFeature(text: "Análisis avanzado de perfil")
            }
            
            Rectangle()
                .fill(Color.blue.opacity(0.3))
                .frame(height: 1)
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Próximo pago: 15 Nov 2024")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                    
                    Text("$9.99/mes")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("Gestionar Plan")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.indigo.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.3), lineWidth: 2)
        )
    }
    
    private var planUsageCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Uso del Plan")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 16) {
                UsageBar(label: "Publicaciones hoy", current: 2, total: 5, color: .primaryOrange)
                // Removed CV usage bar
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
    
    private var benefitsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Beneficios Premium")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                BenefitRow(
                    icon: "checkmark.seal.fill",
                    title: "Perfil Verificado",
                    subtitle: "Badge premium en tu perfil",
                    color: .green
                )
                
                BenefitRow(
                    icon: "chart.bar.fill",
                    title: "Análisis Detallado",
                    subtitle: "Estadísticas de vistas de perfil",
                    color: .blue
                )
                
                BenefitRow(
                    icon: "star.fill",
                    title: "Prioridad en Búsquedas",
                    subtitle: "Aparece primero para reclutadores",
                    color: .purple
                )
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
}

// MARK: - Profile Tab Enum
enum ProfileTab {
    case general, activity, plan
}

// MARK: - Activity Tab Enum
enum ActivityTab {
    case posts, saved, following, followers
}

// MARK: - Supporting Components

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TabButtonMiPerfil: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                
                Rectangle()
                    .fill(isSelected ? Color.primaryOrange : Color.clear)
                    .frame(height: 3)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            .padding(12)
            .background(Color(hex: "0D1117").opacity(0.05))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "0D1117").opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct DocumentRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    var backgroundColor: Color = Color.cardBackground
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .rotationEffect(.degrees(90))
            }
        }
        .padding(12)
        .background(backgroundColor)
        .cornerRadius(8)
    }
}

struct CompletionTaskRow: View {
    let task: String
    
    var body: some View {
        HStack {
            Text("• \(task)")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Button(action: {}) {
                Text("Agregar")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primaryOrange)
            }
        }
    }
}

struct ActivityItem: View {
    let icon: String
    let iconColor: Color
    let text: String
    let time: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.system(size: 13))
                    .foregroundColor(.textPrimary)
                
                Text(time)
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
    }
}

struct ActivityTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(isSelected ? .black : .textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.primaryOrange : Color.cardBackground)
                .cornerRadius(8)
        }
    }
}

struct PostCard: View {
    let authorName: String
    let timeAgo: String
    let content: String
    let likes: Int
    let comments: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(authorName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(timeAgo)
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
            }
            
            Text(content)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
            
            HStack(spacing: 16) {
                Text("❤️ \(likes) Me gusta")
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
                
                Text("💬 \(comments) Comentarios")
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
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
}

struct SavedPostCard: View {
    let authorName: String
    let timeAgo: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(authorName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(timeAgo)
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.primaryOrange)
                }
            }
            
            Text(content)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
}

enum UserCardButtonStyle {
    case primary, secondary
}

struct UserCard: View {
    let name: String
    let subtitle: String
    let buttonTitle: String
    let buttonStyle: UserCardButtonStyle
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.gray)
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Text(buttonTitle)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(buttonStyle == .primary ? .black : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(buttonStyle == .primary ? Color.primaryOrange : Color.cardBackground)
                    .cornerRadius(20)
            }
        }
        .padding(12)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
}

struct PlanStatBox: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

struct PlanFeature: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(.green)
            
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

struct UsageBar: View {
    let label: String
    let current: Int
    let total: Int?
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                if let total = total {
                    Text("\(current)/\(total)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                } else {
                    Text("\(current)/∞")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(
                            width: total != nil ? geometry.size.width * CGFloat(current) / CGFloat(total!) : geometry.size.width,
                            height: 8
                        )
                }
            }
            .frame(height: 8)
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    color.opacity(0.1),
                    color.opacity(0.05)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        MiPerfilView()
            .environmentObject(AuthViewModel())
    }
    .preferredColorScheme(.dark)
}
