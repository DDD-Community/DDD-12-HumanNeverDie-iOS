//
// SettingView.swift
// Setting
//
// Created by Seulki Lee on 2025.
//

import SwiftUI

import DesignSystem
import CommonFeature
import UserDomain

import Dependencies

public struct SettingView: View {
  @State private var viewModel: SettingViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: SettingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    mainSettingView()
  }
  
  private func mainSettingView() -> some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(alignment: .leading, spacing:0) {
        userTitleContent()
        
        SettingCustomButton(
          title: viewModel.userInfo.selectedDailySugarGoal.descriptionTitle,
          progressText: "하루 \(viewModel.sugarMaxG)g"
        ) {
          handleItemTap(SettingItem.goalSetting)
        }.padding(.top, 24)
      }.padding(.horizontal, 20)
      
      sectionDivider().padding(.vertical, 16)
      
      VStack(alignment: .leading, spacing:0) {
        sectionTitle(title: "사용자 설정")
        SettingsRow(item: SettingItem.accountInfo, onTap: handleItemTap, color: .gray80)
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
        AppVersionRow(title: "앱 버전", value: Bundle.main.appVersion) 
      }.padding(.horizontal, 20)
      
      Spacer()
    }
    .onChange(of: viewModel.state.isLogoutAndWithdrawal) { _, isLogoutAndWithdrawal in
      if isLogoutAndWithdrawal {
        withAnimation { router.rootRoute = .login }
      }
    }
    .onViewDidLoad {
      viewModel.handleAction(.onViewDidLoad)
    }
  }
}

extension SettingView {
  
  private func userTitleContent() -> some View {
    HStack {
      Text(viewModel.userInfo.nickname)
        .amdFont(.xlargeBold)
        .foregroundStyle(.gray80)
      
      Spacer()
    }
    .padding(.top, 36)
  }
  
  private func handleItemTap(_ item: SettingItem) {
    switch item {
    case .accountInfo:
      router.setResultHandler { updatedUserInfo in
        viewModel.handleAction(.updateUserInfo(updatedUserInfo))
      }
      router.push(to: .SettingAccountInfo(userInfo: viewModel.userInfo))
      
    case .goalSetting:
      router.setResultHandler { updatedUserInfo in
        viewModel.handleAction(.updateUserInfo(updatedUserInfo))
      }
      router.push(to: .SettingGoalSetting(userInfo: viewModel.userInfo))
      
    case .notificationSetting:
      router.push(to: .SettingNotificationSetting(userID: viewModel.userID))
      
    case .feedback:
      openAppStoreReviewPage()
    case .terms:
      router.push(to: .SettingTerms)
    case .settingTitle:
      break
    case .logout:
      viewModel.handleAction(.logout)
    case .unsubscribe:
      viewModel.handleAction(.unsubscribe)

    case .termsOfUse, .privacyPolicy:
      break
    }
  }
  
  private func openAppStoreReviewPage() {
  
    if let reviewURL = AMDWebURL.addReviewLink.url {
      UIApplication.shared.open(reviewURL)
    }
  }
  
  private func sectionTitle(title:String) -> some View {
    Text(title)
      .amdFont(.smallBold)
      .foregroundStyle(.gray85)
      .padding(.vertical, 10)
  }
  
  private func sectionDivider() -> some View {
    Divider()
      .background(.gray40)
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
