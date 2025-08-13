//
// SettingView.swift
// Setting
//
// Created by Seulki Lee on 2025.
//

import SwiftUI
import DesignSystem
import CommonFeature

public struct SettingView: View {
  @State private var viewModel: SettingViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: SettingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      VStack(alignment: .leading, spacing:0) {
        sectionTitle(title: "사용자 설정")
        SettingsRow(item: SettingItem.accountInfo, onTap: handleItemTap, color: .gray80)
        SettingsRow(item: SettingItem.goalSetting, onTap: handleItemTap, color: .gray80)
      }.padding(.horizontal, 20)
        .padding(.top, 16)
      
      sectionDivider().padding(.vertical, 16)
      
      VStack(alignment: .leading, spacing:0) {
        sectionTitle(title: "알림 설정")
        SettingsRow(item: SettingItem.notificationSetting, onTap: handleItemTap, color: .gray80)
      }.padding(.horizontal, 20)
      
      sectionDivider().padding(.vertical, 16)
      
      VStack(alignment: .leading, spacing:0) {
        sectionTitle(title: "기타")
        SettingsRow(item: SettingItem.feedback, onTap: handleItemTap, color: .gray80)
        SettingsRow(item: SettingItem.terms, onTap: handleItemTap, color: .gray80)
      }.padding(.horizontal, 20)
      
      sectionDivider().padding(.vertical, 16)
      
      VStack(alignment: .leading, spacing:0) {
        sectionTitle(title: "계정")
        SettingsRow(item: SettingItem.logout, onTap: handleItemTap, color: .gray80)
        SettingsRow(item: SettingItem.unsubscribe, onTap: handleItemTap, color: .danger)
      }.padding(.horizontal, 20)
      
      sectionDivider().padding(.vertical, 16)
      
      VStack(alignment: .leading, spacing:0) {
        AppVersionRow(title: "앱 버전", value: "0.0.0")
      }.padding(.horizontal, 20)
      
      Spacer()
    }
    .settingToolbar(item: .settingTitle)
    
    Spacer()
  }
}

extension SettingView {
  
  private func handleItemTap(_ item: SettingItem) {
    switch item {
    case .accountInfo:
      router.push(to: .SettingAccountInfo)
      
    case .goalSetting:
      router.push(to: .SettingGoalSetting)
      
    case .notificationSetting:
      router.push(to: .SettingNotificationSetting)
      
    case .feedback: break
      //앱스토어 리뷰이동
      
    case .terms:
      router.push(to: .SettingTerms)
      
    case .settingTitle:
      break
    case .logout:
      break
    case .unsubscribe:
      break
    }
  }
  
  private func sectionTitle(title:String) -> some View {
    Text(title)
      .amdFont(.smallBold)
      .foregroundStyle(.gray85)
      .padding(.vertical, 10)
  }
  
  private struct SettingsRow: View {
    let item: SettingItem
    let onTap: (SettingItem) -> Void
    let color: Color
    
    var body: some View {
      HStack {
        Text(item.title)
          .amdFont(.mediumRegular)
          .foregroundColor(color)
          .padding(.vertical, 11)
        
        Spacer()
      }
      .contentShape(Rectangle())
      .onTapGesture {
        onTap(item)
      }
    }
  }
  
  private struct AppVersionRow: View {
    let title: String
    let value: String?
    
    init(title: String, value: String? = nil)  {
      self.title = title
      self.value = value
    }
    
    var body: some View {
      HStack {
        Text(title)
          .amdFont(.smallRegular)
          .foregroundColor(.gray80)
        
        Spacer()
        
        if let value = value {
          Text(value)
            .amdFont(.smallRegular)
            .foregroundColor(.gray60)
        }
      }
      .padding(.vertical, 20)
    }
  }
}

