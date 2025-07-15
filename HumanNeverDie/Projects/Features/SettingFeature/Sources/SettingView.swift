//
// SettingView.swift
// Setting
//
// Created by Seulki Lee on 2025.
//

import SwiftUI

import CommonFeature

public struct SettingView: View {
  @State private var viewModel: SettingViewModel
  
  public init(viewModel: SettingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    List {
      Section {
        SettingsRow(item: SettingItem.accountInfo, onTap: handleItemTap)
        SettingsRow(item: SettingItem.goalSetting, onTap: handleItemTap)
      } header: {
        sectionTitle(title: "사용자 설정")
      }
      
      sectionDivider()
      
      Section {
        SettingsRow(item: SettingItem.notificationSetting, onTap: handleItemTap)
      } header: {
        sectionTitle(title: "알림 설정")
      }
      
      sectionDivider()
      
      Section {
        SettingsRow(item: SettingItem.feedback, onTap: handleItemTap)
        SettingsRow(item: SettingItem.terms, onTap: handleItemTap)
      } header: {
        sectionTitle(title: "기타")
      }
      
      sectionDivider()
      
      Section {
        AppVersionRow(title: "앱 버전", value: "0.0.0")
      }
    }
    .listStyle(.plain)
    .listRowSeparator(.hidden)
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("설정")
          .amdFont(.mediumRegular)
          .foregroundStyle(.gray85)
      }
    }
  }
}

extension SettingView {
  private func handleItemTap(_ item: SettingItem) {
    viewModel.handleAction(.moveToNextStep(item))
  }
  
  
  private func sectionDivider() -> some View {
    Divider()
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)
  }
  
  private func sectionTitle(title:String) -> some View {
    Text(title)
      .amdFont(.smallBold)
      .foregroundStyle(.gray85)
      .padding(.top, 16)
      .padding(.bottom, 16)
  }
  
  private struct SettingsRow: View {
    let item: SettingItem
    let onTap: (SettingItem) -> Void

    var body: some View {
      HStack {
        Text(item.title)
          .amdFont(.mediumRegular)
          .foregroundColor(.gray80)
        
        Spacer()
      }
      .listRowSeparator(.hidden)
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
      .listRowSeparator(.hidden)
    }
  }
}
