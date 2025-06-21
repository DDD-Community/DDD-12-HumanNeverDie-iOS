//
//  AMDShadow.swift
//  DesignSystem
//
//  Created by 김규철 on 6/18/25.
//

import SwiftUI

public enum AMDShadow {
  case shadow20
  case shadow20Down
  case shadow20Up
  case shadow5
  
  fileprivate var color: Color {
    switch self {
    case .shadow20, .shadow20Up:
      return .gray80.opacity(0.08)
    case .shadow20Down, .shadow5:
      return .gray80.opacity(0.1)
    }
  }
  
  fileprivate var radius: CGFloat {
    switch self {
    case .shadow20, .shadow20Down, .shadow20Up:
      return 20
    case .shadow5:
      return 5
    }
  }
  
  fileprivate var offset: CGSize {
    switch self {
    case .shadow20, .shadow5:
      return CGSize(width: 0, height: 0)
    case .shadow20Down:
      return CGSize(width: 0, height: 4)
    case .shadow20Up:
      return CGSize(width: 0, height: -4)
    }
  }
}

public extension View {
  func amdShadow(_ shadow: AMDShadow) -> some View {
    self.shadow(
      color: shadow.color,
      radius: shadow.radius,
      x: shadow.offset.width,
      y: shadow.offset.height
    )
  }
}

#Preview {
  VStack(spacing: 20) {
    RoundedRectangle(cornerRadius: 12)
      .fill(Color.white)
      .frame(width: 200, height: 100)
      .amdShadow(.shadow20)
    
    RoundedRectangle(cornerRadius: 12)
      .fill(Color.white)
      .frame(width: 200, height: 100)
      .amdShadow(.shadow20Down)
    
    RoundedRectangle(cornerRadius: 12)
      .fill(Color.white)
      .frame(width: 200, height: 100)
      .amdShadow(.shadow20Up)
    
    RoundedRectangle(cornerRadius: 12)
      .fill(Color.white)
      .frame(width: 200, height: 100)
      .amdShadow(.shadow5)
  }
}
