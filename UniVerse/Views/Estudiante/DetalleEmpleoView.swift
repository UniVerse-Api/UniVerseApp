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
    @State private var isBookmarked = false
    @State private var showApplicationView = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let job = JobDetail(
        title: "Desarrollador Full Stack Junior",
        company: "Innovate Inc.",
        logoUrl: "building.2.fill",
        location: "San Francisco, CA",
        jobType: "Tiempo Completo",
        postedDate: "Publicado hace 2 días",
        isVerified: true,
        salaryRange: "$80,000 - $100,000 USD",
        salaryDescription: "Salario anual + beneficios",
        description: "Buscamos un Desarrollador Full Stack Junior apasionado por la tecnología para unirse a nuestro equipo dinámico. Trabajarás en proyectos innovadores utilizando las últimas tecnologías web, colaborando con diseñadores y otros desarrolladores para crear aplicaciones web escalables y de alta calidad.",
        additionalDescription: "Esta es una excelente oportunidad para crecer profesionalmente en un ambiente de startup, donde podrás aprender rápidamente y tener un impacto real en el producto final.",
        requirements: [
            "Licenciatura en Ciencias de la Computación o campo relacionado",
            "1-2 años de experiencia en desarrollo web",
            "Experiencia con JavaScript, React, Node.js",
            "Conocimientos de bases de datos SQL y NoSQL",
            "Inglés conversacional"
        ],
        benefits: [
            JobBenefit(icon: "cross.case.fill", title: "Seguro médico completo", color: .blue),
            JobBenefit(icon: "beach.umbrella.fill", title: "20 días de vacaciones al año", color: .green),
            JobBenefit(icon: "graduationcap.fill", title: "Presupuesto para formación y conferencias", color: .purple),
            JobBenefit(icon: "laptopcomputer", title: "Equipo de trabajo moderno", color: .orange)
        ],
        deadline: "15 de Noviembre, 2024",
        companyDescription: "Innovate Inc. es una startup tecnológica líder en el desarrollo de soluciones SaaS para empresas medianas. Fundada en 2020, hemos crecido rápidamente y ahora servimos a más de 10,000 clientes en todo el mundo. Nuestro equipo de 50+ profesionales está comprometido con la innovación y la excelencia tecnológica."
    )
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
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
                        
                        // Company Info
                        companyInfoCard
                        
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
                        .foregroundColor(.white)
                        .padding(8)
                }
                
                Text("Detalle del Empleo")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
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
        .background(Color.backgroundDark.opacity(0.8))
        .backdrop()
    }
    
    // MARK: - Company Header Card
    private var companyHeaderCard: some View {
        HStack(alignment: .top, spacing: 16) {
            // Company Logo
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: 80, height: 80)
                
                Image(systemName: job.logoUrl)
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
            
            // Job Details
            VStack(alignment: .leading, spacing: 8) {
                Text(job.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 6) {
                    Text(job.company)
                        .font(.system(size: 14, weight: .medium))
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
                                .frame(width: 18, height: 18)
                            
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    JobDetailInfoRow(icon: "location.fill", text: job.location)
                    JobDetailInfoRow(icon: "clock.fill", text: job.jobType)
                    JobDetailInfoRow(icon: "calendar", text: job.postedDate)
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
                Text(job.salaryRange)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.green)
                
                Text(job.salaryDescription)
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
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(job.description)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
                
                Text(job.additionalDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
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
    
    // MARK: - Requirements Card
    private var requirementsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "checklist")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Requisitos")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(job.requirements, id: \.self) { requirement in
                    JobRequirementRow(text: requirement)
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
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 10) {
                ForEach(job.benefits) { benefit in
                    JobBenefitRow(benefit: benefit)
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
                
                Text(job.deadline)
                    .font(.system(size: 13))
                    .foregroundColor(.orange.opacity(0.9))
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
    private var companyInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Sobre \(job.company)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(job.companyDescription)
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
        .background(Color.backgroundDark.opacity(0.9))
        .backdrop()
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
        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
        .cornerRadius(8)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        DetalleEmpleoView()
    }
    .preferredColorScheme(.dark)
}
