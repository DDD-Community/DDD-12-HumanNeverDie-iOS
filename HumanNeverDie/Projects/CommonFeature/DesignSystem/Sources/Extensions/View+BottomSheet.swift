//
//  View+BottomSheet.swift
//  DesignSystem
//
//  Created by 김규철 on 7/3/25.
//

import SwiftUI

public extension View {
  func amdBottomSheet<Content: View>(
    isPresented: Binding<Bool>,
    detents: Set<PresentationDetent>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.sheet(isPresented: isPresented) {
      content()
        .presentationDetents(detents)
        .presentationDragIndicator(.visible)
        .presentationBackground(.white)
        .presentationCornerRadius(16)
    }
  }
}
