// Views/Estudiante/GestionarEducacionView.swift
import SwiftUI

// MARK: - Education Models
enum TipoEducacion: String, CaseIterable {
    case licenciatura = "Licenciatura"
    case maestria = "Maestría"
    case doctorado = "Doctorado"
    case certificado = "Certificado"
    case diplomado = "Diplomado"
    case curso = "Curso"
    case bachillerato = "Bachillerato"
    case tecnico = "Técnico"
    
    var color: Color {
        switch self {
        case .licenciatura: return .blue
        case .maestria: return .purple
        case .doctorado: return .indigo
        case .certificado: return .green
        case .diplomado: return .teal
        case .curso: return .orange
        case .bachillerato: return .red
        case .tecnico: return .yellow
        }
    }
    
    var icon: String {
        switch self {
        case .certificado, .diplomado, .curso:
            return "medal.fill"
        default:
            return "graduationcap.fill"
        }
    }
}

struct EducacionItem: Identifiable {
    let id = UUID()
    var tipo: TipoEducacion
    var institucion: String
    var campoEstudio: String
    var ubicacion: String
    var fechaInicio: Date
    var fechaFin: Date?
    var gpa: String
    var descripcion: String
    var materias: [String]
    var enCurso: Bool
}

// MARK: - Main View
struct GestionarEducacionView: View {
    @State private var educaciones: [EducacionItem] = [
        EducacionItem(
            tipo: .licenciatura,
            institucion: "Universidad Estatal",
            campoEstudio: "Licenciatura en Ciencias de la Computación",
            ubicacion: "University City, CA",
            fechaInicio: Calendar.current.date(from: DateComponents(year: 2021, month: 9))!,
            fechaFin: Calendar.current.date(from: DateComponents(year: 2025, month: 6)),
            gpa: "3.8/4.0",
            descripcion: "Enfoque en desarrollo de software, inteligencia artificial y algoritmos. Participación activa en proyectos de investigación y hackathons universitarios.",
            materias: ["Algoritmos", "Estructuras de Datos", "Inteligencia Artificial", "Bases de Datos"],
            enCurso: true
        ),
        EducacionItem(
            tipo: .certificado,
            institucion: "Instituto Tecnológico de San Francisco",
            campoEstudio: "Certificado en Desarrollo Web Full Stack",
            ubicacion: "San Francisco, CA",
            fechaInicio: Calendar.current.date(from: DateComponents(year: 2020, month: 1))!,
            fechaFin: Calendar.current.date(from: DateComponents(year: 2021, month: 12)),
            gpa: "",
            descripcion: "Programa intensivo de 12 meses enfocado en tecnologías web modernas. Proyecto final: aplicación e-commerce completa con React y Node.js.",
            materias: ["HTML/CSS", "JavaScript", "React", "Node.js", "MongoDB"],
            enCurso: false
        )
    ]
    
    @State private var showingEducacionModal = false
    @State private var editingEducacion: EducacionItem?
    @State private var editingIndex: Int?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                
                // MARK: - Content
                if educaciones.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(educaciones.indices, id: \.self) { index in
                                EducacionCard(
                                    educacion: educaciones[index],
                                    onEdit: {
                                        editingEducacion = educaciones[index]
                                        editingIndex = index
                                        showingEducacionModal = true
                                    },
                                    onDelete: {
                                        deleteEducacion(at: index)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .padding(.bottom, 80)
                    }
                    .background(Color(red: 15/255, green: 23/255, blue: 42/255).opacity(0.3))
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEducacionModal) {
            EducacionModalView(
                educacion: editingEducacion,
                onSave: { nuevaEducacion in
                    if let index = editingIndex {
                        educaciones[index] = nuevaEducacion
                    } else {
                        educaciones.append(nuevaEducacion)
                    }
                    editingEducacion = nil
                    editingIndex = nil
                }
            )
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                }
                
                Spacer()
                
                Text("Mi Educación")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    editingEducacion = nil
                    editingIndex = nil
                    showingEducacionModal = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Agregar")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.primaryOrange)
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
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.textSecondary)
            }
            
            Text("No tienes formación académica agregada")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Comienza agregando tu educación formal, certificaciones o cursos")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                editingEducacion = nil
                editingIndex = nil
                showingEducacionModal = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Agregar Primera Formación")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.primaryOrange)
                .cornerRadius(8)
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
    
    // MARK: - Delete Function
    private func deleteEducacion(at index: Int) {
        educaciones.remove(at: index)
    }
}

