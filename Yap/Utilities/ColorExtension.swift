//
//  ColorExtension.swift
//  Yap
//
//  Created by TT on 31/04/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let length = hexSanitized.count
        let r, g, b, a: Double

        if length == 6 { // RGB (no alpha)
            r = Double((rgb >> 16) & 0xFF) / 255.0
            g = Double((rgb >> 8) & 0xFF) / 255.0
            b = Double(rgb & 0xFF) / 255.0
            a = 1.0
        } else if length == 8 { // RGBA (with alpha)
            r = Double((rgb >> 24) & 0xFF) / 255.0
            g = Double((rgb >> 16) & 0xFF) / 255.0
            b = Double((rgb >> 8) & 0xFF) / 255.0
            a = Double(rgb & 0xFF) / 255.0
        } else { // Invalid hex, default to black
            r = 0
            g = 0
            b = 0
            a = 1.0
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

