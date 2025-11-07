// Views/Universidad/PerfilUniversidadView.swift
import SwiftUI

// MARK: - Models
struct UniversidadInfo {
    let nombre: String
    let ubicacion: String
    let tipo: String
    let descripcion: String
    let estudiantes: String
    let fundada: String
    let ranking: String
    let profesores: String
    let website: String
    let imagenPortada: String
    let imagenPerfil: String
}

struct OportunidadUniversidad: Identifiable {
    let id = UUID()
    let titulo: String
    let departamento: String
    let tipo: String
    let descripcion: String
}

struct CentroInvestigacion: Identifiable {
    let id = UUID()
    let nombre: String
    let descripcion: String
    let color: Color
    let icon: String
}

struct EstudianteDestacado: Identifiable {
    let id = UUID()
    let nombre: String
    let carrera: String
    let añoGraduacion: String
    let imagenUrl: String
    let esBecario: Bool
}

enum TabUniversidad: String, CaseIterable {
    case sobre = "Sobre"
    case publicaciones = "Publicaciones"
}

// MARK: - Main View
struct PerfilUniversidadView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: TabUniversidad = .sobre
    @State private var scrollOffset: CGFloat = 0
    
    let universidad = UniversidadInfo(
        nombre: "Universidad Estatal",
        ubicacion: "San Francisco, CA",
        tipo: "Educación Superior",
        descripcion: "Somos una institución de educación superior comprometida con la excelencia académica y la formación integral de profesionales. Nuestra misión es brindar educación de calidad y fomentar la investigación e innovación.",
        estudiantes: "15,000+",
        fundada: "1885",
        ranking: "Top 50",
        profesores: "1,200",
        website: "universidadestatal.edu",
        imagenPortada: "https://images.unsplash.com/photo-1562774053-701939374585",
        imagenPerfil: "https://images.unsplash.com/photo-1607237138185-eedd9c632b0b"
    )
    
    let oportunidades = [
        OportunidadUniversidad(
            titulo: "Pasantía en Investigación - Laboratorio de IA",
            departamento: "Departamento de Ingeniería",
            tipo: "Medio tiempo",
            descripcion: "Únete a nuestro equipo de investigación en inteligencia artificial. Experiencia práctica con machine learning y desarrollo de algoritmos bajo supervisión de profesores expertos."
        ),
        OportunidadUniversidad(
            titulo: "Asistente de Cátedra - Administración",
            departamento: "Escuela de Negocios",
            tipo: "Tiempo parcial",
            descripcion: "Oportunidad para estudiantes destacados de apoyar en clases de administración, desarrollar habilidades de liderazgo y obtener experiencia docente."
        ),
        OportunidadUniversidad(
            titulo: "Práctica Profesional - Centro Médico Universitario",
            departamento: "Facultad de Medicina",
            tipo: "Tiempo completo",
            descripcion: "Rotaciones clínicas en nuestro hospital universitario. Experiencia directa con pacientes bajo supervisión de médicos especialistas certificados."
        )
    ]
    
    let centrosInvestigacion = [
        CentroInvestigacion(
            nombre: "Centro de Biotecnología",
            descripcion: "Investigación avanzada",
            color: .blue,
            icon: "cross.vial.fill"
        ),
        CentroInvestigacion(
            nombre: "Laboratorio de Sostenibilidad",
            descripcion: "Tecnologías verdes",
            color: .green,
            icon: "leaf.fill"
        )
    ]
    
    let estudiantesDestacados = [
        EstudianteDestacado(
            nombre: "Carlos Rodríguez",
            carrera: "Medicina",
            añoGraduacion: "'25",
            imagenUrl: "person.circle.fill",
            esBecario: false
        ),
        EstudianteDestacado(
            nombre: "Ana López",
            carrera: "Becaria",
            añoGraduacion: "'23",
            imagenUrl: "person.circle.fill",
            esBecario: true
        ),
        EstudianteDestacado(
            nombre: "Diego Martín",
            carrera: "Negocios",
            añoGraduacion: "'24",
            imagenUrl: "person.circle.fill",
            esBecario: false
        ),
        EstudianteDestacado(
            nombre: "Sofia Herrera",
            carrera: "Psicología",
            añoGraduacion: "'25",
            imagenUrl: "person.circle.fill",
            esBecario: false
        )
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.backgroundDark.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: - Header Image
                    headerImageSection
                    
                    // MARK: - Profile Section
                    profileSection
                    
                    // MARK: - Tabs
                    tabsSection
                    
                    // MARK: - Content
                    contentSection
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // MARK: - Top Bar
            topBarSection
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Top Bar
    private var topBarSection: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
                    .backdrop()
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
                    .backdrop()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 50)
    }
    
    // MARK: - Header Image
    private var headerImageSection: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: universidad.imagenPortada)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .frame(height: 220)
            .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [.clear, Color.backgroundDark.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
        }
        .frame(height: 220)
    }
    
    // MARK: - Profile Section
    private var profileSection: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                // Profile Image
                AsyncImage(url: URL(string: universidad.imagenPerfil)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 128, height: 128)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.backgroundDark, lineWidth: 4)
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                .offset(y: -64)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            // Info
            VStack(alignment: .leading, spacing: 8) {
                Text(universidad.nombre)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Text(universidad.ubicacion)
                    Text("•")
                    Text(universidad.tipo)
                }
                .font(.system(size: 15))
                .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .offset(y: -40)
            
            // Action Buttons
            HStack(spacing: 12) {
                Button(action: {}) {
                    Text("Seguir")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.primaryOrange)
                        .cornerRadius(8)
                }
                
                Button(action: {}) {
                    Text("Contacto")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .offset(y: -30)
        }
    }
    
    // MARK: - Tabs Section
    private var tabsSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(TabUniversidad.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 0) {
                            Text(tab.rawValue)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(selectedTab == tab ? .primaryOrange : .textSecondary)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                            
                            Rectangle()
                                .fill(selectedTab == tab ? Color.primaryOrange : Color.clear)
                                .frame(height: 3)
                        }
                    }
                }
            }
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.backgroundDark)
        .offset(y: -30)
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 24) {
            if selectedTab == .sobre {
                sobreContent
            } else {
                publicacionesContent
            }
        }
        .padding(16)
        .padding(.bottom, 40)
        .background(Color(red: 15/255, green: 23/255, blue: 42/255).opacity(0.3))
        .offset(y: -30)
    }
    
    // MARK: - Sobre Content
    private var sobreContent: some View {
        VStack(spacing: 24) {
            // Acerca de
            VStack(alignment: .leading, spacing: 16) {
                Text("Acerca de \(universidad.nombre)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(universidad.descripcion)
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                        .lineSpacing(4)
                    
                    Button(action: {}) {
                        Text("Leer más")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.primaryOrange)
                    }
                }
                
                // Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatItemUniversidad(
                        icon: "graduationcap.fill",
                        valor: universidad.estudiantes,
                        etiqueta: "Estudiantes"
                    )
                    
                    StatItemUniversidad(
                        icon: "calendar",
                        valor: universidad.fundada,
                        etiqueta: "Fundada"
                    )
                    
                    StatItemUniversidad(
                        icon: "trophy.fill",
                        valor: universidad.ranking,
                        etiqueta: "Nacional"
                    )
                    
                    StatItemUniversidad(
                        icon: "person.3.fill",
                        valor: universidad.profesores,
                        etiqueta: "Profesores"
                    )
                }
                .padding(.top, 8)
                
                // Website
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Image(systemName: "link")
                            .font(.system(size: 14))
                        Text(universidad.website)
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.primaryOrange)
                }
                .padding(.top, 8)
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
            
            // Oportunidades
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Oportunidades")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Ver Todas")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primaryOrange)
                    }
                }
                
                VStack(spacing: 12) {
                    ForEach(oportunidades) { oportunidad in
                        OportunidadCardUniversidad(oportunidad: oportunidad)
                    }
                }
            }
            
            // Investigación
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "flask.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.primaryOrange)
                    
                    Text("Investigación e Innovación")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(centrosInvestigacion) { centro in
                        CentroInvestigacionCard(centro: centro)
                    }
                }
            }
            
            // Estudiantes Destacados
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.primaryOrange)
                    
                    Text("Estudiantes Destacados")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(estudiantesDestacados) { estudiante in
                            EstudianteDestacadoCard(estudiante: estudiante)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Publicaciones Content
    private var publicacionesContent: some View {
        VStack(spacing: 16) {
            Text("Publicaciones próximamente")
                .font(.system(size: 16))
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
        }
    }
}

