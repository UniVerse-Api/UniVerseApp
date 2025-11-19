import SwiftUI

struct EstudiantePerfilFreeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab = "General"
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Main Content
                ScrollView {
                    VStack(spacing: 0) {
                        // Profile Header Section
                        profileHeaderSection
                        
                        // Stats Section
                        statsSection
                        
                        // Tabs Section
                        tabsSection
                        
                        // Content Sections
                        VStack(spacing: 16) {
                            aboutSection
                            researchSection
                            experienceSection
                            educationSection
                            documentsSection
                            skillsSection
                            languagesSection
                            recommendationsSection
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100) // Space for bottom nav
                        .background(Color(.systemGray6))
                    }
                }
                .navigationBarHidden(true)
                
                // Bottom Navigation
                bottomNavigation
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Header
    private var headerSection: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text("Perfil")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Color(UIColor.systemBackground)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        )
    }
    
    // MARK: - Profile Header
    private var profileHeaderSection: some View {
        VStack(spacing: 16) {
            // Header Navigation
            HStack {
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text("Perfil")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Profile Info
            HStack(alignment: .top, spacing: 16) {
                // Profile Image
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuA9M9umYmFipJHj78VBSMq-mTfMSS709z1RUYU_dsyjYYAPKGd99RUxRCyjbI2EJ-9zAhvvfxe1xrM7znL5SsxkOiEeFkeNGbWWSdN5AyXHF68y0Ex0OxXmmTT13OXkM4UICZnIjCkJ2C8EDxYH7m1IIQ55Z9cAeFW-SPFrfHiaYBuzhO20EpOzEA7SiMZMQpLAagbOoH3MYjc57tvpp2RF_ka4-uHf5zUzDXaEPSehmG8QnABwML0p_ry-bJV-GL_qLJMaZ8OfuHg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color(.systemGray4))
                }
                .frame(width: 96, height: 96)
                .clipShape(Circle())
                
                // Profile Details
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("Alexandra Chen")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("🇸🇻")
                            .font(.title3)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("ESTUDIANTE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.orange.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        
                        Spacer()
                    }
                    
                    Text("Ingeniería en Ciencias de la Computación")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("@ Universidad Estatal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("San Francisco, CA")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            // Action Buttons
            HStack(spacing: 12) {
                Button("Seguir") {}
                    .buttonStyle(PrimaryButtonStyle())
                
                Button("Sitio web") {}
                    .buttonStyle(SecondaryButtonStyle())
                
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .frame(width: 40, height: 40)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)
        }
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: - Stats
    private var statsSection: some View {
        HStack(spacing: 0) {
            StatView(number: "532", label: "Seguidores")
            StatView(number: "189", label: "Siguiendo")
            StatView(number: "24", label: "Publicaciones")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: - Tabs
    private var tabsSection: some View {
        HStack(spacing: 0) {
            TabButton(title: "General", isSelected: selectedTab == "General") {
                selectedTab = "General"
            }
            
            TabButton(title: "Publicaciones", isSelected: selectedTab == "Publicaciones") {
                selectedTab = "Publicaciones"
            }
        }
        .padding(.horizontal, 16)
        .background(Color(UIColor.systemBackground))
        .overlay(
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1),
            alignment: .bottom
        )
        .sticky(at: 72)
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        ProfileSectionCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Sobre mí")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Estudiante apasionada por el desarrollo de software escalable y con sólida base en estructuras de datos y algoritmos. Busco aplicar mis conocimientos académicos a desafíos del mundo real.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
        }
    }
    
    // MARK: - Research Section
    private var researchSection: some View {
        ProfileSectionCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "flask")
                            .foregroundColor(.orange)
                        Text("Investigaciones")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    Text("2")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.orange.opacity(0.1))
                        )
                }
                
                VStack(spacing: 16) {
                    ResearchItem(
                        icon: "brain.head.profile",
                        title: "Machine Learning para Análisis Predictivo",
                        role: "Asistente de Investigación",
                        period: "Sep 2022 - May 2023"
                    )
                    
                    ResearchItem(
                        icon: "tree",
                        title: "Algoritmos de Computación Cuántica",
                        role: "Colaborador del Proyecto",
                        period: "Ene 2022 - May 2022"
                    )
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.3), lineWidth: 2)
        )
    }
    
    // MARK: - Experience Section
    private var experienceSection: some View {
        ProfileSectionCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "briefcase")
                        .foregroundColor(.orange)
                    Text("Experiencia & Pasantías")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 16) {
                    ExperienceItem(
                        icon: "chevron.left.forwardslash.chevron.right",
                        title: "Pasante de Ingeniería de Software",
                        company: "Tech Solutions Inc.",
                        period: "Jun 2023 - Ago 2023 · San Francisco, CA",
                        isVerified: true
                    )
                    
                    ExperienceItem(
                        icon: "flask",
                        title: "Asistente de Investigación",
                        company: "Lab de IA - Universidad Estatal",
                        period: "Sep 2022 - May 2023 · University City, CA",
                        isVerified: false
                    )
                }
            }
        }
    }
    
    // MARK: - Education Section
    private var educationSection: some View {
        ProfileSectionCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "graduationcap")
                        .foregroundColor(.orange)
                    Text("Formación Académica")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: "graduationcap")
                        .font(.title2)
                        .foregroundColor(.orange)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Universidad Estatal")
                            .font(.body)
                            .fontWeight(.bold)
                        
                        Text("Licenciatura en Ciencias de la Computación")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("2021 - 2025 (Esperado)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("Promedio: 3.8/4.0")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.orange.opacity(0.1))
                                )
                            
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                }
            }
        }
    }
    
    // MARK: - Documents Section
    private var documentsSection: some View {
        ProfileSectionCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "doc.text")
                        .foregroundColor(.orange)
                    Text("Documentos & Certificaciones")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 12) {
                    DocumentItem(
                        icon: "doc.richtext",
                        iconColor: .red,
                        title: "CV_Alexandra_Chen_2024.pdf",
                        subtitle: "Actualizado hace 2 días",
                        action: "arrow.down.circle"
                    )
                    
                    DocumentItem(
                        icon: "checkmark.seal",
                        iconColor: .blue,
                        title: "AWS Cloud Practitioner",
                        subtitle: "Certificación · 2024",
                        action: "arrow.up.right.square"
                    )
                }
            }
        }
    }
    
    // MARK: - Skills Section
    private var skillsSection: some View {
        ProfileSectionCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "curlybraces")
                        .foregroundColor(.orange)
                    Text("Habilidades Técnicas")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(["Python", "JavaScript", "React", "Node.js", "SQL", "Git"], id: \.self) { skill in
                        SkillTag(text: skill)
                    }
                }
            }
        }
    }
    
    // MARK: - Languages Section
    private var languagesSection: some View {
        ProfileSectionCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "globe")
                        .foregroundColor(.orange)
                    Text("Idiomas")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 12) {
                    LanguageItem(flag: "🇺🇸", language: "Inglés", level: "Nativo")
                    LanguageItem(flag: "🇨🇳", language: "Mandarín", level: "Competente")
                }
            }
        }
    }
    
    // MARK: - Recommendations Section
    private var recommendationsSection: some View {
        ProfileSectionCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "hand.thumbsup")
                        .foregroundColor(.orange)
                    Text("Recomendaciones")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                RecommendationCard(
                    name: "Dr. James Wilson",
                    title: "Profesor de Ciencias de la Computación",
                    recommendation: "Alexandra demostró excepcionales habilidades analíticas y dedicación durante su investigación en ML. Altamente recomendada.",
                    timeAgo: "Hace 3 meses"
                )
            }
        }
    }
    
    // MARK: - Bottom Navigation
    private var bottomNavigation: some View {
        HStack {
            NavItem(icon: "house", title: "Home", isSelected: false)
            NavItem(icon: "person.2", title: "Network", isSelected: false)
            NavItem(icon: "briefcase", title: "Jobs", isSelected: false)
            NavItem(icon: "person.circle.fill", title: "Profile", isSelected: true)
        }
        .padding(.vertical, 8)
        .background(
            Color(UIColor.systemBackground)
                .opacity(0.95)
                .background(.ultraThinMaterial)
        )
        .overlay(
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1),
            alignment: .top
        )
    }
}

