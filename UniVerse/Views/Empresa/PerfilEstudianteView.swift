
// Views/Empresa/PerfilEstudianteView.swift
import SwiftUI


struct PerfilEstudianteView: View {
    @State private var selectedTab = 0
    @State private var isHighlighted = false
    @State private var isSaved = false
    @State private var showCommentModal = false
    @State private var commentText = ""
    @State private var companyNotes: [CompanyNoteEmpresa] = [
        CompanyNoteEmpresa(
            author: "Innovate Corp (Recruiters)",
            date: Date().addingTimeInterval(-86400 * 3),
            text: "Candidata muy prometedora. Excelente en entrevista técnica y muestra gran pasión por el desarrollo de software."
        )
    ]
    @Environment(\.presentationMode) var presentationMode
   
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    headerSection
                   
                    // Profile Header
                    profileHeaderSection
                   
                    // Company Notes Section
                    companyNotesSection
                   
                    // Stats
                    statsSection
                   
                    // Tabs
                    tabSection
                   
                    // Content
                    contentSection
                }
            }
            .background(Color.backgroundDark)
           
            // Comment Modal
            if showCommentModal {
                commentModalView
            }
        }
        .navigationBarHidden(true)
    }
   
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.title3)
                    .foregroundColor(.white)
            }
           
            Spacer()
           
            Text("Perfil del Estudiante")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
           
            Spacer()
           
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundDark)
        .overlay(
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1),
            alignment: .bottom
        )
    }
   
    // MARK: - Profile Header Section
    private var profileHeaderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                // Profile Image with Premium Badge
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text("SC")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                   
                    // Premium Badge
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
                       
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(x: 5, y: -2)
                }
               
                // Profile Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("Sarah Chen")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                       
                        // Verified Badge
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
                    }
                   
                    Text("Ingeniera de Software Sr.")
                        .font(.system(size: 15))
                        .foregroundColor(.textSecondary)
                   
                    Text("@ Universidad Estatal")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                   
                    Text("📍 San Francisco, CA")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                        .padding(.top, 2)
                }
               
                Spacer()
            }
           
            // Action Buttons
            HStack(spacing: 12) {
                Button(action: {
                    isHighlighted.toggle()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: isHighlighted ? "star.fill" : "star")
                            .font(.system(size: 14))
                        Text(isHighlighted ? "Destacado" : "Destacar")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(isHighlighted ? Color(hex: "EAB308") : Color(hex: "FCD34D"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(isHighlighted ? Color(hex: "FCD34D").opacity(0.2) : Color(hex: "FEF3C7").opacity(0.2))
                    .cornerRadius(8)
                }
               
                Button(action: {
                    isSaved.toggle()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 14))
                        Text(isSaved ? "Guardado" : "Guardar")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(isSaved ? .primaryOrange : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(isSaved ? Color.primaryOrange.opacity(0.2) : Color.gray.opacity(0.3))
                    .cornerRadius(8)
                }
               
                Button(action: {
                    showCommentModal = true
                }) {
                    Image(systemName: "message")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.primaryOrange)
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.backgroundDark)
    }
   
    // MARK: - Company Notes Section
    private var companyNotesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "building.2")
                        .foregroundColor(.primaryOrange)
                    Text("Notas de la Empresa")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
               
                Spacer()
               
                Button(action: {
                    showCommentModal = true
                }) {
                    Text("Agregar Nota")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primaryOrange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.primaryOrange.opacity(0.1))
                        .cornerRadius(6)
                }
            }
           
            if companyNotes.isEmpty {
                Text("No hay notas todavía")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .padding(.vertical, 12)
            } else {
                VStack(spacing: 12) {
                    ForEach(companyNotes) { note in
                        CompanyNoteCardEmpresa(note: note)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primaryOrange.opacity(0.2), lineWidth: 2)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundDark.opacity(0.5))
    }
   
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 0) {
            StatItemEmpresa(value: "532", label: "Seguidores")
            StatItemEmpresa(value: "189", label: "Siguiendo")
            StatItemEmpresa(value: "24", label: "Publicaciones")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundDark)
    }
   
    // MARK: - Tab Section
    private var tabSection: some View {
        VStack(spacing: 0) {
            HStack {
                TabButtonEmpresa(title: "General", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
               
                TabButtonEmpresa(title: "Publicaciones", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
            }
           
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.backgroundDark)
    }
   
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 20) {
            if selectedTab == 0 {
                generalSection
            } else {
                publicationsSection
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 40)
        .background(Color.backgroundDark.opacity(0.5))
    }
   
    // MARK: - General Section
    private var generalSection: some View {
        VStack(spacing: 16) {
            // About
            InfoCardEmpresa(title: "Sobre mí", icon: "person.text.rectangle") {
                Text("Estudiante apasionada por el desarrollo de software escalable y con sólida base en estructuras de datos y algoritmos. Busco aplicar mis conocimientos académicos a desafíos del mundo real.")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
           
            // Research
            InfoCardEmpresa(title: "Investigaciones", icon: "flask", badge: "2", highlightBorder: true) {
                VStack(spacing: 16) {
                    ResearchItemEmpresa(
                        icon: "lightbulb.fill",
                        title: "Optimización de Algoritmos de ML",
                        description: "Investigación sobre técnicas de optimización para modelos de aprendizaje automático en dispositivos móviles.",
                        status: "En progreso"
                    )
                   
                    Divider()
                        .background(Color.borderColor)
                   
                    ResearchItemEmpresa(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Análisis de Datos en Tiempo Real",
                        description: "Desarrollo de un sistema de procesamiento de streams de datos usando Apache Kafka.",
                        status: "Completado"
                    )
                }
            }
           
            // Experience
            InfoCardEmpresa(title: "Experiencia & Pasantías", icon: "briefcase") {
                VStack(spacing: 16) {
                    ExperienceItemEmpresa(
                        company: "TechStart Inc.",
                        role: "Pasante de Desarrollo de Software",
                        period: "Jun 2023 - Ago 2023",
                        description: "Desarrollé características para una aplicación web usando React y Node.js. Colaboré con equipos multifuncionales en metodología Agile.",
                        logo: "T"
                    )
                   
                    Divider()
                        .background(Color.borderColor)
                   
                    ExperienceItemEmpresa(
                        company: "Universidad Estatal",
                        role: "Asistente de Investigación",
                        period: "Sep 2022 - May 2023",
                        description: "Asistí en proyectos de investigación de IA, realizando análisis de datos y desarrollo de prototipos.",
                        logo: "U"
                    )
                }
            }
           
            // Education
            InfoCardEmpresa(title: "Formación Académica", icon: "graduationcap") {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.primaryOrange.opacity(0.1))
                            .frame(width: 40, height: 40)
                       
                        Image(systemName: "building.columns")
                            .foregroundColor(.primaryOrange)
                    }
                   
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Universidad Estatal")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Text("Licenciatura en Ciencias de la Computación")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                        Text("2020 - 2024 • GPA: 3.8/4.0")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                   
                    Spacer()
                }
            }
           
            // Documents & Certifications
            InfoCardEmpresa(title: "Documentos y Certificaciones", icon: "doc.text") {
                VStack(spacing: 12) {
                    DocumentItemEmpresa(
                        icon: "doc.fill",
                        title: "Curriculum Vitae",
                        subtitle: "Actualizado hace 2 semanas",
                        color: .blue
                    )
                   
                    DocumentItemEmpresa(
                        icon: "medal.fill",
                        title: "AWS Certified Developer",
                        subtitle: "Amazon Web Services • 2023",
                        color: .orange
                    )
                }
            }
           
            // Skills
            InfoCardEmpresa(title: "Habilidades Técnicas", icon: "chevron.left.forwardslash.chevron.right") {
                FlowLayoutEmpresa(spacing: 8) {
                    SkillTagEmpresa(text: "Python")
                    SkillTagEmpresa(text: "JavaScript")
                    SkillTagEmpresa(text: "React")
                    SkillTagEmpresa(text: "Node.js")
                    SkillTagEmpresa(text: "SQL")
                    SkillTagEmpresa(text: "Git")
                }
            }
           
            // Languages
            InfoCardEmpresa(title: "Idiomas", icon: "globe") {
                VStack(spacing: 16) {
                    LanguageItemEmpresa(language: "Español", level: "Nativo")
                    LanguageItemEmpresa(language: "Inglés", level: "Avanzado (C1)")
                }
            }
           
            // Recommendations
            InfoCardEmpresa(title: "Recomendaciones", icon: "hand.thumbsup") {
                RecommendationCardEmpresa(
                    author: "Dr. James Wilson",
                    role: "Profesor de Ciencias de la Computación",
                    text: "Sarah es una de las estudiantes más dedicadas que he tenido. Su capacidad para resolver problemas complejos y su pasión por la tecnología la distinguen. Será un activo valioso para cualquier equipo."
                )
            }
        }
        .padding(.horizontal, 16)
    }
   
    // MARK: - Publications Section
    private var publicationsSection: some View {
        VStack(spacing: 16) {
            Text("Publicaciones")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
           
            Text("Aquí aparecerán las publicaciones del estudiante")
                .font(.body)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 16)
        }
        .padding(.top, 40)
    }
   
    // MARK: - Comment Modal
    private var commentModalView: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    showCommentModal = false
                }
           
            VStack(spacing: 20) {
                HStack {
                    Text("Agregar Nota")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                   
                    Spacer()
                   
                    Button(action: {
                        showCommentModal = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
               
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nota interna")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                   
                    TextEditor(text: $commentText)
                        .frame(height: 120)
                        .padding(12)
                        .background(Color.inputBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
               
                HStack(spacing: 12) {
                    Button(action: {
                        showCommentModal = false
                        commentText = ""
                    }) {
                        Text("Cancelar")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                   
                    Button(action: {
                        if !commentText.isEmpty {
                            let newNote = CompanyNoteEmpresa(
                                author: "Tu Empresa (Recruiters)",
                                date: Date(),
                                text: commentText
                            )
                            companyNotes.insert(newNote, at: 0)
                            commentText = ""
                            showCommentModal = false
                        }
                    }) {
                        Text("Guardar Nota")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.primaryOrange)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(24)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .padding(.horizontal, 24)
        }
    }
}


// MARK: - Supporting Views


struct CompanyNoteEmpresa: Identifiable {
    let id = UUID()
    let author: String
    let date: Date
    let text: String
}


struct CompanyNoteCardEmpresa: View {
    let note: CompanyNoteEmpresa
   
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Por: \(note.author)")
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
               
                Spacer()
               
                Text(timeAgo(from: note.date))
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
           
            Text(note.text)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
        .padding(12)
        .background(Color.backgroundDark.opacity(0.5))
        .cornerRadius(8)
    }
   
    private func timeAgo(from date: Date) -> String {
        let seconds = Date().timeIntervalSince(date)
        if seconds < 60 {
            return "Hace unos momentos"
        } else if seconds < 3600 {
            let minutes = Int(seconds / 60)
            return "Hace \(minutes) min"
        } else if seconds < 86400 {
            let hours = Int(seconds / 3600)
            return "Hace \(hours)h"
        } else {
            let days = Int(seconds / 86400)
            return "Hace \(days)d"
        }
    }
}


struct StatItemEmpresa: View {
    let value: String
    let label: String
   
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct TabButtonEmpresa: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
   
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
               
                Rectangle()
                    .fill(isSelected ? Color.primaryOrange : Color.clear)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}


struct InfoCardEmpresa<Content: View>: View {
    let title: String
    let icon: String
    var badge: String? = nil
    var highlightBorder: Bool = false
    let content: Content
   
    init(title: String, icon: String, badge: String? = nil, highlightBorder: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.badge = badge
        self.highlightBorder = highlightBorder
        self.content = content()
    }
   
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .foregroundColor(.primaryOrange)
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
               
                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primaryOrange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.primaryOrange.opacity(0.1))
                        .cornerRadius(6)
                }
               
                Spacer()
            }
           
            content
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(highlightBorder ? Color.primaryOrange.opacity(0.3) : Color.clear, lineWidth: 2)
        )
    }
}