// MARK: - Stat Item
struct StatItemUniversidad: View {
    let icon: String
    let valor: String
    let etiqueta: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primaryOrange.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.primaryOrange)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(valor)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text(etiqueta)
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Oportunidad Card
struct OportunidadCardUniversidad: View {
    let oportunidad: OportunidadUniversidad
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(oportunidad.titulo)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 4) {
                Text(oportunidad.departamento)
                Text("•")
                Text(oportunidad.tipo)
            }
            .font(.system(size: 13))
            .foregroundColor(.textSecondary)
            
            Text(oportunidad.descripcion)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
                .lineLimit(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Centro Investigación Card
struct CentroInvestigacionCard: View {
    let centro: CentroInvestigacion
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(centro.color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: centro.icon)
                    .font(.system(size: 18))
                    .foregroundColor(centro.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(centro.nombre)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(centro.descripcion)
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Estudiante Destacado Card
struct EstudianteDestacadoCard: View {
    let estudiante: EstudianteDestacado
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Image(systemName: estudiante.imagenUrl)
                    .font(.system(size: 48))
                    .foregroundColor(.white)
                    .frame(width: 96, height: 96)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                
                if estudiante.esBecario {
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryOrange, Color.yellow]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 2, dash: [5, 3])
                        )
                        .frame(width: 104, height: 104)
                }
            }
            
            Text(estudiante.nombre)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(estudiante.esBecario ? .primaryOrange : .white)
            
            Text("\(estudiante.carrera), \(estudiante.añoGraduacion)")
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
        }
        .frame(width: 128)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        PerfilUniversidadView()
    }
    .preferredColorScheme(.dark)
}
