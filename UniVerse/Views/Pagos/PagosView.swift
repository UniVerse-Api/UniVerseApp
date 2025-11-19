import SwiftUI

// Colores: usar inicializador Color(hex:) como en SuscripcionesView.swift
fileprivate enum AppColors {
    static let primary = Color(hex: "#FF8C00")         // naranja exacto del diseño
    static let backgroundLight = Color(hex: "#f5f6f8") // fondo claro exacto (no usado aquí)
    static let backgroundDark = Color(hex: "#0D1117")  // fondo oscuro exacto

    // textos / contraste: explícitos para asegurar buena legibilidad sobre fondo oscuro
    static let textPrimary = Color(hex: "#FFFFFF")
    static let textSecondary = Color(hex: "#B8C0C6") // texto secundario con buen contraste en dark
    static let textMuted = Color(hex: "#8F969C")

    static let cardBgLight = Color.white
    static let cardBgDark = AppColors.backgroundDark.opacity(0.62)
    static let borderLight = Color(hex: "#E2E4E8")
    static let borderDark = Color(hex: "#202329")
}

struct PagoView: View {
    @Environment(\.presentationMode) private var presentationMode
    // configurable
    let planTitle: String
    let amount: Double
    let periodLabel: String

    // form state
    @State private var method: PaymentMethod = .card
    @State private var cardName = ""
    @State private var doc = ""
    @State private var cardNumber = ""
    @State private var exp = ""
    @State private var cvc = ""
    @State private var billing = ""
    @State private var saveCard = false

    // UI state
    @State private var isProcessing = false
    @State private var feedbackMessage: String? = nil
    @State private var feedbackIsError = false

    init(planTitle: String = "Empresa (Mensual)", amount: Double = 29.99, periodLabel: String = "Mensual") {
        self.planTitle = planTitle
        self.amount = amount
        self.periodLabel = periodLabel
    }