// MARK: - Education Card
struct EducacionCard: View {
    let educacion: EducacionItem
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(educacion.tipo.color.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: educacion.tipo.icon)
                        .font(.system(size: 24))
                        .foregroundColor(educacion.tipo.color)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(educacion.institucion)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(educacion.campoEstudio)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: 4) {
                        Text(yearRangeString)
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                        
                        if !educacion.ubicacion.isEmpty {
                            Text("•")
                                .foregroundColor(.textSecondary)
                            Text(educacion.ubicacion)
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    // Badges
                    HStack(spacing: 6) {
                        BadgeEducacion(
                            text: educacion.tipo.rawValue,
                            color: educacion.tipo.color
                        )
                        
                        BadgeEducacion(
                            text: educacion.enCurso ? "En Curso" : "Completado",
                            color: educacion.enCurso ? .green : .gray
                        )
                        
                        if !educacion.gpa.isEmpty {
                            BadgeEducacion(
                                text: "GPA: \(educacion.gpa)",
                                color: .primaryOrange
                            )
                        }
                    }
                }
                
                Spacer()
                
                // Actions
                VStack(spacing: 8) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                            .frame(width: 32, height: 32)
                    }
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            
            // Description
            if !educacion.descripcion.isEmpty {
                Text(educacion.descripcion)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
            
            // Subjects
            if !educacion.materias.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(educacion.materias, id: \.self) { materia in
                            Text(materia)
                                .font(.system(size: 11))
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
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
        .alert("Eliminar Formación", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Eliminar", role: .destructive, action: onDelete)
        } message: {
            Text("¿Estás seguro de que deseas eliminar esta formación académica?")
        }
    }
    
    private var yearRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let inicio = formatter.string(from: educacion.fechaInicio)
        let fin = educacion.fechaFin.map { formatter.string(from: $0) } ?? "Actual"
        return "\(inicio) - \(fin)"
    }
}

// MARK: - Badge Component
struct BadgeEducacion: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .cornerRadius(12)
    }
}

// MARK: - Education Modal
struct EducacionModalView: View {
    @Environment(\.dismiss) var dismiss
    
    let educacion: EducacionItem?
    let onSave: (EducacionItem) -> Void
    
    @State private var tipoSeleccionado: TipoEducacion = .licenciatura
    @State private var institucion = ""
    @State private var campoEstudio = ""
    @State private var ubicacion = ""
    @State private var fechaInicio = Date()
    @State private var fechaFin = Date()
    @State private var gpa = ""
    @State private var descripcion = ""
    @State private var materias: [String] = []
    @State private var nuevaMateria = ""
    @State private var enCurso = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Tipo de Formación
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tipo de Formación *")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                            
                            Menu {
                                ForEach(TipoEducacion.allCases, id: \.self) { tipo in
                                    Button(action: {
                                        tipoSeleccionado = tipo
                                    }) {
                                        HStack {
                                            Text(tipo.rawValue)
                                            if tipoSeleccionado == tipo {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(tipoSeleccionado.rawValue)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                }
                                .padding(12)
                                .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.borderColor, lineWidth: 1)
                                )
                            }
                        }
                        
                        // Institución
                        InputFieldEducacion(
                            title: "Institución *",
                            placeholder: "ej. Universidad Nacional",
                            text: $institucion
                        )
                        
                        // Campo de Estudio
                        InputFieldEducacion(
                            title: "Campo de Estudio *",
                            placeholder: "ej. Ingeniería en Sistemas",
                            text: $campoEstudio
                        )
                        
