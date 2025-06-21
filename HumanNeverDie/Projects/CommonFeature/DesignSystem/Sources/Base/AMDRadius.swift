//
//  AMDRadius.swift
//  DesignSystem
//
//  Created by 김규철 on 6/18/25.
//

import SwiftUI

public enum AMDRadius: CaseIterable {
  case small
  case medium
  case large
  
  fileprivate var value: CGFloat {
    switch self {
    case .small:
      return 8
    case .medium:
      return 13
    case .large:
      return 20
    }
  }
}

public extension View {
  func amdCornerRadius(_ radius: AMDRadius) -> some View {
    self.clipShape(RoundedRectangle(cornerRadius: radius.value))
  }
  
  func amdCornerRadius(_ radius: AMDRadius, corners: UIRectCorner) -> some View {
    self.clipShape(RoundedCorner(radius: radius.value, corners: corners))
  }
}

// MARK: - RoundedCorner Shape (특정 모서리만 둥글게)
public struct RoundedCorner: Shape {
  private var radius: CGFloat = .infinity
  private var corners: UIRectCorner = .allCorners
  
  init(radius: CGFloat, corners: UIRectCorner) {
    self.radius = radius
    self.corners = corners
  }
  
  public func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

#Preview {
  VStack(spacing: 20) {
    Rectangle()
      .fill(Color.blue)
      .frame(width: 100, height: 100)
      .amdCornerRadius(.small)
    
    Rectangle()
      .fill(Color.green)
      .frame(width: 150, height: 50)
      .amdCornerRadius(.medium)
    
    Rectangle()
      .fill(Color.purple)
      .frame(width: 200, height: 120)
      .amdCornerRadius(.large)
  }
}
