// Views/Estudiante/GestionarExperienciaView.swift
import SwiftUI

// MARK: - Experience Models
enum TipoExperiencia: String, CaseIterable {
    case pasantia = "Pasantía"
    case tiempoCompleto = "Tiempo Completo"
    case medioTiempo = "Medio Tiempo"
    case voluntariado = "Voluntariado"
    case investigacion = "Investigación"
    
    var color: Color {
        switch self {
        case .pasantia: return .green
        case .tiempoCompleto: return .blue
        case .medioTiempo: return .purple
        case .voluntariado: return .pink
        case .investigacion: return .orange
        }
    }
    
    var icon: String {
        switch self {
        case .investigacion:
            return "flask.fill"
        default:
            return "briefcase.fill"
        }
    }
}

struct ExperienciaItem: Identifiable {
    let id = UUID()
    var tipo: TipoExperiencia
    var puesto: String
    var empresa: String
    var ubicacion: String
    var fechaInicio: Date
    var fechaFin: Date?
    var descripcion: String
    var habilidades: [String]
    var trabajoActual: Bool
}

// MARK: - Main View
struct GestionarExperienciaView: View {
    @State private var experiencias: [ExperienciaItem] = [
        ExperienciaItem(
            tipo: .pasantia,
            puesto: "Pasante de Ingeniería de Software",
            empresa: "Tech Solutions Inc.",
            ubicacion: "San Francisco, CA",
            fechaInicio: Calendar.current.date(from: DateComponents(year: 2023, month: 6))!,
            fechaFin: Calendar.current.date(from: DateComponents(year: 2023, month: 8)),
            descripcion: "Desarrollé componentes frontend utilizando React y TypeScript, colaboré en la implementación de APIs RESTful con Node.js, y participé en revisiones de código y metodologías ágiles.",
            habilidades: ["React", "TypeScript", "Node.js", "Git"],
            trabajoActual: false
        ),
        ExperienciaItem(
            tipo: .investigacion,
            puesto: "Asistente de Investigación",
            empresa: "Lab de IA - Universidad Estatal",
            ubicacion: "University City, CA",
            fechaInicio: Calendar.current.date(from: DateComponents(year: 2022, month: 9))!,
            fechaFin: Calendar.current.date(from: DateComponents(year: 2023, month: 5)),
            descripcion: "Colaboré en investigaciones de Machine Learning para análisis predictivo, implementé algoritmos de clasificación en Python, y publiqué resultados en conferencias académicas.",
            habilidades: ["Python", "Machine Learning", "TensorFlow", "Pandas"],
            trabajoActual: false
        )
    ]
    