                        // Fechas
                        VStack(spacing: 12) {
                            DatePickerEducacion(
                                title: "Fecha de Inicio *",
                                date: $fechaInicio
                            )
                            
                            if !enCurso {
                                DatePickerEducacion(
                                    title: "Fecha de Fin",
                                    date: $fechaFin
                                )
                            }
                            
                            Toggle(isOn: $enCurso) {
                                Text("En curso")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                            }
                            .tint(.primaryOrange)
                        }
                        
                        // GPA y Ubicación
                        HStack(spacing: 12) {
                            InputFieldEducacion(
                                title: "Promedio/Calificación",
                                placeholder: "ej. 3.8/4.0",
                                text: $gpa
                            )
                            
                            InputFieldEducacion(
                                title: "Ubicación",
                                placeholder: "Ciudad, País",
                                text: $ubicacion
                            )
                        }
                        
                        // Descripción
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Descripción")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                            
                            TextEditor(text: $descripcion)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.borderColor, lineWidth: 1)
                                )
                        }
                        
                        // Materias
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Materias/Habilidades Relevantes")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                            
                            HStack(spacing: 8) {
                                TextField("ej. Algoritmos, Bases de Datos...", text: $nuevaMateria)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                                    .onSubmit {
                                        addMateria()
                                    }
                                
                                Button(action: addMateria) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                            
                            if !materias.isEmpty {
                                FlowLayout(spacing: 6) {
                                    ForEach(materias, id: \.self) { materia in
                                        HStack(spacing: 4) {
                                            Text(materia)
                                                .font(.system(size: 11))
                                                .foregroundColor(.primaryOrange)
                                            
                                            Button(action: {
                                                materias.removeAll { $0 == materia }
                                            }) {
                                                Image(systemName: "xmark")
                                                    .font(.system(size: 8, weight: .bold))
                                                    .foregroundColor(.primaryOrange)
                                            }
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.primaryOrange.opacity(0.2))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        
                        // Buttons
                        HStack(spacing: 12) {
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Cancelar")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            Button(action: guardar) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("Guardar")
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.primaryOrange)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(16)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(educacion == nil ? "Agregar Formación" : "Editar Formación")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .alert("Campo Requerido", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                if let educacion = educacion {
                    tipoSeleccionado = educacion.tipo
                    institucion = educacion.institucion
                    campoEstudio = educacion.campoEstudio
                    ubicacion = educacion.ubicacion
                    fechaInicio = educacion.fechaInicio
                    fechaFin = educacion.fechaFin ?? Date()
                    gpa = educacion.gpa
                    descripcion = educacion.descripcion
                    materias = educacion.materias
                    enCurso = educacion.enCurso
                }
            }
        }
    }
    
    private func addMateria() {
        let materia = nuevaMateria.trimmingCharacters(in: .whitespacesAndNewlines)
        if !materia.isEmpty && !materias.contains(materia) {
            materias.append(materia)
            nuevaMateria = ""
        }
    }
    
    private func guardar() {
        guard !institucion.isEmpty else {
            alertMessage = "Por favor ingresa la institución"
            showingAlert = true
            return
        }
        
        guard !campoEstudio.isEmpty else {
            alertMessage = "Por favor ingresa el campo de estudio"
            showingAlert = true
            return
        }
        
        let nuevaEducacion = EducacionItem(
            tipo: tipoSeleccionado,
            institucion: institucion,
            campoEstudio: campoEstudio,
            ubicacion: ubicacion,
            fechaInicio: fechaInicio,
            fechaFin: enCurso ? nil : fechaFin,
            gpa: gpa,
            descripcion: descripcion,
            materias: materias,
            enCurso: enCurso
        )
        
        onSave(nuevaEducacion)
        dismiss()
    }
}

// MARK: - Input Field Component
struct InputFieldEducacion: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textSecondary)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(12)
                .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.borderColor, lineWidth: 1)
                )
        }
    }
}

// MARK: - Date Picker Component
struct DatePickerEducacion: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textSecondary)
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .colorScheme(.dark)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.borderColor, lineWidth: 1)
                )
        }
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
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
        var size: CGSize = .zero
        var frames: [CGRect] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(origin: CGPoint(x: currentX, y: currentY), size: size))
                
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        GestionarEducacionView()
    }
    .preferredColorScheme(.dark)
}
