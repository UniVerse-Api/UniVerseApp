import SwiftUI
// Colores del diseño (coinciden con el html)
fileprivate enum AppColors {
    static let primary = Color(hex: "#FF8C00")
    static let backgroundLight = Color(hex: "#f5f6f8")
    static let backgroundDark = Color(hex: "#0D1117")
}
struct SuscripcionesView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    // Planes para estudiantes: Gratuito, Premium Mensual y Premium Anual (separados)
    private let plans: [Plan] = [
        Plan(id: "free", title: "Gratuito", subtitle: "Por defecto", price: "0 USD / mes", features: [
            "Publicaciones/día": "1",
            "Caracteres publicación": "500",
            "Prioridad búsqueda": "Baja",
            "Anuncios": "Sí",
            "CVs subidos": "1",
            "Max ofertas aplicables": "5"
        ], isActive: true, highlighted: false),
        Plan(id: "premium_monthly", title: "Premium (Mensual)", subtitle: "Pago mensual", price: "2.99 USD / mes", features: [
            "Publicaciones/día": "10",
            "Caracteres publicación": "5000",
            "Prioridad búsqueda": "Alta",
            "Anuncios": "No",
            "CVs subidos": "5",
            "Max ofertas aplicables": "50"
        ], isActive: false, highlighted: true),
        Plan(id: "premium_annual", title: "Premium (Anual)", subtitle: "Pago anual — ahorro", price: "29.99 USD / año", features: [
            "Publicaciones/día": "10",
            "Caracteres publicación": "5000",
            "Prioridad búsqueda": "Alta",
            "Anuncios": "No",
            "CVs subidos": "5",
            "Max ofertas aplicables": "50"
        ], isActive: false, highlighted: true)
    ]
    // force default dark for this view (aplica localmente)
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundDark
                    .ignoresSafeArea()
                content
            }
            .navigationBarHidden(true)
            .accentColor(AppColors.primary)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environment(\.colorScheme, .dark) // aplicar modo oscuro por defecto
    }
    private var content: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 16) {
                    introSection
                    plansList
                    comparisonSection
                    notesSection
                }
                .padding()
            }
            footer
        }
    }
    private var header: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color(.systemGray5).opacity(0.12))
                    .clipShape(Circle())
            }
            Text("Planes y Suscripciones")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Text("Cuenta: plan gratuito")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
        }
        .padding()
        .background(AppColors.backgroundDark)
        .overlay(Divider().background(Color(.separator)), alignment: .bottom)
    }
    private var introSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Elige el plan que te convenga")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Estás en el plan Gratuito. Mejora a Premium para mayor visibilidad, más cargas de CV y prioridad en búsquedas.")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6).opacity(0.06))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 1)
    }
    // iPhone: lista vertical de tarjetas (mobile-first)
    private var plansList: some View {
        VStack(spacing: 12) {
            ForEach(plans) { plan in
                planCard(plan)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    @ViewBuilder
    private func planCard(_ plan: Plan) -> some View {
        let isAnnual = plan.id.contains("annual") || plan.title.lowercased().contains("anual")
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if plan.highlighted {
                        Text("Premium")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppColors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Text(plan.title)
                        .fontWeight(plan.highlighted ? .heavy : .semibold)
                        .foregroundColor(.white)
                    if !plan.subtitle.isEmpty {
                        Text(plan.subtitle)
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
                Spacer()
                Text(plan.price)
                    .font(plan.highlighted ? .title3 : .subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 8) {
                ForEach(plan.features.keys.sorted(), id: \.self) { key in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: symbol(for: plan, key: key))
                            .foregroundColor(plan.highlighted ? AppColors.primary : Color(.systemGray2))
                            .frame(width: 22)
                        VStack(alignment: .leading, spacing: 2) {
                            if let value = plan.features[key] {
                                Text(key + (value.isEmpty ? "" : ":"))
                                    .font(.caption)
                                    .foregroundColor(Color(.secondaryLabel))
                                if !value.isEmpty {
                                    Text(value)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
            }
            if plan.isActive {
                Button(action: {}) {
                    Text("Plan activo")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5).opacity(0.10))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(true)
            } else if plan.highlighted {
                Button(action: { /* abrir pago */ }) {
                    Text("Mejorar a Premium")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                // anual: diseño más marcado (gradiente sutil + borde) para que se parezca al mensual
                if isAnnual {
                    Button(action: {}) {
                        Text("Contactar ventas")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                // ligera elevación y contraste para anual
                                LinearGradient(
                                    colors: [AppColors.backgroundDark.opacity(0.20), AppColors.primary.opacity(0.04)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.primary.opacity(0.22), lineWidth: 1.5)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Button(action: {}) {
                        Text("Contactar ventas")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray5).opacity(0.08))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .background(
            Group {
                if plan.highlighted {
                    LinearGradient(
                        colors: [AppColors.primary.opacity(0.12), AppColors.backgroundDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else if isAnnual {
                    // aplicar gradiente sutil también al card anual para que visualmente vaya con el mensual
                    LinearGradient(
                        colors: [AppColors.backgroundDark.opacity(0.96), AppColors.primary.opacity(0.04)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    Color(.secondarySystemBackground).opacity(colorScheme == .dark ? 0.07 : 1.0)
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    plan.highlighted ? AppColors.primary.opacity(0.30) :
                        (isAnnual ? AppColors.primary.opacity(0.18) : Color(.separator)),
                    lineWidth: plan.highlighted ? 2 : (isAnnual ? 1.5 : 1)
                )
        )
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(plan.highlighted ? 0.16 : (isAnnual ? 0.10 : 0.06)), radius: plan.highlighted ? 8 : (isAnnual ? 5 : 2), x: 0, y: 2)
    }
    private var comparisonSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Comparativa rápida")
                .fontWeight(.bold)
                .foregroundColor(.white)
            // horizontal scroll para móviles + layout fijo por columnas
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(comparisonRows, id: \.0) { row in
                        HStack(spacing: 12) {
                            Text(row.0)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(width: 160, alignment: .leading) // etiqueta
                            Text(row.1)
                                .foregroundColor(Color(.secondaryLabel))
                                .frame(width: 110, alignment: .center) // free
                            // separador vertical pequeño
                            Rectangle()
                                .fill(Color(.separator))
                                .frame(width: 1, height: 18)
                            Text(row.2)
                                .foregroundColor(Color(.secondaryLabel))
                                .frame(width: 110, alignment: .center) // mensual
                            Rectangle()
                                .fill(Color(.separator))
                                .frame(width: 1, height: 18)
                            Text(row.3)
                                .foregroundColor(Color(.secondaryLabel))
                                .frame(width: 110, alignment: .center) // anual
                        }
                        .padding(.vertical, 10)
                        if row.0 != comparisonRows.last?.0 {
                            Divider().background(Color(.separator))
                        }
                    }
                }
                .padding(.horizontal, 6)
                .frame(minWidth: 560) // fuerza ancho mínimo para columnas en pantallas grandes
            }
            .padding()
            .background(Color(.secondarySystemBackground).opacity(0.06))
            .cornerRadius(10)
        }
    }
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Implementación").fontWeight(.bold).foregroundColor(.white)
            Text("Los planes se guardan en Suscripcion_plan y las suscripciones activas en Suscripciones. Al mejorar crea/actualiza Suscripciones con Perfil.id_perfil.")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
        }
        .padding()
        .background(Color(.secondarySystemBackground).opacity(0.06))
        .cornerRadius(10)
    }
    private var footer: some View {
        Text("© 2025 - Plataforma de Talento")
            .font(.footnote)
            .foregroundColor(Color(.secondaryLabel))
            .padding()
    }
    private func symbol(for plan: Plan, key: String) -> String {
        if key.contains("Publicaciones") { return plan.highlighted ? "bolt.fill" : "checkmark.circle" }
        if key.contains("Caracteres") { return "textformat.size" }
        if key.contains("Prioridad") { return plan.highlighted ? "arrow.up.circle" : "arrow.down.circle" }
        if key.contains("Anuncios") { return plan.highlighted ? "eye.slash" : "eye" }
        if key.contains("CVs") { return "icloud.and.arrow.up" }
        if key.contains("Max") { return "briefcase" }
        return "checkmark"
    }
    private var comparisonRows: [(String, String, String, String)] {
        [
            ("Planes", "Gratuito", "Mensual", "Anual"),
            ("Precio",  "0 USD", "2.99 USD", "29.99 USD"),
            ("Publicaciones / día", "1", "10", "10"),
            ("Caracteres publicación", "500", "5000", "5000"),
            ("Prioridad búsqueda", "Baja", "Alta", "Alta"),
            ("Anuncios", "Sí", "No", "No"),
            ("CVs subidos", "1", "5", "5")
        ]
    }
}
struct Plan: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let price: String
    let features: [String: String]
    let isActive: Bool
    let highlighted: Bool
}
struct SuscripcionesView_Previews: PreviewProvider {
    static var previews: some View {
        SuscripcionesView()
            .previewDevice("iPhone 14")
            .preferredColorScheme(.dark)
    }
}




