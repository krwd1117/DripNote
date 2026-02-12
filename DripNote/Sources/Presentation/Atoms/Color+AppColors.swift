import SwiftUI

extension Color {
    static let backgroundPrimary = Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 1.0) // 짙은 차콜
    static let backgroundSecondary = Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 1.0) // 카드 배경 등
    static let accentOrange = Color(hex: "#FF8C00") // 따뜻한 오렌지/골드
    static let textPrimary = Color.white
    static let textSecondary = Color.gray
    static let alertRed = Color.red

    // Convenience initializer for Hex color
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
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
