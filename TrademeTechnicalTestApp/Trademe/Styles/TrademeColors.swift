//
//  TrademeColors.swift
//  TrademeTechnicalTestApp
//
//  Created by Ryan Campion on 03/08/2024.
//

import Foundation
import SwiftUI

struct TradeMeColors {
    static let tasman500 = Color(hex: "#148FE2")
    static let feijoa500 = Color(hex: "#29A754")
    static let bluffOyster800 = Color(hex: "#393531")
    static let bluffOyster600 = Color(hex: "#85807B")
}

extension UIColor {
    static var bluffOyster800UIColor: UIColor {
        // Replace with your actual color value
        return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    }
}

extension Color {
    static let trademeColours = TradeMeColors.self
}

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
            (a, r, g, b) = (255, 0, 0, 0)
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
