
import SwiftUI

// Colores del diseño (coinciden con el html)
fileprivate enum AppColors {
    static let primary = Color(hex: "#FF8C00")
    static let backgroundLight = Color(hex: "#f5f6f8")
    static let backgroundDark = Color(hex: "#0D1117")
}

struct SuscripcionEmpreaView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) private var colorScheme

    // Planes para empresas: Gratuito (info), Empresa Mensual y Empresa Anual
    // Usa el tipo Plan definido en SuscripcionesView.swift (no lo vuelvas a declarar aquí)
    private let plans: [Plan] = [
        Plan(id: "free", title: "Gratuito", subtitle: "Prueba", price: "0 USD / mes", features: [
            "Publicaciones/día": "1",
            "Caracteres publicación": "1000",
            "Prioridad búsqueda": "Baja",
            "Anuncios": "Sí",
            "CVs subidos": "3",
            "Max ofertas aplicables": "10"
        ], isActive: false, highlighted: false),
        Plan(id: "empresa_monthly", title: "Empresa (Mensual)", subtitle: "Pago mensual", price: "29.99 USD / mes", features: [
            "Publicaciones/día": "50",
            "Caracteres publicación": "10000",
            "Prioridad búsqueda": "Alta",
            "Anuncios": "No",
            "CVs subidos": "Ilimitados",
            "Max ofertas aplicables": "500"
        ], isActive: true, highlighted: true),
        Plan(id: "empresa_annual", title: "Empresa (Anual)", subtitle: "Pago anual — ahorro", price: "287.9 USD / año", features: [
            "Publicaciones/día": "50",
            "Caracteres publicación": "10000",
            "Prioridad búsqueda": "Alta",
            "Anuncios": "No",
            "CVs subidos": "Ilimitados",
            "Max ofertas aplicables": "500"
        ], isActive: false, highlighted: true)
    ]

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
        .environment(\.colorScheme, .dark)
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
            Text("Suscripción Empresa")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Text("Cuenta: Empresa (mensual)")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
        }
        .padding()
        .background(AppColors.backgroundDark)
        .overlay(Divider().background(Color(.separator)), alignment: .bottom)
    }

    private var introSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Planes para empresas")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Elije entre pago mensual o anual. El plan anual ofrece descuento por pago adelantado.")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6).opacity(0.06))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 1)
    }

    // lista vertical de tarjetas
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
                        Text("Empresa")
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
                    Text("Mejorar a premium")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                if isAnnual {
                    Button(action: {}) {
                        Text("Contratar anual")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
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
                        Text("Plan Activo")
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

            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(comparisonRows, id: \.0) { row in
                        HStack(spacing: 12) {
                            Text(row.0)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(width: 160, alignment: .leading)
                            Text(row.1)
                                .foregroundColor(Color(.secondaryLabel))
                                .frame(width: 110, alignment: .center)
                            Rectangle()
                                .fill(Color(.separator))
                                .frame(width: 1, height: 18)
                            Text(row.2)
                                .foregroundColor(Color(.secondaryLabel))
                                .frame(width: 110, alignment: .center)
                            Rectangle()
                                .fill(Color(.separator))
                                .frame(width: 1, height: 18)
                            Text(row.3)
                                .foregroundColor(Color(.secondaryLabel))
                                .frame(width: 110, alignment: .center)
                        }
                        .padding(.vertical, 10)
                        if row.0 != comparisonRows.last?.0 {
                            Divider().background(Color(.separator))
                        }
                    }
                }
                .padding(.horizontal, 6)
                .frame(minWidth: 560)
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
            ("Precio", "0 USD", "29.99 USD", "287.9 USD"),
            ("Publicaciones / día", "1", "50", "50"),
            ("Caracteres publicación", "1000", "10000", "10000"),
            ("Prioridad búsqueda", "Baja", "Alta", "Alta"),
            ("Anuncios", "Sí", "No", "No"),
            ("CVs subidos", "3", "Ilimitados", "Ilimitados")
        ]
    }
}

struct SuscripcionEmpreaView_Previews: PreviewProvider {
    static var previews: some View {
        SuscripcionEmpreaView()
            .previewDevice("iPhone 14")
            .preferredColorScheme(.dark)
    }
}


