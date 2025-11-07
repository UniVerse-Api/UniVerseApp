
// Views/Empresa/BuscarTalentoView.swift
import SwiftUI

enum StudentFilter: String, CaseIterable {
    case todos = "Todos"
    case disponibles = "Disponibles"
    case recienGraduados = "Recién Graduados"
    case conExperiencia = "Con Experiencia"
    case pasantias = "Pasantías"
}

struct StudentStatus {
    let color: Color
    let icon: String
    let text: String
}

struct Student: Identifiable {
    let id = UUID()
    let name: String
    let imageUrl: String
    let status: StudentStatus
    let university: String
    let skills: [String]
    let skillColor: Color
    let stats: String
    let isPremium: Bool
    var isSaved: Bool
}

struct BuscarTalentoView: View {
    @State private var searchText = ""
    @State private var selectedFilter: StudentFilter = .todos
    @State private var savedStudents: Set<UUID> = []
    
    @Environment(\.presentationMode) var presentationMode
    
    // Sample data
    let featuredStudents = [
        ("Maya Rodriguez", "CS @ Stanford", "person.circle.fill"),
        ("Alex Chen", "Ing. Mecánica @ MIT", "person.circle.fill")
    ]
    
    @State private var students = [
        Student(
            name: "Sofia Martinez",
            imageUrl: "person.crop.circle.fill",
            status: StudentStatus(color: .green, icon: "checkmark", text: "Disponible"),
            university: "Ingeniería de Software @ Universidad Politécnica",
            skills: ["React", "Python", "Node.js"],
            skillColor: .blue,
            stats: "3 proyectos • 2 pasantías • GPA 3.8",
            isPremium: false,
            isSaved: false
        ),
        Student(
            name: "Carlos Rodriguez",
            imageUrl: "person.crop.circle.fill",
            status: StudentStatus(color: .orange, icon: "hourglass", text: "En búsqueda"),
            university: "Data Science @ Universidad de Barcelona",
            skills: ["Machine Learning", "TensorFlow", "SQL"],
            skillColor: .purple,
            stats: "5 proyectos • 1 publicación • GPA 3.9",
            isPremium: false,
            isSaved: false
        ),
        Student(
            name: "Ana Lopez",
            imageUrl: "person.crop.circle.fill",
            status: StudentStatus(color: .purple, icon: "star.fill", text: "Premium"),
            university: "Diseño UX/UI @ ESADE",
            skills: ["Figma", "Adobe XD", "Prototyping"],
            skillColor: .pink,
            stats: "7 proyectos • Portfolio destacado • GPA 3.7",
            isPremium: true,
            isSaved: true
        ),
        Student(
            name: "David Kim",
            imageUrl: "person.crop.circle.fill",
            status: StudentStatus(color: .blue, icon: "graduationcap.fill", text: "Recién graduado"),
            university: "Ingeniería Informática @ UC Berkeley",
            skills: ["Java", "Spring", "AWS"],
            skillColor: .green,
            stats: "4 proyectos • Pasantía en Google • GPA 3.6",
            isPremium: false,
            isSaved: false
        )
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                
                // MARK: - Search and Filters
                searchAndFiltersSection
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Featured Students
                        featuredStudentsSection
                        
                        // Student List
                        ForEach(students.indices, id: \.self) { index in
                            StudentCard(
                                student: students[index],
                                isSaved: students[index].isSaved,
                                onBookmarkTap: {
                                    toggleBookmark(at: index)
                                },
                                onProfileTap: {
                                    // Navigate to profile
                                }
                            )
                        }
                        
                        // Loading skeleton
                        LoadingSkeleton()
                        
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
    
    // MARK: - Toggle Bookmark
    private func toggleBookmark(at index: Int) {
        students[index].isSaved.toggle()
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Buscar Talento")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {}) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 18))
                            .foregroundColor(.textSecondary)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 18))
                            .foregroundColor(.textSecondary)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
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
    
    // MARK: - Search and Filters Section
    private var searchAndFiltersSection: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                
                TextField("Buscar por habilidades, universidad o carrera...", text: $searchText)
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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(StudentFilter.allCases, id: \.self) { filter in
                        FilterButton(
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
    
    // MARK: - Featured Students Section
    private var featuredStudentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                
                Text("Candidatos Destacados")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.blue)
            }
            
            Text("Estudiantes con perfiles sobresalientes en tu área de interés")
                .font(.system(size: 13))
                .foregroundColor(.blue.opacity(0.8))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(featuredStudents, id: \.0) { student in
                        FeaturedStudentCard(name: student.0, university: student.1, icon: student.2)
                    }
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
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Filter Button
struct FilterButton: View {
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
                .background(isSelected ? Color.primaryOrange : Color(red: 30/255, green: 30/255, blue: 30/255))
                .cornerRadius(20)
        }
    }
}

// MARK: - Featured Student Card
struct FeaturedStudentCard: View {
    let name: String
    let university: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundColor(.blue)
                .frame(width: 48, height: 48)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
            
            Text(name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            Text(university)
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
                .lineLimit(1)
        }
        .padding(12)
        .frame(width: 160)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Student Card
struct StudentCard: View {
    let student: Student
    let isSaved: Bool
    let onBookmarkTap: () -> Void
    let onProfileTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // Profile Image with Badge
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: student.imageUrl)
                        .font(.system(size: 48))
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
                    
                    // Status Badge
                    if student.isPremium {
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
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                        .offset(x: 4, y: 4)
                    } else {
                        ZStack {
                            Circle()
                                .fill(student.status.color)
                                .frame(width: 20, height: 20)
                            
                            Image(systemName: student.status.icon)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .offset(x: 4, y: 4)
                    }
                }
                
                // Student Info
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(student.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(student.status.text)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(student.status.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(student.status.color.opacity(0.2))
                            .cornerRadius(12)
                    }
                    
                    Text(student.university)
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                    
                    // Skills
                    HStack(spacing: 6) {
                        ForEach(student.skills, id: \.self) { skill in
                            Text(skill)
                                .font(.system(size: 11))
                                .foregroundColor(student.skillColor)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(student.skillColor.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                    
                    Text(student.stats)
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
            .padding(16)
            
            // Action Buttons
            HStack(spacing: 8) {
                Button(action: onBookmarkTap) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16))
                        .foregroundColor(isSaved ? .primaryOrange : .textSecondary)
                        .frame(width: 40, height: 40)
                        .background(isSaved ? Color.primaryOrange.opacity(0.2) : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Button(action: onProfileTap) {
                    Text("Ver Perfil")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.primaryOrange)
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

// MARK: - Loading Skeleton
struct LoadingSkeleton: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
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
                    
                    HStack(spacing: 6) {
                        ForEach(0..<3) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 24)
                        }
                    }
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
        BuscarTalentoView()
    }
    .preferredColorScheme(.dark)
}
