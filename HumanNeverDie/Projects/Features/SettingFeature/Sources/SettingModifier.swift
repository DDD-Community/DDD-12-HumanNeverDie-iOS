//
//  SettingModifier.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/17/25.
//

import SwiftUI

private struct SettingToolbarModifier: ViewModifier {
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
  func settingToolbar(title: String) -> some View {
    modifier(SettingToolbarModifier(title: title))
  }
  
  func settingToolbar(item: SettingItem) -> some View {
    modifier(SettingToolbarModifier(title: item.title))
  }
}
