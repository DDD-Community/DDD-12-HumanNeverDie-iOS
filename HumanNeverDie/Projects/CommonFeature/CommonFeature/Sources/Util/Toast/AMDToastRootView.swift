//
//  AMDToastRootView.swift
//  CommonFeature
//
//  Created by 김규철 on 7/5/25.
//

import SwiftUI

import DesignSystem

struct AMDToastRootView: View {
  private let property: AMDToastProperty
  private let animationDuration: TimeInterval = 0.3
  private let displayDuration: TimeInterval = 1.2
  private let screenOutOffsetY: CGFloat = 56
  
  @State private var offsetY: CGFloat = .zero
  @State private var isVisible: Bool = false
  
  init(_ property: AMDToastProperty) {
    self.property = property
  }
  
  var body: some View {
    VStack {
      Spacer()
      
      if isVisible {
        AMDToast(property)
          .padding(.horizontal, 20)
          .offset(y: offsetY)
          .onAppear {
            withAnimation(.easeIn(duration: 0.3)) {
              offsetY = -80
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) {
              withAnimation(.easeOut(duration: 0.5)) {
                offsetY = screenOutOffsetY
              } completion: {
                isVisible = false
              }
            }
          }
      }
    }
    .ignoresSafeArea()
    .onAppear {
      isVisible = true
      offsetY = screenOutOffsetY
    }
  }
}
