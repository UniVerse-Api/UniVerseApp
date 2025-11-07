// Views/Estudiante/EmpleosEstudianteView.swift
import SwiftUI

enum JobFilterType: String, CaseIterable {
    case todos = "Todos"
    case misAplicaciones = "Mis Aplicaciones"
    case pasantias = "Pasantías"
    case tiempoCompleto = "Tiempo Completo"
    case remoto = "Remoto"
    
    var icon: String? {
        switch self {
        case .misAplicaciones:
            return "doc.text.fill"
        default:
            return nil
        }
    }
}

enum ApplicationStatus {
    case enRevision
    case entrevista
    case noSeleccionado
    case revisado
    
    var color: Color {
        switch self {
        case .enRevision: return .yellow
        case .entrevista: return .green
        case .noSeleccionado: return .red
        case .revisado: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .enRevision: return "clock.fill"
        case .entrevista: return "checkmark.circle.fill"
        case .noSeleccionado: return "xmark.circle.fill"
        case .revisado: return "eye.fill"
        }
    }
    
    var text: String {
        switch self {
        case .enRevision: return "En Revisión"
        case .entrevista: return "Entrevista Programada"
        case .noSeleccionado: return "No Seleccionado"
        case .revisado: return "Revisado"
        }
    }
}

struct JobListing: Identifiable {
    let id = UUID()
    let title: String
    let company: String
    let logoUrl: String?
    let logoIcon: String?
    let logoColor: Color?
    let location: String
    let jobType: String
    let salary: String?
    let skills: [JobSkillTag]
    let postedDate: String
    let isVerified: Bool
    let isFeatured: Bool
}

struct JobApplication: Identifiable {
    let id = UUID()
    let job: JobListing
    let appliedDate: String
    let status: ApplicationStatus
    let statusMessage: String?
}

struct JobSkillTag: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

struct EmpleosEstudianteView: View {
    @State private var searchText = ""
    @State private var selectedFilter: JobFilterType = .todos
    @State private var bookmarkedJobs: Set<UUID> = []
    @State private var showingFilterSheet = false
    
    @Environment(\.presentationMode) var presentationMode
    
    // Sample Job Listings
    let jobListings = [
        JobListing(
            title: "Desarrollador Full Stack Junior",
            company: "Innovate Inc.",
            logoUrl: "building.2.fill",
            logoIcon: nil,
            logoColor: nil,
            location: "San Francisco, CA",
            jobType: "Tiempo Completo",
            salary: "$80,000 - $100,000",
            skills: [],
            postedDate: "",
            isVerified: true,
            isFeatured: true
        ),
        JobListing(
            title: "Pasantía en Data Science",
            company: "TechCorp",
            logoUrl: nil,
            logoIcon: "building.2.fill",
            logoColor: .blue,
            location: "Nueva York, NY",
            jobType: "Pasantía",
            salary: nil,
            skills: [
                JobSkillTag(name: "Python", color: .blue),
                JobSkillTag(name: "SQL", color: .green)
            ],
            postedDate: "Hace 2 días",
            isVerified: false,
            isFeatured: false
        ),
        JobListing(
            title: "Diseñador UX/UI Junior",
            company: "Creative Studios",
            logoUrl: nil,
            logoIcon: "paintbrush.fill",
            logoColor: .purple,
            location: "Austin, TX",
            jobType: "Medio Tiempo",
            salary: nil,
            skills: [
                JobSkillTag(name: "Figma", color: .purple),
                JobSkillTag(name: "Adobe XD", color: .pink)
            ],
            postedDate: "Hace 5 días",
            isVerified: false,
            isFeatured: false
        ),
        JobListing(
            title: "Desarrollador Frontend",
            company: "StartupXYZ",
            logoUrl: nil,
            logoIcon: "chevron.left.forwardslash.chevron.right",
            logoColor: .green,
            location: "Remoto",
            jobType: "Tiempo Completo",
            salary: nil,
            skills: [
                JobSkillTag(name: "React", color: .yellow),
                JobSkillTag(name: "TypeScript", color: .blue)
            ],
            postedDate: "Hace 1 semana",
            isVerified: false,
            isFeatured: false
        ),
        JobListing(
            title: "Analista de Marketing Digital",
            company: "Marketing Pro",
            logoUrl: nil,
            logoIcon: "chart.line.uptrend.xyaxis",
            logoColor: .red,
            location: "Miami, FL",
            jobType: "Pasantía",
            salary: nil,
            skills: [
                JobSkillTag(name: "Analytics", color: .red),
                JobSkillTag(name: "SEO", color: .orange)
            ],
            postedDate: "Hace 3 días",
            isVerified: false,
            isFeatured: false
        )
    ]
    
