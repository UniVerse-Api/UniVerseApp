
// Views/Empresa/PerfilEmpresaView.swift
import SwiftUI


struct PerfilEmpresaView: View {
    @State private var selectedTab = 0
    @Environment(\.presentationMode) var presentationMode
   
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header con navegación
                headerSection
               
                // Imagen de portada y logo
                coverAndLogoSection
               
                // Información de la empresa
                companyInfoSection
               
                // Botones de acción
                actionButtonsSection
               
                // Tabs (Acerca de / Publicaciones)
                tabSection
               
                // Contenido basado en la tab seleccionada
                contentSection
            }
        }
        .background(Color.backgroundDark)
        .navigationBarHidden(true)
    }
   
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
               
                Spacer()
               
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(90))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.backgroundDark.opacity(0.8))
        }
    }
   
    // MARK: - Cover and Logo Section
    private var coverAndLogoSection: some View {
        ZStack(alignment: .bottomLeading) {
            // Imagen de portada
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.orange]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 180)
                .overlay(
                    // Patrón geométrico simulado
                    VStack {
                        HStack {
                            Spacer()
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 60, height: 60)
                                .offset(x: 20, y: -10)
                        }
                        Spacer()
                        HStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.05))
                                .frame(width: 100, height: 20)
                                .cornerRadius(10)
                            Spacer()
                        }
                        .offset(x: -10, y: 20)
                    }
                )
           
            // Logo de la empresa
            HStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text("I")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.backgroundDark, lineWidth: 4)
                    )
                    .offset(y: 50)
               
                Spacer()
            }
            .padding(.leading, 16)
        }
    }
   
    // MARK: - Company Info Section
    private var companyInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Text("Innovate Corp")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
               
                // Badge Premium
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 24, height: 24)
                   
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
           
            Text("San Francisco, CA • Tecnología")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 60)
    }
   
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            Button(action: {}) {
                Text("Seguir")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.primaryOrange)
                    .cornerRadius(8)
            }
           
            Button(action: {}) {
                Text("Mensaje")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
   
    // MARK: - Tab Section
    private var tabSection: some View {
        VStack(spacing: 0) {
            HStack {
                TabButton(title: "Acerca de", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
               
                TabButton(title: "Publicaciones", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
            }
           
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .padding(.top, 20)
        .background(Color.backgroundDark)
    }
   
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 20) {
            if selectedTab == 0 {
                aboutSection
            } else {
                publicationsSection
            }
        }
        .padding(.top, 20)
        .background(Color.backgroundLight.opacity(0.05))
    }
   
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(spacing: 20) {
            // Información de la empresa
            VStack(alignment: .leading, spacing: 16) {
                Text("Acerca de Innovate Corp")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
               
                VStack(alignment: .leading, spacing: 8) {
                    Text("Somos una empresa tecnológica de vanguardia dedicada a construir el futuro de la inteligencia artificial. Nuestra misión es empoderar a empresas e individuos a través de soluciones de software innovadoras.")
                        .font(.body)
                        .foregroundColor(.textSecondary)
                   
                    Button("Leer más") {
                        // Acción para leer más
                    }
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryOrange)
                }
               
                // Grid de estadísticas
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatCard2(icon: "person.3.fill", value: "500+", label: "Empleados")
                    StatCard2(icon: "calendar", value: "2015", label: "Fundada")
                    StatCard2(icon: "location.fill", value: "Centro SF", label: "Oficina Principal")
                    StatCard2(icon: "phone.fill", value: "+1 (555) 123-4567", label: "Contacto")
                }
                .padding(.top, 8)
               
                // Información de contacto
                VStack(alignment: .leading, spacing: 12) {
                    ContactRowEmpresa(icon: "location.fill", text: "123 Innovation Drive, Suite 400, San Francisco, CA 94105")
                    ContactRowEmpresa(icon: "clock.fill", text: "Lunes - Viernes: 9:00 AM - 6:00 PM PST")
                   
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "link")
                                .foregroundColor(.primaryOrange)
                            Text("innovatecorp.com")
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryOrange)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .padding(.horizontal, 16)
           
            // Ofertas de trabajo
            jobOffersSection
        }
    }
   
    // MARK: - Job Offers Section
    private var jobOffersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Ofertas y oportunidades")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
               
                Spacer()
               
                Button("Ver Todas") {
                    // Acción para ver todas las ofertas
                }
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.primaryOrange)
            }
            .padding(.horizontal, 16)
           
            VStack(spacing: 12) {
                JobCardEmpresa(
                    title: "Pasante de Ingeniería de Software",
                    location: "San Francisco, CA • Pasantía",
                    description: "Únete a nuestro equipo central de ingeniería para trabajar en productos de IA de próxima generación. Obtén experiencia práctica con modelos de machine learning e infraestructura en la nube."
                )
               
                JobCardEmpresa(
                    title: "Diseñador de Producto",
                    location: "Remoto • Tiempo completo",
                    description: "Da forma a la experiencia del usuario de nuestros productos principales. Serás responsable de todo el proceso de diseño, desde la investigación hasta los prototipos de alta fidelidad."
                )
               
                JobCardEmpresa(
                    title: "Pasante de Ciencia de Datos",
                    location: "San Francisco, CA • Pasantía",
                    description: "Únete a nuestro equipo de data science para analizar grandes volúmenes de datos y desarrollar modelos predictivos. Ideal para estudiantes de ciencias de datos o estadística."
                )
            }
            .padding(.horizontal, 16)
        }
    }
   
    // MARK: - Publications Section
    private var publicationsSection: some View {
        VStack(spacing: 16) {
            Text("Publicaciones")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
           
            Text("Aquí aparecerán las publicaciones de la empresa")
                .font(.body)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 16)
        }
        .padding(.top, 40)
    }
}


// MARK: - Supporting Views


struct TabButton: View {
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


struct StatCard2: View {
    let icon: String
    let value: String
    let label: String
   
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.primaryOrange.opacity(0.1))
                    .frame(width: 40, height: 40)
               
                Image(systemName: icon)
                    .foregroundColor(.primaryOrange)
                    .font(.system(size: 16))
            }
           
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
               
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
           
            Spacer()
        }
    }
}


struct ContactRowEmpresa: View {
    let icon: String
    let text: String
   
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.primaryOrange)
                .font(.system(size: 14))
                .frame(width: 20)
           
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
        }
    }
}


struct JobCardEmpresa: View {
    let title: String
    let location: String
    let description: String
   
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
           
            Text(location)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
           
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .lineLimit(2)
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}


// MARK: - Preview
#Preview {
    NavigationView {
        PerfilEmpresaView()
    }
    .preferredColorScheme(.dark)
}



