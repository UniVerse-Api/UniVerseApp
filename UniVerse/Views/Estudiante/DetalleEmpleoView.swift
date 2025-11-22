// Views/Estudiante/DetalleEmpleoView.swift
import SwiftUI

struct JobDetail {
    let title: String
    let company: String
    let logoUrl: String
    let location: String
    let jobType: String
    let postedDate: String
    let isVerified: Bool
    let salaryRange: String
    let salaryDescription: String
    let description: String
    let additionalDescription: String
    let requirements: [String]
    let benefits: [JobBenefit]
    let deadline: String
    let companyDescription: String
}

struct JobBenefit: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let color: Color
}

struct DetalleEmpleoView: View {
    let oferta: OfertaEstudiante
    
    @State private var isBookmarked = false
    @State private var showApplicationView = false
    @State private var beneficios: [String] = []
    @State private var isLoadingBeneficios = false
    
    @StateObject private var ofertaService = OfertaService()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.backgroundLight.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                jobDetailHeader
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Company Header Card
                        companyHeaderCard
                        
                        // Salary & Benefits
                        salaryCard
                        
                        // Job Description
                        jobDescriptionCard
                        
                        // Requirements
                        requirementsCard
                        
                        // Benefits
                        benefitsCard
                        
                        // Application Deadline
                        deadlineCard
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
            
            // Fixed Apply Button
            VStack {
                Spacer()
                applyButton
            }
        }
        .navigationBarHidden(true)
        .task {
            await loadBeneficios()
        }
    }
    
    // MARK: - Header Section
    private var jobDetailHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .foregroundColor(.textPrimary)
                        .padding(8)
                }
                
                HStack(spacing: 8) {
                    Text("Detalle del Empleo")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Image(systemName: "briefcase.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button(action: {
                    isBookmarked.toggle()
                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18))
                        .foregroundColor(isBookmarked ? .primaryOrange : .textSecondary)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
        }
        .background(Color.cardBackground.opacity(0.95))
        .backdrop()
    }
    
    // MARK: - Company Header Card
    private var companyHeaderCard: some View {
        HStack(alignment: .top, spacing: 16) {
            // Company Logo - Clickeable para ir al perfil
            NavigationLink(destination: PerfilEmpresaView(idPerfil: oferta.idPerfilEmpresa)) {
                if let fotoPerfil = oferta.fotoPerfil, !fotoPerfil.isEmpty {
                    AsyncImage(url: URL(string: fotoPerfil)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "building.2.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.borderColor, lineWidth: 1)
                    )
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                }
            }
            
            // Job Details
            VStack(alignment: .leading, spacing: 8) {
                Text(oferta.titulo)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                HStack(spacing: 6) {
                    Text(oferta.nombreCompleto)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    // Verificación badge (opcional, puedes agregarlo si tienes ese campo)
                    if oferta.esPremium {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 18, height: 18)
                            
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    JobDetailInfoRow(icon: "location.fill", text: oferta.ubicacion)
                    JobDetailInfoRow(icon: "clock.fill", text: oferta.tipoOferta.displayName)
                    JobDetailInfoRow(icon: "calendar", text: formatPublicationDate(oferta.fechaPublicacion))
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Salary Card
    private var salaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "banknote.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.green)
                
                Text("Compensación")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(oferta.salarioRango)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.green)
                
                Text("Rango salarial")
                    .font(.system(size: 13))
                    .foregroundColor(.green.opacity(0.9))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.green.opacity(0.1),
                    Color.green.opacity(0.15)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Job Description Card
    private var jobDescriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Descripción del Puesto")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            Text(oferta.descripcion)
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Requirements Card
    private var requirementsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "checklist")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Requisitos")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(oferta.requisitos, id: \.self) { requisito in
                    JobRequirementRow(text: requisito)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Benefits Card
    private var benefitsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "gift.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Beneficios")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            if isLoadingBeneficios {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(.vertical, 20)
                    Spacer()
                }
            } else if beneficios.isEmpty {
                Text("No se especificaron beneficios para esta oferta")
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                    .italic()
            } else {
                VStack(spacing: 10) {
                    ForEach(Array(beneficios.enumerated()), id: \.offset) { index, beneficio in
                        SimpleBenefitRow(text: beneficio, index: index)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
    
    // MARK: - Deadline Card
    private var deadlineCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.fill")
                .font(.system(size: 22))
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Fecha límite para aplicar")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.orange)
                
                if let fechaLimite = oferta.fechaLimite {
                    Text(formatDeadline(fechaLimite))
                        .font(.system(size: 13))
                        .foregroundColor(.orange.opacity(0.9))
                } else {
                    Text("Sin fecha límite especificada")
                        .font(.system(size: 13))
                        .foregroundColor(.orange.opacity(0.9))
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.1),
                    Color.orange.opacity(0.15)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Company Info Card
   
    
    // MARK: - Apply Button
    private var applyButton: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 1)
            
            Button(action: {
                showApplicationView = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "paperplane.fill")
                    Text("Aplicar Ahora")
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.primaryOrange)
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.cardBackground.opacity(0.95))
        .backdrop()
    }
    
    // MARK: - Helper Methods
    private func loadBeneficios() async {
        isLoadingBeneficios = true
        do {
            beneficios = try await ofertaService.getBeneficios(idOferta: oferta.id)
        } catch {
            print("Error loading beneficios: \(error)")
            beneficios = []
        }
        isLoadingBeneficios = false
    }
    
    private func formatPublicationDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: date, to: now)
        
        if let days = components.day {
            if days == 0 {
                return "Publicado hoy"
            } else if days == 1 {
                return "Publicado hace 1 día"
            } else if days < 7 {
                return "Publicado hace \(days) días"
            } else if days < 30 {
                let weeks = days / 7
                return "Publicado hace \(weeks) semana\(weeks > 1 ? "s" : "")"
            } else {
                let months = days / 30
                return "Publicado hace \(months) mes\(months > 1 ? "es" : "")"
            }
        }
        
        return "Publicado hace tiempo"
    }
    
    private func formatDeadline(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
}

