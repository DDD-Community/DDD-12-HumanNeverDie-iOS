//
//  SettingModifier.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/17/25.
//

import SwiftUI
import DesignSystem

private struct SettingToolbarModifier: ViewModifier {
  let title: String
  let onBackTap: (() -> Void)?
  
  public func body(content: Content) -> some View {
    VStack(spacing: 0) {
      HStack {
        HStack {
          if let onBackTap = onBackTap {
            Button(action: onBackTap) {
              AMDImage.arrowLeft24.swiftUIImage
            }
          }
          Spacer()
        }
        .frame(maxWidth: .infinity)
        
        Text(title)
          .amdFont(.mediumRegular)
          .foregroundStyle(.gray85)
        
        HStack {
          Spacer()
        }
        .frame(maxWidth: .infinity)
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 17)
      
      // 기존 콘텐츠
      content
    }
    .toolbar(.hidden, for: .navigationBar)
  }
}

public extension View {
  func settingToolbar(title: String) -> some View {
    modifier(SettingToolbarModifier(title: title, onBackTap: nil))
  }
  
  func settingToolbar(item: SettingItem) -> some View {
    modifier(SettingToolbarModifier(title: item.title, onBackTap: nil))
  }

  func settingToolbar(item: SettingItem, onBackTap: @escaping () -> Void) -> some View {
    modifier(SettingToolbarModifier(title: item.title, onBackTap: onBackTap))
  }
}
