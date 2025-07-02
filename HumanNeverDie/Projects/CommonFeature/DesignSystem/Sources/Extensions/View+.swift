//
//  View+.swift
//  DesignSystem
//
//  Created by 김규철 on 6/24/25.
//

import SwiftUI

public extension View {
  /// 조건부 View 수정을 위한 ViewModifier 확장
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
    if condition {
      content(self)
    } else {
      self
    }
  }
}

public extension View {
  func amdStrokeBorder<S: ShapeStyle>(
    _ color: S,
    radius: AMDRadius = .medium,
    linewidth: CGFloat = 1
  ) -> some View {
    self
      .amdCornerRadius(radius)
      .overlay {
        RoundedRectangle(cornerRadius: radius.value)
          .strokeBorder(color, lineWidth: linewidth)
      }
  }
  
  func amdStrokeBorder<S: ShapeStyle>(
    _ color: S,
    radius: AMDRadius = .medium,
    corners: UIRectCorner,
    linewidth: CGFloat = 1
  ) -> some View {
    self
      .amdCornerRadius(radius, corners: corners)
      .overlay {
        RoundedRectangle(cornerRadius: radius.value)
          .strokeBorder(color, lineWidth: linewidth)
      }
  }
  
  func amdStrokeBorder<S: ShapeStyle>(
    _ color: S,
    linewidth: CGFloat = 1
  ) -> some View {
    self
      .clipShape(.capsule)
      .overlay {
        Capsule()
          .strokeBorder(color, lineWidth: linewidth)
      }
  }
}

public extension View {
  func amdDivider(
    type: AMDDeviderType = .list,
    isTop: Bool = false,
    isBottom: Bool = true
  ) -> some View {
    VStack(spacing: 0) {
      if isTop { AMDDevider(type: type) }
      
      Spacer()
      
      self
      
      Spacer()
      
      if isBottom { AMDDevider(type: type) }
    }
  }
}
