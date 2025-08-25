//
//  AMDOnViewDidLoadModifier.swift
//  CommonFeature
//
//  Created by 김규철 on 8/25/25.
//

import SwiftUI

public struct AMDOnViewDidLoadModifier: ViewModifier {
  @State private var hasAppeared = false
  private let action: () -> Void
  
  public init(action: @escaping () -> Void) {
    self.action = action
  }
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        if !hasAppeared {
          hasAppeared = true
          action()
        }
      }
  }
}

public extension View {
  func onViewDidLoad(perform action: @escaping () -> Void) -> some View {
    modifier(AMDOnViewDidLoadModifier(action: action))
  }
}
