
// Views/Empresa/PublicarOfertaEmpleoView.swift
import SwiftUI

struct PublicarOfertaEmpleoView: View {
    @State private var jobTitle = ""
    @State private var location = ""
    @State private var jobType = ""
    @State private var applicationDeadline = Date()
    @State private var salaryRange = ""
    @State private var generalDescription = ""
    @State private var keyResponsibilities = ""
    @State private var mandatoryRequirements = ""
    @State private var desirableSkills = ""
    
    @State private var selectedBenefits: Set<String> = []
    @State private var isDraft = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let benefits = [
        "Seguro médico",
        "Vacaciones pagadas",
        "Formación continua",
        "Equipo de trabajo",
        "Trabajo remoto",
        "Bonos por desempeño"
    ]
    
    let jobTypes = ["Tiempo Completo", "Medio Tiempo", "Pasantía"]
    
    // Colores exactos del HTML
    let colorPrimary = Color(red: 255/255, green: 140/255, blue: 0/255) // #FF8C00
    let colorSecondary = Color(red: 255/255, green: 182/255, blue: 52/255) // #FFB634
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                
                // MARK: - Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Company Preview
                        companyPreviewSection
                        
                        // Basic Information
                        basicInformationSection
                        
                        // Salary & Compensation
                        compensationSection
                        
                        // Job Description
                        descriptionSection
                        
                        // Requirements
                        requirementsSection
                        
                        // Preview Info
                        previewInfoSection
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
            
            // MARK: - Publish Button
            VStack {
                Spacer()
                publishButtonSection
            }
        }
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
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text("Publicar Empleo")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    isDraft = true
                }) {
                    Text("Borrador")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
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
        .background(Color.backgroundDark)
    }
    
    // MARK: - Company Preview Section
    private var companyPreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                    
                    Text("I")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("Innovate Corp")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        
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
                    
                    Text("Empresa de Tecnología")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
            
            // Info Banner
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                
                Text("Esta oferta se publicará bajo tu empresa y será visible para todos los estudiantes.")
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                    .lineLimit(3)
            }
            .padding(12)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    
    // MARK: - Basic Information Section
    private var basicInformationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "briefcase.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Información Básica")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                // Job Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Título del Puesto *")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    TextField("ej. Desarrollador Full Stack Junior", text: $jobTitle)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                }
                
                // Location
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ubicación *")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    TextField("ej. San Francisco, CA", text: $location)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                }
                
                // Job Type
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tipo de Trabajo *")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    Menu {
                        ForEach(jobTypes, id: \.self) { type in
                            Button(type) {
                                jobType = type
                            }
                        }
                    } label: {
                        HStack {
                            Text(jobType.isEmpty ? "Selecciona tipo" : jobType)
                                .font(.system(size: 14))
                                .foregroundColor(jobType.isEmpty ? .textSecondary : .white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                    }
                }
                
                // Application Deadline
                VStack(alignment: .leading, spacing: 8) {
                    Text("Fecha Límite de Aplicación")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    HStack {
                        DatePicker("", selection: $applicationDeadline, displayedComponents: .date)
                            .labelsHidden()
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.backgroundLight.opacity(0.05))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.borderColor, lineWidth: 1)
                    )
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    
    // MARK: - Compensation Section
    private var compensationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.green)
                
                Text("Compensación y Beneficios")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                // Salary Range
                VStack(alignment: .leading, spacing: 8) {
                    Text("Rango Salarial *")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    TextField("ej. $80,000 - $100,000 USD", text: $salaryRange)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                }
                
                // Benefits
                VStack(alignment: .leading, spacing: 10) {
                    Text("Beneficios Adicionales")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    VStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { row in
                            HStack(spacing: 12) {
                                ForEach(0..<2, id: \.self) { col in
                                    let index = row * 2 + col
                                    if index < benefits.count {
                                        BenefitCheckbox(
                                            title: benefits[index],
                                            isSelected: selectedBenefits.contains(benefits[index]),
                                            action: {
                                                if selectedBenefits.contains(benefits[index]) {
                                                    selectedBenefits.remove(benefits[index])
                                                } else {
                                                    selectedBenefits.insert(benefits[index])
                                                }
                                            }
                                        )
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    } else {
                                        Spacer()
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Descripción del Puesto")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                // General Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descripción General *")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    TextEditor(text: $generalDescription)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(height: 100)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                }
                
                // Key Responsibilities
                VStack(alignment: .leading, spacing: 8) {
                    Text("Responsabilidades Clave")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    TextEditor(text: $keyResponsibilities)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(height: 80)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    
    // MARK: - Requirements Section
    private var requirementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primaryOrange)
                
                Text("Requisitos")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                // Mandatory Requirements
                VStack(alignment: .leading, spacing: 8) {
                    Text("Requisitos Obligatorios *")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    TextEditor(text: $mandatoryRequirements)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(height: 100)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                }
                
                // Desirable Skills
                VStack(alignment: .leading, spacing: 8) {
                    Text("Habilidades Deseables")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    TextEditor(text: $desirableSkills)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(height: 80)
                        .background(Color.backgroundLight.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderColor, lineWidth: 1)
                        )
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    
    // MARK: - Preview Info Section
    private var previewInfoSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "eye.fill")
                .font(.system(size: 16))
                .foregroundColor(.orange)
            
            Text("Tu oferta de trabajo será visible para más de 10,000 estudiantes y graduados en nuestra plataforma. Asegúrate de que toda la información sea precisa antes de publicar.")
                .font(.system(size: 13))
                .foregroundColor(.orange)
                .lineLimit(5)
        }
        .padding(12)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Publish Button Section
    private var publishButtonSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                        
                        Text("Publicar Oferta")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.primaryOrange)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.backgroundDark.opacity(0.8))
            .backdrop()
        }
    }
}

// MARK: - Supporting Views

struct BenefitCheckbox: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? .primaryOrange : .textSecondary)
                
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

extension View {
    func backdrop() -> some View {
        self.background(
            Color.black.opacity(0.5)
                .ignoresSafeArea()
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        PublicarOfertaEmpleoView()
    }
    .preferredColorScheme(.dark)
}
