// Utils/ColorExtension.swift
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // Colores del tema de la app
    static let primaryOrange = Color(hex: "FF8C00")
    static let primaryPurple = Color(hex: "7C3AED") // Color para empresas
    static let accentPrimary = Color(hex: "FF8C00") // Color de acento principal
    static let textSecondary = Color(hex: "6B7280")
    static let backgroundLight = Color(hex: "F9FAFB")
    static let cardBackground = Color.white
    static let inputBackground = Color(hex: "F9FAFB")
    static let borderColor = Color(hex: "E5E7EB")
    static let backgroundDark = Color(hex: "0D1117")
    static let textPrimary = Color(hex: "1F2937")
    static let primaryText = Color(hex: "1F2937")
    static let secondaryText = Color(hex: "6B7280")

}
