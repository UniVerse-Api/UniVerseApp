import SwiftUI

struct MiPerfilView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab: ProfileTab = .general
    @State private var selectedActivityTab: ActivityTab = .posts
    @State private var showEditProfile = false
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()
            
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
        .navigationBarHidden(true)
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
                        .foregroundColor(.white)
                        .padding(8)
                }
                
                Spacer()
                
                Text("Mi Perfil")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
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
        .background(Color.backgroundDark.opacity(0.8))
        .backdrop()
    }
    
    // MARK: - Profile Info Section
    private var profileInfoSection: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                // Profile Picture
                ZStack {
                    // Animated gradient border
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
                    
                    // Profile image
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 94, height: 94)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        )
                    
                    // Premium badge
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
                                .stroke(Color.backgroundDark, lineWidth: 2)
                        )
                        .offset(x: 35, y: -35)
                    
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
                                    .stroke(Color.backgroundDark, lineWidth: 2)
                            )
                    }
                    .offset(x: 35, y: 35)
                }
                
                // User Info
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text("Alexandra Chen")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("ESTUDIANTE PREMIUM")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.primaryOrange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.primaryOrange.opacity(0.15))
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    Text("Ingeniería en Ciencias de la Computación")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                    
                    Text("@ Universidad Estatal")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary)
                        
                        Text("San Francisco, CA")
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
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.cardBackground)
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.backgroundDark)
    }
    
    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        HStack(spacing: 0) {
            StatItem(value: "532", label: "Seguidores")
            StatItem(value: "189", label: "Siguiendo")
            StatItem(value: "24", label: "Publicaciones")
            StatItem(value: "12", label: "Guardados")
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.backgroundDark)
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
            .background(Color.backgroundDark)
            
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
        .background(Color(red: 13/255, green: 15/255, blue: 20/255))
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
                    .foregroundColor(.white)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                QuickActionButton(icon: "doc.text", title: "Subir CV", color: .blue)
                QuickActionButton(icon: "checkmark.seal.fill", title: "Certificación", color: .green)
                QuickActionButton(icon: "briefcase.fill", title: "Experiencia", color: .purple)
                QuickActionButton(icon: "flask.fill", title: "Investigación", color: .orange)
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
                    
                    Text("Mis Documentos")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {}) {
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
                DocumentRow(
                    icon: "doc.fill",
                    iconColor: .red,
                    title: "CV_Alexandra_Chen_2024.pdf",
                    subtitle: "Principal • Actualizado hace 2 días"
                )
                
                DocumentRow(
                    icon: "checkmark.seal.fill",
                    iconColor: .blue,
                    title: "AWS Cloud Practitioner",
                    subtitle: "Certificación • 2024"
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
    
    private var profileCompletionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Completar Perfil")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("85%")
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
                        .frame(width: geometry.size.width * 0.85, height: 8)
                }
            }
            .frame(height: 8)
            
            Text("¡Casi listo! Completa tu perfil para aumentar tus oportunidades.")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 8) {
                CompletionTaskRow(task: "Agregar 2 habilidades más")
                CompletionTaskRow(task: "Subir foto de portada")
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
    }
    
    private var recentActivityCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Actividad Reciente")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                ActivityItem(
                    icon: "briefcase.fill",
                    iconColor: .green,
                    text: "Aplicaste a Desarrollador Full Stack en Innovate Inc.",
                    time: "Hace 2 días"
                )
                
                ActivityItem(
                    icon: "doc.text.fill",
                    iconColor: .blue,
                    text: "Actualizaste tu CV",
                    time: "Hace 2 días"
                )
                
                ActivityItem(
                    icon: "person.2.fill",
                    iconColor: .purple,
                    text: "Nuevos seguidores: +3",
                    time: "Hace 3 días"
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
                    
                    ActivityTabButton(
                        title: "Seguidores",
                        isSelected: selectedActivityTab == .followers,
                        action: { selectedActivityTab = .followers }
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
                PlanStatBox(value: "∞", label: "CVs subidos")
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
                        .foregroundColor(.white)
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
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                UsageBar(label: "Publicaciones hoy", current: 2, total: 5, color: .primaryOrange)
                UsageBar(label: "CVs subidos", current: 3, total: nil, color: .green)
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
                .foregroundColor(.white)
            
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
                .foregroundColor(.white)
            
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
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(12)
            .background(Color(red: 20/255, green: 22/255, blue: 28/255))
            .cornerRadius(8)
        }
    }
}

struct DocumentRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    
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
                    .foregroundColor(.white)
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
        .background(Color(red: 20/255, green: 22/255, blue: 28/255))
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
                    .foregroundColor(.white)
                
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
