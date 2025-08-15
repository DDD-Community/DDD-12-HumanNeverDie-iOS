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
        if let onBackTap = onBackTap {
             Button(action: onBackTap) {
               Image(systemName: "chevron.left")
                 .foregroundColor(.gray70)
             }
           } else {
             Color.clear
               .frame(width: 24, height: 24)
           }
        Spacer()
        
        Text(title)
          .amdFont(.mediumRegular)
          .foregroundStyle(.gray85)
          .padding(.trailing, 24)
        
        Spacer()
      
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 17)
      
      // 기존 콘텐츠
      content
    }
    .toolbar(.hidden, for: .navigationBar)  // 기본 네비게이션 완전 숨기기
  }
}

public extension View {
  func settingToolbar(title: String) -> some View {
    modifier(SettingToolbarModifier(title: title, onBackTap: nil))
  }
  
  func settingToolbar(item: SettingItem) -> some View {
    modifier(SettingToolbarModifier(title: item.title, onBackTap: nil))
  }
  
  // 커스텀 뒤로가기 액션을 받는 새로운 메서드들
  func settingToolbar(title: String, onBackTap: @escaping () -> Void) -> some View {
    modifier(SettingToolbarModifier(title: title, onBackTap: onBackTap))
  }
  
  func settingToolbar(item: SettingItem, onBackTap: @escaping () -> Void) -> some View {
    modifier(SettingToolbarModifier(title: item.title, onBackTap: onBackTap))
  }
}