    // Sample Applications
    let applications = [
        JobApplication(
            job: JobListing(
                title: "Desarrollador Full Stack Junior",
                company: "Innovate Inc.",
                logoUrl: "building.2.fill",
                logoIcon: nil,
                logoColor: nil,
                location: "San Francisco, CA",
                jobType: "Tiempo Completo",
                salary: nil,
                skills: [],
                postedDate: "",
                isVerified: true,
                isFeatured: false
            ),
            appliedDate: "Aplicado hace 2 días",
            status: .enRevision,
            statusMessage: nil
        ),
        JobApplication(
            job: JobListing(
                title: "Pasantía en Data Science",
                company: "TechCorp",
                logoUrl: nil,
                logoIcon: "building.2.fill",
                logoColor: .blue,
                location: "Nueva York, NY",
                jobType: "Pasantía",
                salary: nil,
                skills: [],
                postedDate: "",
                isVerified: false,
                isFeatured: false
            ),
            appliedDate: "Aplicado hace 5 días",
            status: .entrevista,
            statusMessage: nil
        ),
        JobApplication(
            job: JobListing(
                title: "Diseñador UX/UI Junior",
                company: "Creative Studios",
                logoUrl: nil,
                logoIcon: "paintbrush.fill",
                logoColor: .purple,
                location: "Austin, TX",
                jobType: "Medio Tiempo",
                salary: nil,
                skills: [],
                postedDate: "",
                isVerified: false,
                isFeatured: false
            ),
            appliedDate: "Aplicado hace 1 semana",
            status: .noSeleccionado,
            statusMessage: "Gracias por tu interés. En esta ocasión hemos decidido continuar con otros candidatos."
        ),
        JobApplication(
            job: JobListing(
                title: "Desarrollador Frontend",
                company: "StartupXYZ",
                logoUrl: nil,
                logoIcon: "chevron.left.forwardslash.chevron.right",
                logoColor: .indigo,
                location: "Remoto",
                jobType: "Tiempo Completo",
                salary: nil,
                skills: [],
                postedDate: "",
                isVerified: false,
                isFeatured: false
            ),
            appliedDate: "Aplicado hace 3 días",
            status: .revisado,
            statusMessage: nil
        )
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                empleosHeader
                
                // MARK: - Search and Filters
                searchAndFiltersSection
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        if selectedFilter == .misAplicaciones {
                            // Applications List
                            ForEach(applications) { application in
                                ApplicationCard(application: application)
                            }
                        } else {
                            // Job Listings
                            ForEach(jobListings) { job in
                                if job.isFeatured {
                                    FeaturedJobCard(
                                        job: job,
                                        isBookmarked: bookmarkedJobs.contains(job.id),
                                        onBookmarkTap: {
                                            toggleBookmark(job.id)
                                        }
                                    )
                                } else {
                                    JobCard(
                                        job: job,
                                        isBookmarked: bookmarkedJobs.contains(job.id),
                                        onBookmarkTap: {
                                            toggleBookmark(job.id)
                                        }
                                    )
                                }
                            }
                        }
                        
                        // Loading Skeleton
                        JobLoadingSkeleton()
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
                .background(Color(red: 15/255, green: 23/255, blue: 42/255).opacity(0.3))
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header
    private var empleosHeader: some View {
        VStack(spacing: 0) {
            Text("Empleos")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.backgroundDark.opacity(0.8))
        .backdrop()
    }
    
    // MARK: - Search and Filters Section
    private var searchAndFiltersSection: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                
                TextField("Buscar empleos, empresas o ubicación...", text: $searchText)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(red: 30/255, green: 30/255, blue: 30/255))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
            
            // Filter Buttons
            HStack(spacing: 8) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(JobFilterType.allCases, id: \.self) { filter in
                            JobFilterButton(
                                title: filter.rawValue,
                                icon: filter.icon,
                                isSelected: selectedFilter == filter
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedFilter = filter
                                }
                            }
                        }
                    }
                }
                
                Button(action: {
                    showingFilterSheet = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.backgroundDark)
        .overlay(
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Toggle Bookmark
    private func toggleBookmark(_ jobId: UUID) {
        if bookmarkedJobs.contains(jobId) {
            bookmarkedJobs.remove(jobId)
        } else {
            bookmarkedJobs.insert(jobId)
        }
    }
}

// MARK: - Job Filter Button
struct JobFilterButton: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 11))
                }
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(isSelected ? .black : .textSecondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(isSelected ? Color.primaryOrange : Color(red: 30/255, green: 30/255, blue: 30/255))
            .cornerRadius(20)
        }
    }
}

