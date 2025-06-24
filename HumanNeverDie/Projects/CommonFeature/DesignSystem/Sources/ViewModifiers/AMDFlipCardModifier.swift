//
//  AMDFlipCardModifier.swift
//  CommonFeature
//
//  Created by 김규철 on 6/23/25.
//

import SwiftUI

private struct AMDFlipCardModifier<BackView: View>: ViewModifier {
  private let backView: BackView
  
  @State private var flip = false
  @State private var dragOffset: CGFloat = 0
  private let dragThreshold: CGFloat = 50
  
  init(backView: BackView) {
    self.backView = backView
  }
  
  public func body(content: Content) -> some View {
    ZStack {
      backView
        .rotation3DEffect(.degrees(flip ? 0 : 89.9), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
        .animation(flip ? .linear(duration: 0.2).delay(0.2) : .linear(duration: 0.2), value: flip)
      
      content
        .rotation3DEffect(.degrees(flip ? -89.9 : 0), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
        .animation(flip ? .linear(duration: 0.2) : .linear(duration: 0.2).delay(0.2), value: flip)
    }
    .gesture(
      DragGesture()
        .onChanged { value in
          dragOffset = value.translation.width
        }
        .onEnded { value in
          if abs(value.translation.width) > dragThreshold {
            flip.toggle()
          }
          
          withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            dragOffset = 0
          }
        }
    )
  }
}

public extension View {
  func amdFlipCard<BackView: View>(
    backView: BackView,
    dragThreshold: CGFloat = 50
  ) -> some View {
    modifier(
      AMDFlipCardModifier(backView: backView)
    )
  }
}
