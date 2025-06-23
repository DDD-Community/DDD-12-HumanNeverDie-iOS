//
//  AMDNumericAnimationModifier.swift
//  DesignSystem
//
//  Created by 김규철 on 6/23/25.
//

import SwiftUI

private struct AMDNumericAnimationModifier<V>: ViewModifier where V: BinaryInteger {
  private let value: V
  
  init(value: V) {
    self.value = value
  }
  
  func body(content: Content) -> some View {
    content
      .contentTransition(.numericText())
      .animation(.spring(response: 0.3, dampingFraction: 0.8), value: value)
  }
}

public extension View {
  func amdNumericAnimation<V>(_ value: V) -> some View where V: BinaryInteger {
    self.modifier(AMDNumericAnimationModifier(value: value))
  }
}
