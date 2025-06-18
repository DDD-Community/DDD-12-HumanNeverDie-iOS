//
//  Font.swift
//  DesignSystem
//
//  Created by 김규철 on 6/17/25.
//

import SwiftUI

public typealias PretendardFont = DesignSystemFontFamily.Pretendard

public enum AMDFont {
  case xxlargeBold
  case xlargeBold
  case xlargeRegular
  case largeBold
  case largeRegular
  case mediumBold
  case mediumMedium
  case mediumRegular
  case smallBold
  case smallRegular
  case xsmallBold
  case xsmallRegular
  case xxsmallRegular
  
  fileprivate var uiFont: UIFont {
    switch self {
    case .xxlargeBold:
      return PretendardFont.bold.font(size: 24)
    case .xlargeBold:
      return PretendardFont.bold.font(size: 20)
    case .xlargeRegular:
      return PretendardFont.regular.font(size: 20)
    case .largeBold:
      return PretendardFont.bold.font(size: 17)
    case .largeRegular:
      return PretendardFont.regular.font(size: 17)
    case .mediumBold:
      return PretendardFont.bold.font(size: 16)
    case .mediumMedium:
      return PretendardFont.medium.font(size: 16)
    case .mediumRegular:
      return PretendardFont.regular.font(size: 16)
    case .smallBold:
      return PretendardFont.bold.font(size: 14)
    case .smallRegular:
      return PretendardFont.regular.font(size: 14)
    case .xsmallBold:
      return PretendardFont.bold.font(size: 12)
    case .xsmallRegular:
      return PretendardFont.regular.font(size: 12)
    case .xxsmallRegular:
      return PretendardFont.regular.font(size: 11)
    }
  }
  
  fileprivate var swiftUIFont: Font {
    Font(uiFont)
  }
  
  fileprivate var lineHeight: CGFloat {
    switch self {
    case .xxlargeBold:
      return 34
    case .xlargeBold, .xlargeRegular:
      return 28
    case .largeBold, .largeRegular:
      return 24
    case .mediumBold, .mediumMedium, .mediumRegular:
      return 22
    case .smallBold, .smallRegular:
      return 20
    case .xsmallBold, .xsmallRegular:
      return 17
    case .xxsmallRegular:
      return 14
    }
  }
  
  fileprivate var kerning: CGFloat {
    return -0.02
  }
}

private struct AMDFontLineHeightModifier: ViewModifier {
  private let font: AMDFont
  
  init(font: AMDFont) {
    self.font = font
  }
  
  func body(content: Content) -> some View {
    content
      .font(font.swiftUIFont)
      .lineSpacing(font.lineHeight - font.uiFont.lineHeight)
      .padding(.vertical, (font.lineHeight - font.uiFont.lineHeight) / 2)
      .kerning(font.kerning)
  }
}

public extension View {
  func amdFont(_ font: AMDFont) -> some View {
    modifier(AMDFontLineHeightModifier(font: font))
  }
}