struct ResearchItemEmpresa: View {
    let icon: String
    let title: String
    let description: String
    let status: String
   
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.1))
                    .frame(width: 40, height: 40)
               
                Image(systemName: icon)
                    .foregroundColor(.primaryOrange)
            }
           
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
               
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(3)
               
                Text(status)
                    .font(.system(size: 12))
                    .foregroundColor(.primaryOrange)
                    .padding(.top, 4)
            }
        }
    }
}


struct ExperienceItemEmpresa: View {
    let company: String
    let role: String
    let period: String
    let description: String
    let logo: String
   
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.1))
                    .frame(width: 40, height: 40)
               
                Text(logo)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primaryOrange)
            }
           
            VStack(alignment: .leading, spacing: 4) {
                Text(role)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
               
                Text(company)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
               
                Text(period)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
               
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(3)
                    .padding(.top, 4)
            }
        }
    }
}


struct DocumentItemEmpresa: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
   
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
               
                Image(systemName: icon)
                    .foregroundColor(color)
            }
           
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
               
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
           
            Spacer()
           
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
        }
        .padding(12)
        .background(Color.backgroundDark.opacity(0.5))
        .cornerRadius(8)
    }
}


struct SkillTagEmpresa: View {
    let text: String
   
    var body: some View {
        Text(text)
            .font(.system(size: 13))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.primaryOrange.opacity(0.2))
            .cornerRadius(6)
    }
}


struct FlowLayoutEmpresa: Layout {
    var spacing: CGFloat = 8
   
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
   
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
   
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
       
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
           
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
               
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
               
                frames.append(CGRect(x: x, y: y, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
           
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}


struct LanguageItemEmpresa: View {
    let language: String
    let level: String
   
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "globe")
                    .foregroundColor(.primaryOrange)
               
                Text(language)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
           
            Spacer()
           
            Text(level)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
        }
    }
}


struct RecommendationCardEmpresa: View {
    let author: String
    let role: String
    let text: String
   
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("JW")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    )
               
                VStack(alignment: .leading, spacing: 2) {
                    Text(author)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                   
                    Text(role)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                }
               
                Spacer()
            }
           
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color.backgroundDark.opacity(0.5))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primaryOrange.opacity(0.2), lineWidth: 1)
        )
    }
}


// MARK: - Preview
#Preview {
    NavigationView {
        PerfilEstudianteView()
    }
    .preferredColorScheme(.dark)
}