// MARK: - Supporting Views

struct StatView: View {
    let number: String
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(number)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? .orange : .secondary)
                
                Rectangle()
                    .fill(isSelected ? Color.orange : Color.clear)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

struct ProfileSectionCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .padding(16)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
    }
}

struct ResearchItem: View {
    let icon: String
    let title: String
    let role: String
    let period: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.orange)
                .frame(width: 40, height: 40)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.bold)
                
                Text("Rol: \(role)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(period)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .overlay(
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 0.5),
            alignment: .bottom
        )
    }
}

struct ExperienceItem: View {
    let icon: String
    let title: String
    let company: String
    let period: String
    let isVerified: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 40, height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.body)
                            .fontWeight(.bold)
                        
                        Text(company)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(period)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if isVerified {
                        Text("VERIFICADO")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.green.opacity(0.1))
                            )
                    }
                }
            }
        }
    }
}

struct DocumentItem: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: action)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct SkillTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

struct LanguageItem: View {
    let flag: String
    let language: String
    let level: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(flag)
                .font(.title)
                .frame(width: 48, height: 48)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(language)
                    .font(.body)
                    .fontWeight(.semibold)
                
                Text(level)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct RecommendationCard: View {
    let name: String
    let title: String
    let recommendation: String
    let timeAgo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(.systemGray4))
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.body)
                        .fontWeight(.semibold)
                    
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.top, 2)
                }
                
                Spacer()
            }
            
            Text(recommendation)
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
                .lineSpacing(2)
            
            Text(timeAgo)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemGray6))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct NavItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(isSelected ? .orange : .secondary)
            
            Text(title)
                .font(.caption2)
                .fontWeight(isSelected ? .bold : .medium)
                .foregroundColor(isSelected ? .orange : .secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.orange)
            .foregroundColor(.white)
            .font(.body)
            .fontWeight(.bold)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(.systemGray5))
            .foregroundColor(.primary)
            .font(.body)
            .fontWeight(.bold)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - View Extension for Sticky

extension View {
    func sticky(at offset: CGFloat) -> some View {
        self
    }
}

// MARK: - Preview

struct EstudiantePerfilFreeView_Previews: PreviewProvider {
    static var previews: some View {
        EstudiantePerfilFreeView()
            .preferredColorScheme(.light)
        
        EstudiantePerfilFreeView()
            .preferredColorScheme(.dark)
    }
}