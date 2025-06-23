//
//  AMDGradient.swift
//  DesignSystem
//
//  Created by 김규철 on 6/18/25.
//

import SwiftUI

public enum AMDGradient {
  public static let phase2: LinearGradient = .init(
    colors: [.init(hex: "76EAE1"), .init(hex: "F8F35E")],
    startPoint: .leading,
    endPoint: .trailing
  )
  
  public static let phase3: LinearGradient = .init(
    colors: [.init(hex: "76EAE1"), .init(hex: "F8F35E"), .init(hex: "FF8AC1")],
    startPoint: .leading,
    endPoint: .trailing
  )
  
  public static let cardHealthy: LinearGradient = LinearGradient(
    colors: [.init(hex: "FFFFFF"), .init(hex: "A0E0F4").opacity(0.2), .init(hex: "FFFFFF"), .init(hex: "A0E0F4").opacity(0.2)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  
  public static let cardWarning: LinearGradient = LinearGradient(
    colors: [.init(hex: "FFFFFF"), .init(hex: "FAF791").opacity(0.2), .init(hex: "FFFFFF"), .init(hex: "FAF791").opacity(0.2)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  
  public static let cardDanger: LinearGradient = LinearGradient(
    colors: [.init(hex: "FFFFFF"), .init(hex: "FFBDDC").opacity(0.2), .init(hex: "FFFFFF"), .init(hex: "FFBDDC").opacity(0.2)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  
  public static let cardDefault: LinearGradient = LinearGradient(
    colors: [.init(hex: "FFFFFF"), .init(hex: "F6F7F9").opacity(0.2), .init(hex: "FFFFFF"), .init(hex: "F6F7F9").opacity(0.2)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
}

public extension ShapeStyle where Self == LinearGradient {
  static var phase2: LinearGradient { AMDGradient.phase2 }
  static var phase3: LinearGradient { AMDGradient.phase3 }
  static var cardHealthy: LinearGradient { AMDGradient.cardHealthy }
  static var cardWarning: LinearGradient { AMDGradient.cardWarning }
  static var cardDanger: LinearGradient { AMDGradient.cardDanger }
  static var cardDefault: LinearGradient { AMDGradient.cardDefault }
}

fileprivate extension Color {
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
}