    var body: some View {
        NavigationView {
            ZStack {
                // único fondo en modo oscuro (eliminar fondo claro)
                AppColors.backgroundDark
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    header
                    ScrollView {
                        VStack(spacing: 16) {
                            summarySection
                            paymentForm
                        }
                        .padding()
                        .frame(maxWidth: 980)
                        .padding(.bottom, 24)
                    }
                    footer
                }
            }
            .navigationBarHidden(true)
            .accentColor(AppColors.primary)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environment(\.colorScheme, .dark) // keep dark like the HTML example
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 12) {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.03))
                    .clipShape(Circle())
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Pago")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                Text(planTitle)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.textSecondary)
            }
            Spacer()
            Text("Suscripción: \(periodLabel)")
                .font(.system(size: 13))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding()
        .background(AppColors.backgroundDark)
        .overlay(Divider().background(Color(.separator)), alignment: .bottom)
    }

    // MARK: - Summary
    private var summarySection: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Resumen de compra")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    Text("Revisa los detalles y confirma tu pago.")
                        .font(.system(size: 13))
                        .foregroundColor(AppColors.textSecondary)
                }
                Spacer()
                Text(periodLabel)
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.textSecondary)
            }

            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(planTitle)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        Text("Mayor visibilidad, prioridad en búsquedas y sin anuncios.")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                Spacer()
                Text(currency(amount))
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(AppColors.textPrimary)
            }
            .padding()
            .background(cardBackground)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Inicio: hoy")
                    Text("Siguiente pago: dentro de \(periodLabel == "Anual" ? "12 meses" : "30 días")")
                }
                .font(.system(size: 12))
                .foregroundColor(AppColors.textSecondary)
                Spacer()
                VStack {
                    Text("Total a pagar")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.textSecondary)
                    Text(currency(amount))
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(AppColors.textPrimary)
                    Text(periodLabel == "Anual" ? "Pago único anual" : "Pago único mensual")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.textSecondary)
                }
                .multilineTextAlignment(.center)
                .padding(10)
                .background(cardBackground)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(borderColor, lineWidth: 1))
            }
        }
        .padding()
        .background(AppColors.backgroundDark.opacity(0.88))
        .cornerRadius(12)
    }

    // MARK: - Payment form
    private var paymentForm: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Método de pago")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(AppColors.textPrimary)

            // method selector
            HStack(spacing: 12) {
                methodButton(.card, label: "Tarjeta (Crédito/Débito)", system: "creditcard")
                methodButton(.paypal, label: "PayPal", system: "tray.full")
            }

            if method == .card {
                Group {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Nombre en la tarjeta").font(.caption).foregroundColor(AppColors.textSecondary)
                            TextField("Nombre completo", text: $cardName)
                                .textFieldStyle(FormPlainFieldStyle())
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                    }

                    VStack(alignment: .leading) {
                        Text("Número de tarjeta").font(.caption).foregroundColor(AppColors.textSecondary)
                        TextField("1234 5678 9012 3456", text: $cardNumber)
                            .keyboardType(.numberPad)
                            .onChange(of: cardNumber) { new in
                                cardNumber = formatCardNumber(new)
                            }
                            .textFieldStyle(FormPlainFieldStyle())
                            .foregroundColor(AppColors.textPrimary)
                    }

                    HStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            Text("MM/AA").font(.caption).foregroundColor(AppColors.textSecondary)
                            TextField("08/26", text: $exp)
                                .onChange(of: exp) { new in exp = formatExp(new) }
                                .keyboardType(.numbersAndPunctuation)
                                .textFieldStyle(FormPlainFieldStyle())
                                .foregroundColor(AppColors.textPrimary)
                        }
                        VStack(alignment: .leading) {
                            Text("CVC").font(.caption).foregroundColor(AppColors.textSecondary)
                            SecureField("123", text: $cvc)
                                .textFieldStyle(FormPlainFieldStyle())
                                .foregroundColor(AppColors.textPrimary)
                        }
                        VStack(alignment: .leading) {
                            Text("Dirección facturación").font(.caption).foregroundColor(AppColors.textSecondary)
                            TextField("Opcional", text: $billing)
                                .textFieldStyle(FormPlainFieldStyle())
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                }
                .transition(.opacity)
            } else {
                // PayPal info stub
                Text("Serás redirigido a PayPal para completar el pago.")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.textSecondary)
            }

            HStack {
                Toggle(isOn: $saveCard) {
                    Text("Guardar método para próximos pagos").font(.caption)
                }
                .toggleStyle(SwitchToggleStyle(tint: AppColors.primary))
                Spacer()
                (Text("Total: ").font(.caption).foregroundColor(AppColors.textSecondary) + Text(currency(amount)).font(.caption).fontWeight(.bold).foregroundColor(AppColors.textPrimary))
            }

            if let msg = feedbackMessage {
                Text(msg)
                    .font(.caption)
                    .foregroundColor(feedbackIsError ? Color.red.opacity(0.9) : Color.green.opacity(0.9))
                    .padding(8)
                    .background((feedbackIsError ? Color.red.opacity(0.08) : Color.green.opacity(0.06)))
                    .cornerRadius(8)
            }

            Button(action: payAction) {
                HStack {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text(isProcessing ? "Procesando..." : (method == .card ? "Pagar ahora" : "Pagar con PayPal"))
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.primary)
                .foregroundColor(.white)
                .cornerRadius(10)
                .opacity(isProcessing ? 0.9 : 1.0)
            }
            .disabled(isProcessing)
        }
        .padding()
        .background(AppColors.backgroundDark.opacity(0.92))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor, lineWidth: 1))
    }

    // MARK: - Footer
    private var footer: some View {
        Text("© 2025 - Plataforma de Talento")
            .font(.footnote)
            .foregroundColor(Color(.secondaryLabel))
            .padding()
    }

    // MARK: - Helpers & Actions
    private func currency(_ v: Double) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.currencySymbol = "$"
        fmt.maximumFractionDigits = 2
        return fmt.string(from: NSNumber(value: v)) ?? "$\(v)"
    }

    private var cardBackground: Color {
        // match HTML: white in light, translucent dark in dark theme
        return AppColors.cardBgDark
    }

    private var borderColor: Color {
        // slightly stronger border for better separation on dark bg
        return AppColors.borderDark.opacity(0.54)
    }

    private func methodButton(_ m: PaymentMethod, label: String, system: String) -> some View {
        Button(action: { withAnimation { method = m } }) {
            HStack(spacing: 8) {
                Image(systemName: system)
                    .foregroundColor(method == m ? AppColors.primary : Color(.systemGray2))
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Spacer()
                if method == m {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColors.primary)
                }
            }
            .padding(12)
            .background(method == m ? Color.white.opacity(0.03) : Color.clear)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(method == m ? AppColors.primary.opacity(0.16) : borderColor.opacity(0.06), lineWidth: method == m ? 1 : 1))
        }
    }

    private func payAction() {
        // clear feedback
        feedbackMessage = nil
        feedbackIsError = false

        if method == .card {
            guard !cardName.trimmingCharacters(in: .whitespaces).isEmpty else { showError("El nombre en la tarjeta es obligatorio."); return }
            guard validateCardNumber(cardNumber) else { showError("Número de tarjeta no válido."); return }
            guard validateExp(exp) else { showError("Fecha de expiración no válida."); return }
            guard validateCVC(cvc) else { showError("CVC no válido."); return }
        }

        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            isProcessing = false
            // simulate success
            feedbackIsError = false
            feedbackMessage = "Pago realizado con éxito. Suscripción activada."
            // here you would call backend / payment SDK
        }
    }

    private func showError(_ text: String) {
        feedbackIsError = true
        feedbackMessage = text
    }

    // Formatting / validation utilities
    private func formatCardNumber(_ s: String) -> String {
        let digits = s.filter { $0.isNumber }
        var out = ""
        for (i, ch) in digits.enumerated() {
            if i != 0 && i % 4 == 0 { out.append(" ") }
            out.append(ch)
            if out.count >= 19 { break }
        }
        return out
    }

    private func formatExp(_ s: String) -> String {
        let digits = s.filter { $0.isNumber }
        var out = ""
        for (i, ch) in digits.enumerated() {
            if i == 2 { out.append("/") }
            out.append(ch)
            if out.count >= 5 { break }
        }
        return out
    }

    private func validateCardNumber(_ s: String) -> Bool {
        let digits = s.filter { $0.isNumber }
        return digits.count >= 13 && digits.count <= 19
    }

    private func validateExp(_ s: String) -> Bool {
        let parts = s.split(separator: "/").map(String.init)
        guard parts.count == 2, let m = Int(parts[0]), let y = Int(parts[1]) else { return false }
        guard (1...12).contains(m) else { return false }
        let fullYear = (y < 100 ? 2000 + y : y)
        let calendar = Calendar.current
        let comps = DateComponents(year: fullYear, month: m, day: 1)
        guard let expDate = calendar.date(from: comps) else { return false }
        let startOfThisMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        return expDate >= startOfThisMonth
    }

    private func validateCVC(_ s: String) -> Bool {
        return s.count >= 3 && s.count <= 4 && s.allSatisfy({ $0.isNumber })
    }
}

fileprivate enum PaymentMethod {
    case card, paypal
}

// Plain field style used in form (with subtle border like the HTML inputs)
fileprivate struct FormPlainFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.white.opacity(0.02))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(AppColors.borderDark.opacity(0.06)))
            .foregroundColor(.white)
    }
}

struct PagoView_Previews: PreviewProvider {
    static var previews: some View {
        PagoView(planTitle: "Plan Premium", amount: 9.99, periodLabel: "Mensual")
            .previewDevice("iPhone 14")
            .preferredColorScheme(.dark)
    }
}

