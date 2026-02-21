//
//  Theme.swift
//  FotoFest
//
//  Design System – Farbpalette & Typografie passend zum WeddyBird-Stil
//

import SwiftUI

// MARK: - Farbpalette

extension Color {
    /// Zartes Rosa – Hintergrund-Akzent, Icons
    static let softPink = Color(hex: "E8C4C4")
    /// Dusty Rose – Primärfarbe, Buttons, Icon-Kreise
    static let dustyRose = Color(hex: "D4A0A0")
    /// Lachs/Peach – Akzentfarbe
    static let peach = Color(hex: "D9A08E")
    /// Salbeigrün hell – Akzentfarbe
    static let sageLightGreen = Color(hex: "A8B5A0")
    /// Salbeigrün dunkel – Akzentfarbe
    static let sageDarkGreen = Color(hex: "8A9A7E")
    /// Creme/Elfenbein – Seitenhintergrund
    static let ivory = Color(hex: "FAF7F4")
    /// Dunkelbraun/Bordeaux – Schriftfarbe Überschriften
    static let darkBrown = Color(hex: "5C3A3A")
}

// MARK: - Hex-Initializer

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}

// MARK: - Button-Stil

struct DustyRoseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 14)
            .background(Color.dustyRose)
            .cornerRadius(25)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

extension ButtonStyle where Self == DustyRoseButtonStyle {
    static var dustyRose: DustyRoseButtonStyle { DustyRoseButtonStyle() }
}