// MARK: - Simple Benefit Row Component
struct SimpleBenefitRow: View {
    let text: String
    let index: Int
    
    private var benefitIcon: String {
        let lowercasedText = text.lowercased()
        
        // Seguro médico / salud
        if lowercasedText.contains("seguro") || lowercasedText.contains("médico") ||
           lowercasedText.contains("medico") || lowercasedText.contains("salud") {
            return "cross.case.fill"
        }
        // Vacaciones
        else if lowercasedText.contains("vacacion") || lowercasedText.contains("días libres") ||
                lowercasedText.contains("dias libres") {
            return "beach.umbrella.fill"
        }
        // Formación / capacitación / educación
        else if lowercasedText.contains("formación") || lowercasedText.contains("formacion") ||
                lowercasedText.contains("capacitación") || lowercasedText.contains("capacitacion") ||
                lowercasedText.contains("educación") || lowercasedText.contains("educacion") ||
                lowercasedText.contains("curso") || lowercasedText.contains("entrenamiento") {
            return "graduationcap.fill"
        }
        // Por defecto
        else {
            return "checkmark.circle.fill"
        }
    }
    
    private var benefitColor: Color {
        let colors: [Color] = [.blue, .green, .purple, .orange, .pink, .cyan]
        return colors[index % colors.count]
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: benefitIcon)
                .font(.system(size: 18))
                .foregroundColor(benefitColor)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
            
            Spacer()
        }
        .padding(12)
        .background(Color.backgroundLight)
        .cornerRadius(8)
    }
}

// MARK: - Job Detail Info Row Component
struct JobDetailInfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Job Requirement Row Component
struct JobRequirementRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(.green)
            
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
                .lineSpacing(2)
            
            Spacer()
        }
    }
}

// MARK: - Job Benefit Row Component
struct JobBenefitRow: View {
    let benefit: JobBenefit
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: benefit.icon)
                .font(.system(size: 18))
                .foregroundColor(benefit.color)
                .frame(width: 24, height: 24)
            
            Text(benefit.title)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
            
            Spacer()
        }
        .padding(12)
        .background(Color.backgroundLight)
        .cornerRadius(8)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        DetalleEmpleoView(oferta: OfertaEstudiante(
            id: 1,
            titulo: "Desarrollador iOS Junior",
            descripcion: "Buscamos un desarrollador iOS apasionado para unirse a nuestro equipo. Trabajarás en proyectos innovadores utilizando Swift y SwiftUI.",
            salarioRango: "$1,200 - $1,800 USD",
            tipoOferta: .tiempoCompleto,
            ubicacion: "San Salvador, El Salvador",
            fechaPublicacion: Date().addingTimeInterval(-86400 * 2),
            fechaLimite: Date().addingTimeInterval(86400 * 15),
            idPerfilEmpresa: 1,
            nombreCompleto: "Tech Solutions SV",
            fotoPerfil: nil,
            ubicacionEmpresa: "San Salvador, El Salvador",
            requisitos: [
                "Experiencia con Swift y SwiftUI",
                "Conocimientos de UIKit",
                "Inglés intermedio",
                "Trabajo en equipo"
            ],
            esPremium: true
        ))
    }
    .preferredColorScheme(.light)
}
