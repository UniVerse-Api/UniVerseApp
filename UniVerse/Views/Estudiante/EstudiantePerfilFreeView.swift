import SwiftUI

struct EstudiantePerfilFreeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab = "General"
    @State private var perfilCompleto: PerfilCompletoResponse?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    let idPerfil: Int
    private let perfilService = PerfilService()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isLoading {
                VStack(spacing: 0) {
                    // Header con botón de atrás para pantalla de carga
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                
                                Text("Atrás")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 4)
                        }
                        
                        Spacer()
                        
                        Text("Cargando...")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Espacio para mantener centrado el título
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                            Text("Atrás")
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        .opacity(0) // Invisible pero ocupa espacio
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(UIColor.systemBackground))
                    
                    // Contenido de carga
                    VStack {
                        ProgressView("Cargando perfil...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                            .scaleEffect(1.2)
                        
                        Text("Obteniendo información del perfil")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color(.systemBackground))
            } else if let errorMessage = errorMessage {
                VStack(spacing: 0) {
                    // Header con botón de atrás para pantalla de error
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                
                                Text("Atrás")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 4)
                        }
                        
                        Spacer()
                        
                        Text("Error")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Espacio para mantener centrado el título
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                            Text("Atrás")
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        .opacity(0) // Invisible pero ocupa espacio
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(UIColor.systemBackground))
                    
                    // Contenido del error
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        
                        Text("Error al cargar perfil")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(errorMessage)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Reintentar") {
                            Task {
                                await loadPerfil()
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .frame(width: 120)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color(.systemBackground))
            } else if let perfil = perfilCompleto, perfil.success {
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
                            if let investigaciones = perfil.investigaciones, !investigaciones.isEmpty {
                                researchSection
                            }
                            if let experiencias = perfil.experiencias, !experiencias.isEmpty {
                                experienceSection
                            }
                            if let formaciones = perfil.formaciones, !formaciones.isEmpty {
                                educationSection
                            }
                            if let cvs = perfil.cvs, !cvs.isEmpty {
                                documentsSection
                            }
                            if let habilidades = perfil.habilidades, !habilidades.isEmpty {
                                skillsSection
                            }
                            if let idiomas = perfil.idiomas, !idiomas.isEmpty {
                                languagesSection
                            }
                            // recommendationsSection
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
        .task {
            await loadPerfil()
        }
    }
    
    // MARK: - Helper Functions
    
    private func getFlagEmoji(for country: String) -> String {
        switch country.lowercased() {
        case "el salvador":
            return "🇸🇻"
        case "guatemala":
            return "🇬🇹"
        case "honduras":
            return "🇭🇳"
        case "nicaragua":
            return "🇳🇮"
        case "costa rica":
            return "🇨🇷"
        case "panama", "panamá":
            return "🇵🇦"
        case "méxico", "mexico":
            return "🇲🇽"
        case "estados unidos", "usa":
            return "🇺🇸"
        default:
            return "🌍"
        }
    }
    
    private func getLanguageFlag(_ language: String) -> String {
        switch language.lowercased() {
        case "español", "spanish":
            return "🇸🇻"
        case "inglés", "english":
            return "🇺🇸"
        case "francés", "french":
            return "🇫🇷"
        case "portugués", "portuguese":
            return "🇵🇹"
        case "italiano", "italian":
            return "🇮🇹"
        case "alemán", "german":
            return "🇩🇪"
        case "chino", "mandarín", "chinese":
            return "🇨🇳"
        case "japonés", "japanese":
            return "🇯🇵"
        default:
            return "🌍"
        }
    }
    
    private func getExperienceIcon(_ tipo: String) -> String {
        switch tipo.lowercased() {
        case "pasantia":
            return "graduationcap"
        case "tiempo_completo":
            return "briefcase.fill"
        case "medio_tiempo":
            return "briefcase"
        case "voluntariado":
            return "heart.fill"
        default:
            return "briefcase"
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.locale = Locale(identifier: "es_ES")
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
    
    private func formatDateRange(_ startDate: String, _ endDate: String) -> String {
        let start = formatDate(startDate)
        let end = formatDate(endDate)
        return "\(start) - \(end)"
    }
    
    private func formatExperiencePeriod(_ experiencia: ExperienciaPerfil) -> String {
        let start = formatDate(experiencia.fechaInicio)
        let end = experiencia.fechaFin != nil ? formatDate(experiencia.fechaFin!) : "Presente"
        let location = experiencia.ubicacion != nil ? " · \(experiencia.ubicacion!)" : ""
        return "\(start) - \(end)\(location)"
    }
    
    // MARK: - Data Loading
    private func loadPerfil() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Obtener el ID del perfil visitante si hay usuario logueado
            var idPerfilVisitante: Int? = nil
            if let currentUser = authVM.currentUser,
               let perfil = currentUser.perfil {
                idPerfilVisitante = perfil.id
            }
            
            print("DEBUG EstudiantePerfilFreeView: Loading perfil \(idPerfil) with visitante \(idPerfilVisitante ?? -1)")
            
            let perfil = try await perfilService.getPerfilEstudianteCompleto(
                idPerfil: idPerfil,
                idPerfilVisitante: idPerfilVisitante
            )
            
            await MainActor.run {
                self.perfilCompleto = perfil
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            print("ERROR EstudiantePerfilFreeView: \(error.localizedDescription)")
        }
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
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                        
                        Text("Atrás")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 4)
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
                AsyncImage(url: URL(string: perfilCompleto?.perfilBasico?.fotoPerfil ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color(.systemGray4))
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        )
                }
                .frame(width: 96, height: 96)
                .clipShape(Circle())
                
                // Profile Details
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(perfilCompleto?.perfilBasico?.nombreCompleto ?? "Usuario")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if let pais = perfilCompleto?.perfilBasico?.pais {
                            Text(getFlagEmoji(for: pais))
                                .font(.title3)
                        }
                        
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
                    
                    if let carrera = perfilCompleto?.perfilEstudiante?.carrera {
                        Text(carrera)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    if let universidad = perfilCompleto?.perfilEstudiante?.universidadActual {
                        Text("@ \(universidad)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let ubicacion = perfilCompleto?.perfilBasico?.ubicacion {
                        Text(ubicacion)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 2)
                    }
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
            StatView(
                number: "\(perfilCompleto?.estadisticas?.seguidores ?? 0)",
                label: "Seguidores"
            )
            StatView(
                number: "\(perfilCompleto?.estadisticas?.siguiendo ?? 0)",
                label: "Siguiendo"
            )
            StatView(
                number: "\(perfilCompleto?.estadisticas?.publicaciones ?? 0)",
                label: "Publicaciones"
            )
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
                
                Text(perfilCompleto?.perfilBasico?.biografia ?? "Sin información disponible")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
                
                if let telefono = perfilCompleto?.perfilBasico?.telefono {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.orange)
                        Text(telefono)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                }
                
                if let sitioWeb = perfilCompleto?.perfilBasico?.sitioWeb {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.orange)
                        Text(sitioWeb)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 4)
                }
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
                    
                    Text("\(perfilCompleto?.investigaciones?.count ?? 0)")
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
                
                if let investigaciones = perfilCompleto?.investigaciones {
                    VStack(spacing: 16) {
                        ForEach(investigaciones, id: \.idInvestigacion) { investigacion in
                            ResearchItem(
                                icon: "flask",
                                title: investigacion.titulo,
                                role: investigacion.rol ?? "Investigador",
                                period: formatDateRange(investigacion.fechaInicio, investigacion.fechaFin)
                            )
                        }
                    }
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
                
                if let experiencias = perfilCompleto?.experiencias {
                    VStack(spacing: 16) {
                        ForEach(experiencias, id: \.idExperiencia) { experiencia in
                            ExperienceItem(
                                icon: getExperienceIcon(experiencia.tipo),
                                title: experiencia.puesto,
                                company: experiencia.empresa,
                                period: formatExperiencePeriod(experiencia),
                                isVerified: false // Por ahora siempre false
                            )
                        }
                    }
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
                
                if let formaciones = perfilCompleto?.formaciones {
                    VStack(spacing: 16) {
                        ForEach(formaciones, id: \.idFormacion) { formacion in
                            HStack(alignment: .top, spacing: 16) {
                                Image(systemName: "graduationcap")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                    .frame(width: 40, height: 40)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(formacion.institucion)
                                        .font(.body)
                                        .fontWeight(.bold)
                                    
                                    Text("\(formacion.grado) en \(formacion.campoEstudio)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text(formatDateRange(formacion.fechaInicio, formacion.fechaFin))
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    
                                    if formacion.esActual {
                                        HStack {
                                            Text("En curso")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.green)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .fill(Color.green.opacity(0.1))
                                                )
                                            
                                            Spacer()
                                        }
                                        .padding(.top, 8)
                                    }
                                }
                            }
                        }
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
                    // CVs
                    if let cvs = perfilCompleto?.cvs {
                        ForEach(cvs, id: \.idCv) { cv in
                            DocumentItem(
                                icon: "doc.richtext",
                                iconColor: .red,
                                title: cv.nombre,
                                subtitle: "Subido \(formatDate(cv.fechaSubida))",
                                action: "arrow.down.circle"
                            )
                        }
                    }
                    
                    // Certificaciones
                    if let certificaciones = perfilCompleto?.certificaciones {
                        ForEach(certificaciones, id: \.idCertificacion) { certificacion in
                            DocumentItem(
                                icon: "checkmark.seal",
                                iconColor: .blue,
                                title: certificacion.titulo,
                                subtitle: "\(certificacion.institucion) · \(formatDate(certificacion.fechaObtencion))",
                                action: "arrow.up.right.square"
                            )
                        }
                    }
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
                
                if let habilidades = perfilCompleto?.habilidades {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(habilidades, id: \.idHabilidad) { habilidad in
                            SkillTag(text: habilidad.nombre)
                        }
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
                
                if let idiomas = perfilCompleto?.idiomas {
                    VStack(spacing: 12) {
                        ForEach(idiomas, id: \.idIdioma) { idioma in
                            LanguageItem(
                                flag: getLanguageFlag(idioma.nombre),
                                language: idioma.nombre,
                                level: idioma.nivel.capitalized
                            )
                        }
                    }
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
        EstudiantePerfilFreeView(idPerfil: 1)
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.light)
        
        EstudiantePerfilFreeView(idPerfil: 1)
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
