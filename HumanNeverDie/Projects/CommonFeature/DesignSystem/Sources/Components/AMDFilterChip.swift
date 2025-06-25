//
//  AMDFilterChip.swift
//  DesignSystem
//
//  Created by 김규철 on 6/24/25.
//

import SwiftUI

public struct AMDFilterChip: View {
  private let icon: Image?
  private let title: String?
  private let count: Int
  private let isSelected: Bool
  private let action: () -> Void
  
  public init(
    icon: Image? = nil,
    title: String? = nil,
    count: Int,
    isSelected: Bool,
    action: @escaping () -> Void
  ) {
    self.icon = icon
    self.title = title
    self.count = count
    self.isSelected = isSelected
    self.action = action
  }
  
  public var body: some View {
    HStack(spacing: 4) {
      if let icon {
        chipIcon(icon)
      }
      
      if let title {
        chipTitle(title)
      }
      
      chipCount
    }
    .padding(.horizontal, 12)
    .frame(height: 36)
    .amdStrokeBorder(strokeBorderColor(isSelected))
    .onTapGesture {
      withAnimation(.bouncy(duration: 0.6, extraBounce: 0.2)) {
        action()
      }
    }
  }
  
  private func chipIcon(_ icon: Image) -> some View {
    icon
      .resizable()
      .scaledToFill()
      .frame(width: 18, height: 18)
  }
  
  private func chipTitle(_ title: String) -> some View {
    Text(title)
      .amdFont(font(isSelected))
      .foregroundStyle(foregroundColor(isSelected))
  }
  
  private var chipCount: some View {
    Text("\(count)")
      .amdFont(.smallRegular)
      .foregroundStyle(.gray60)
  }
}

private extension AMDFilterChip {
  func font(_ isSelected: Bool) -> AMDFont {
    return isSelected ? .smallBold : .smallRegular
  }
  
  func foregroundColor(_ isSelected: Bool) -> Color {
    return isSelected ? .gray85 : .gray80
  }
  
  func strokeBorderColor(_ isSelected: Bool) -> Color {
    return isSelected ? .gray80 : .gray25
  }
}

#Preview {
  AMDFilterChip(icon: AMDImage.liked18.swiftUIImage, title: "칩", count: 3, isSelected: true, action: {})
}
