//
//  AMDShadow.swift
//  DesignSystem
//
//  Created by 김규철 on 6/18/25.
//

import SwiftUI

public enum AMDShadow {
  case card
  case fab
  case tabbar
  case character
  
  fileprivate var color: Color {
    switch self {
    case .card, .tabbar:
      return .gray80.opacity(0.08)
    case .fab, .character:
      return .gray80.opacity(0.1)
    }
  }
  
  fileprivate var radius: CGFloat {
    switch self {
    case .card, .fab, .tabbar:
      return 20
    case .character:
      return 5
    }
  }
  
  fileprivate var offset: CGSize {
    switch self {
    case .card, .character:
      return CGSize(width: 0, height: 0)
    case .fab:
      return CGSize(width: 0, height: 4)
    case .tabbar:
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
      .amdShadow(.card)
    
    RoundedRectangle(cornerRadius: 12)
      .fill(Color.white)
      .frame(width: 200, height: 100)
      .amdShadow(.fab)
    
    RoundedRectangle(cornerRadius: 12)
      .fill(Color.white)
      .frame(width: 200, height: 100)
      .amdShadow(.tabbar)
    
    RoundedRectangle(cornerRadius: 12)
      .fill(Color.white)
      .frame(width: 200, height: 100)
      .amdShadow(.character)
  }
}