// MARK: - Featured Job Card
struct FeaturedJobCard: View {
    let job: JobListing
    let isBookmarked: Bool
    let onBookmarkTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Featured Badge
            HStack {
                Spacer()
                Text("DESTACADO")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.primaryOrange)
                    .cornerRadius(4)
            }
            .padding([.top, .trailing], 12)
            
            HStack(alignment: .top, spacing: 12) {
                // Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: job.logoUrl ?? "building.2.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
                
                // Job Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(job.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 6) {
                        Text(job.company)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.textSecondary)
                        
                        if job.isVerified {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 14, height: 14)
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 9))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 10))
                            Text(job.location)
                                .font(.system(size: 11))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 10))
                            Text(job.jobType)
                                .font(.system(size: 11))
                        }
                    }
                    .foregroundColor(.textSecondary)
                    
                    if let salary = job.salary {
                        HStack {
                            Text(salary)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.primaryOrange)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("Aplicar")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.primaryOrange)
                                    .cornerRadius(20)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding([.horizontal, .bottom], 16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.primaryOrange.opacity(0.1),
                    Color.primaryOrange.opacity(0.05)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 2)
        )
    }
}

// MARK: - Job Card
struct JobCard: View {
    let job: JobListing
    let isBookmarked: Bool
    let onBookmarkTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(job.logoColor ?? Color.blue)
                        .frame(width: 48, height: 48)
                    
                    if let logoIcon = job.logoIcon {
                        Image(systemName: logoIcon)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    } else if let logoUrl = job.logoUrl {
                        Image(systemName: logoUrl)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                
                // Job Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(job.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(job.company)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: job.location == "Remoto" ? "laptopcomputer" : "location.fill")
                                .font(.system(size: 9))
                            Text(job.location)
                                .font(.system(size: 10))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 9))
                            Text(job.jobType)
                                .font(.system(size: 10))
                        }
                    }
                    .foregroundColor(.textSecondary)
                    
                    HStack {
                        HStack(spacing: 6) {
                            ForEach(job.skills.prefix(2)) { skill in
                                Text(skill.name)
                                    .font(.system(size: 10))
                                    .foregroundColor(skill.color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(skill.color.opacity(0.2))
                                    .cornerRadius(12)
                            }
                        }
                        
                        Spacer()
                        
                        Text(job.postedDate)
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            
            // Action Buttons
            HStack(spacing: 8) {
                Button(action: {}) {
                    Text("Aplicar")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.primaryOrange)
                        .cornerRadius(8)
                }
                
                Button(action: onBookmarkTap) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 14))
                        .foregroundColor(isBookmarked ? .primaryOrange : .textSecondary)
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.borderColor.opacity(0.3))
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Application Card
struct ApplicationCard: View {
    let application: JobApplication
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                // Logo
                ZStack {
                    if let logoColor = application.job.logoColor {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(logoColor)
                            .frame(width: 48, height: 48)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(width: 48, height: 48)
                    }
                    
                    if let logoIcon = application.job.logoIcon {
                        Image(systemName: logoIcon)
                            .font(.system(size: 24))
                            .foregroundColor(application.job.logoColor != nil ? .white : .blue)
                    } else if let logoUrl = application.job.logoUrl {
                        Image(systemName: logoUrl)
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }
                
                // Job Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(application.job.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(application.job.company)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 9))
                        Text(application.appliedDate)
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.textSecondary)
                    
                    // Status Badge
                    HStack(spacing: 6) {
                        Image(systemName: application.status.icon)
                            .font(.system(size: 10))
                        Text(application.status.text)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(application.status.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(application.status.color.opacity(0.2))
                    .cornerRadius(20)
                }
                
                Spacer()
            }
            
            // Status Message
            if let message = application.statusMessage {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(Color.borderColor)
                        .frame(height: 1)
                    
                    Text(message)
                        .font(.system(size: 12))
                        .foregroundColor(application.status.color.opacity(0.9))
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(application.status.color.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.top, 12)
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
}

// MARK: - Job Loading Skeleton
struct JobLoadingSkeleton: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 14)
                        .frame(maxWidth: .infinity)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 12)
                        .frame(width: 120)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 10)
                        .frame(width: 100)
                }
            }
            .padding(16)
        }
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
        EmpleosEstudianteView()
    }
    .preferredColorScheme(.dark)
}
