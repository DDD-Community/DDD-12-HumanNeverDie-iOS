//
//  AMDColor.swift
//  DesignSystem
//
//  Created by 김규철 on 6/17/25.
//

import SwiftUI
import UIKit

public typealias AMDColor = DesignSystemAsset.Colors

public extension Color {
  static let gray0 = AMDColor.gray0.swiftUIColor
  static let gray5 = AMDColor.gray5.swiftUIColor
  static let gray10 = AMDColor.gray10.swiftUIColor
  static let gray15 = AMDColor.gray15.swiftUIColor
  static let gray25 = AMDColor.gray25.swiftUIColor
  static let gray40 = AMDColor.gray40.swiftUIColor
  static let gray50 = AMDColor.gray50.swiftUIColor
  static let gray60 = AMDColor.gray60.swiftUIColor
  static let gray70 = AMDColor.gray70.swiftUIColor
  static let gray80 = AMDColor.gray80.swiftUIColor
  static let gray85 = AMDColor.gray85.swiftUIColor
  static let gray95 = AMDColor.gray95.swiftUIColor
  static let gray100 = AMDColor.gray100.swiftUIColor
  static let amdPrimary = AMDColor.primary.swiftUIColor
  static let primaryBackground = AMDColor.primaryBackground.swiftUIColor
  static let primaryDarker = AMDColor.primaryDarker.swiftUIColor
  static let primaryLighter = AMDColor.primaryLighter.swiftUIColor
  static let amdRed = AMDColor.red.swiftUIColor
  static let redBackground = AMDColor.redBackground.swiftUIColor
  static let redDarker = AMDColor.redDarker.swiftUIColor
  static let redLighter = AMDColor.redLighter.swiftUIColor
  static let amdYellow = AMDColor.yellow.swiftUIColor
  static let yellowBackground = AMDColor.yellowBackground.swiftUIColor
  static let yellowDarker = AMDColor.yellowDarker.swiftUIColor
  static let yellowLighter = AMDColor.yellowLighter.swiftUIColor
  static let success = AMDColor.success.swiftUIColor
  static let danger = AMDColor.danger.swiftUIColor
  static let dangerBackground = AMDColor.dangerBackground.swiftUIColor
  static let information = AMDColor.information.swiftUIColor
}

public extension ShapeStyle where Self == Color {
  static var gray0: Color { .gray0 }
  static var gray5: Color { .gray5 }
  static var gray10: Color { .gray10 }
  static var gray15: Color { .gray15 }
  static var gray25: Color { .gray25 }
  static var gray40: Color { .gray40 }
  static var gray50: Color { .gray50 }
  static var gray60: Color { .gray60 }
  static var gray70: Color { .gray70 }
  static var gray80: Color { .gray80 }
  static var gray85: Color { .gray85 }
  static var gray95: Color { .gray95 }
  static var gray100: Color { .gray100 }
  static var amdPrimary: Color { .amdPrimary }
  static var primaryBackground: Color { .primaryBackground }
  static var primaryDarker: Color { .primaryDarker }
  static var primaryLighter: Color { .primaryLighter }
  static var amdRed: Color { .amdRed }
  static var redBackground: Color { .redBackground }
  static var redDarker: Color { .redDarker }
  static var redLighter: Color { .redLighter }
  static var amdYellow: Color { .amdYellow }
  static var yellowBackground: Color { .yellowBackground }
  static var yellowDarker: Color { .yellowDarker }
  static var yellowLighter: Color { .yellowLighter }
  static var success: Color { .success }
  static var danger: Color { .danger }
  static var dangerBackground: Color { .dangerBackground }
  static var information: Color { .information }
}

public extension UIColor {
  static let gray5 = AMDColor.gray5.color
  static let gray10 = AMDColor.gray10.color
  static let gray15 = AMDColor.gray15.color
  static let gray25 = AMDColor.gray25.color
  static let gray40 = AMDColor.gray40.color
  static let gray50 = AMDColor.gray50.color
  static let gray60 = AMDColor.gray60.color
  static let gray70 = AMDColor.gray70.color
  static let gray80 = AMDColor.gray80.color
  static let gray85 = AMDColor.gray85.color
  static let gray95 = AMDColor.gray95.color
  static let gray100 = AMDColor.gray100.color
  static let amdPrimary = AMDColor.primary.color
  static let primaryBackground = AMDColor.primaryBackground.color
  static let primaryDarker = AMDColor.primaryDarker.color
  static let primaryLighter = AMDColor.primaryLighter.color
  static let amdRed = AMDColor.red.color
  static let redBackground = AMDColor.redBackground.color
  static let redDarker = AMDColor.redDarker.color
  static let redLighter = AMDColor.redLighter.color
  static let amdYellow = AMDColor.yellow.color
  static let yellowBackground = AMDColor.yellowBackground.color
  static let yellowDarker = AMDColor.yellowDarker.color
  static let yellowLighter = AMDColor.yellowLighter.color
  static let success = AMDColor.success.color
  static let danger = AMDColor.danger.color
  static let dangerBackground = AMDColor.dangerBackground.color
  static let information = AMDColor.information.color
}
