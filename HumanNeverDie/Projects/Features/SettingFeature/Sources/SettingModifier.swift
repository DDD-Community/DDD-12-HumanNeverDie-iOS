//
//  SettingModifier.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/17/25.
//

import SwiftUI

public struct CommonToolbarModifier: ViewModifier {
  let title: String
  
  public func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text(title)
            .amdFont(.mediumRegular)
            .foregroundStyle(.gray85)
        }
      }
  }
}

public extension View {
  func commonToolbar(title: String) -> some View {
    modifier(CommonToolbarModifier(title: title))
  }
  
  func commonToolbar(item: SettingItem) -> some View {
    modifier(CommonToolbarModifier(title: item.title))
  }
}