    @State private var showingExperienciaModal = false
    @State private var editingExperiencia: ExperienciaItem?
    @State private var editingIndex: Int?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                
                // MARK: - Content
                if experiencias.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(experiencias.indices, id: \.self) { index in
                                ExperienciaCard(
                                    experiencia: experiencias[index],
                                    onEdit: {
                                        editingExperiencia = experiencias[index]
                                        editingIndex = index
                                        showingExperienciaModal = true
                                    },
                                    onDelete: {
                                        deleteExperiencia(at: index)
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
        .sheet(isPresented: $showingExperienciaModal) {
            ExperienciaModalView(
                experiencia: editingExperiencia,
                onSave: { nuevaExperiencia in
                    if let index = editingIndex {
                        experiencias[index] = nuevaExperiencia
                    } else {
                        experiencias.append(nuevaExperiencia)
                    }
                    editingExperiencia = nil
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
                
                Text("Mi Experiencia")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    editingExperiencia = nil
                    editingIndex = nil
                    showingExperienciaModal = true
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
                
                Image(systemName: "briefcase.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.textSecondary)
            }
            
            Text("No tienes experiencias agregadas")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Comienza agregando tu primera experiencia laboral o de investigación")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                editingExperiencia = nil
                editingIndex = nil
                showingExperienciaModal = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Agregar Primera Experiencia")
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
    private func deleteExperiencia(at index: Int) {
        experiencias.remove(at: index)
    }
}

// MARK: - Experience Card
struct ExperienciaCard: View {
    let experiencia: ExperienciaItem
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(experiencia.tipo.color.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: experiencia.tipo.icon)
                        .font(.system(size: 24))
                        .foregroundColor(experiencia.tipo.color)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(experiencia.puesto)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(experiencia.empresa)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: 4) {
                        Text(dateRangeString)
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                        
                        if !experiencia.ubicacion.isEmpty {
                            Text("•")
                                .foregroundColor(.textSecondary)
                            Text(experiencia.ubicacion)
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    // Badge
                    BadgeExperiencia(
                        text: experiencia.tipo.rawValue,
                        color: experiencia.tipo.color
                    )
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
            if !experiencia.descripcion.isEmpty {
                Text(experiencia.descripcion)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
            
            // Skills
            if !experiencia.habilidades.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(experiencia.habilidades, id: \.self) { habilidad in
                            Text(habilidad)
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
        .alert("Eliminar Experiencia", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Eliminar", role: .destructive, action: onDelete)
        } message: {
            Text("¿Estás seguro de que deseas eliminar esta experiencia?")
        }
    }
    
    private var dateRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        
        let inicio = formatter.string(from: experiencia.fechaInicio)
        let fin = experiencia.fechaFin.map { formatter.string(from: $0) } ?? "Actual"
        return "\(inicio) - \(fin)"
    }
}

// MARK: - Badge Component
struct BadgeExperiencia: View {
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

// MARK: - Experience Modal
struct ExperienciaModalView: View {
    @Environment(\.dismiss) var dismiss
    
    let experiencia: ExperienciaItem?
    let onSave: (ExperienciaItem) -> Void
    
    @State private var tipoSeleccionado: TipoExperiencia = .pasantia
    @State private var puesto = ""
    @State private var empresa = ""
    @State private var ubicacion = ""
    @State private var fechaInicio = Date()
    @State private var fechaFin = Date()
    @State private var descripcion = ""
    @State private var habilidades: [String] = []
    @State private var nuevaHabilidad = ""
    @State private var trabajoActual = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Tipo de Experiencia
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tipo de Experiencia *")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                            
                            Menu {
                                ForEach(TipoExperiencia.allCases, id: \.self) { tipo in
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
                        
                        // Puesto y Empresa
                        HStack(spacing: 12) {
                            InputFieldExperiencia(
                                title: "Puesto *",
                                placeholder: "ej. Desarrollador Frontend",
                                text: $puesto
                            )
                            
                            InputFieldExperiencia(
                                title: "Empresa/Institución *",
                                placeholder: "ej. Google Inc.",
                                text: $empresa
                            )
                        }
                        
                        // Ubicación
                        InputFieldExperiencia(
                            title: "Ubicación",
                            placeholder: "ej. San Francisco, CA",
                            text: $ubicacion
                        )
                        
                        // Fechas
                        VStack(spacing: 12) {
                            DatePickerExperiencia(
                                title: "Fecha de Inicio *",
                                date: $fechaInicio
                            )
                            
                            if !trabajoActual {
                                DatePickerExperiencia(
                                    title: "Fecha de Fin",
                                    date: $fechaFin
                                )
                            }
                            
                            Toggle(isOn: $trabajoActual) {
                                Text("Trabajo actual")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                            }
                            .tint(.primaryOrange)
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
                        
                        // Habilidades
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tecnologías/Habilidades Utilizadas")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                            
                            HStack(spacing: 8) {
                                TextField("ej. Python, JavaScript, React...", text: $nuevaHabilidad)
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
                                        addHabilidad()
                                    }
                                
                                Button(action: addHabilidad) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                            
                            if !habilidades.isEmpty {
                                FlowLayoutExp(spacing: 6) {
                                    ForEach(habilidades, id: \.self) { habilidad in
                                        HStack(spacing: 4) {
                                            Text(habilidad)
                                                .font(.system(size: 11))
                                                .foregroundColor(.primaryOrange)
                                            
                                            Button(action: {
                                                habilidades.removeAll { $0 == habilidad }
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
            .navigationTitle(experiencia == nil ? "Agregar Experiencia" : "Editar Experiencia")
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
                if let experiencia = experiencia {
                    tipoSeleccionado = experiencia.tipo
                    puesto = experiencia.puesto
                    empresa = experiencia.empresa
                    ubicacion = experiencia.ubicacion
                    fechaInicio = experiencia.fechaInicio
                    fechaFin = experiencia.fechaFin ?? Date()
                    descripcion = experiencia.descripcion
                    habilidades = experiencia.habilidades
                    trabajoActual = experiencia.trabajoActual
                }
            }
        }
    }
    
    private func addHabilidad() {
        let habilidad = nuevaHabilidad.trimmingCharacters(in: .whitespacesAndNewlines)
        if !habilidad.isEmpty && !habilidades.contains(habilidad) {
            habilidades.append(habilidad)
            nuevaHabilidad = ""
        }
    }
    
    private func guardar() {
        guard !puesto.isEmpty else {
            alertMessage = "Por favor ingresa el puesto"
            showingAlert = true
            return
        }
        
        guard !empresa.isEmpty else {
            alertMessage = "Por favor ingresa la empresa o institución"
            showingAlert = true
            return
        }
        
        let nuevaExperiencia = ExperienciaItem(
            tipo: tipoSeleccionado,
            puesto: puesto,
            empresa: empresa,
            ubicacion: ubicacion,
            fechaInicio: fechaInicio,
            fechaFin: trabajoActual ? nil : fechaFin,
            descripcion: descripcion,
            habilidades: habilidades,
            trabajoActual: trabajoActual
        )
        
        onSave(nuevaExperiencia)
        dismiss()
    }
}

// MARK: - Input Field Component
struct InputFieldExperiencia: View {
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
struct DatePickerExperiencia: View {
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

// MARK: - Flow Layout for Experience
struct FlowLayoutExp: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResultExp(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResultExp(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResultExp {
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
        GestionarExperienciaView()
    }
    .preferredColorScheme(.dark)
}
