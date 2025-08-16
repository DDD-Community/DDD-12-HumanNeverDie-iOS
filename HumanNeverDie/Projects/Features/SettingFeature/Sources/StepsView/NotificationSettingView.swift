//
//  NotificationSettingView.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI
import DesignSystem
import CommonFeature

public struct NotificationSettingView: View {
  @State private var viewModel: NotificationSettingViewModel
  @Environment(Router.self) private var router
  @State private var showTimePicker = false
  
  public init(viewModel: NotificationSettingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        notificationToggleSection()
        
      }
      .padding(.horizontal, 20)
      .padding(.top, 30)
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
    .amdBottomSheet(isPresented: $viewModel.state.showTimePicker, detents: [.height(474)]) {
      AMDDatePicker(
        selectedDate: $viewModel.state.reminderTime,
        pickerType: .time
      )
      .frame(height: 200)
    }.settingToolbar(item: .notificationSetting) {
      self.router.pop()
    }

  }
}

extension NotificationSettingView {
  
  @ViewBuilder
  private func notificationToggleSection() -> some View {
    VStack(spacing: 23) {
      
      NotificationToggleRow(
        title: "알림 ON/OFF",
        isOn: Binding(
          get: { viewModel.isEnabled },
          set: { viewModel.handleAction(.toggleIsEnabled($0)) }
        )
      )
      
      if(viewModel.isEnabled) {
        NotificationToggleRow(
          title: "기록 리마인더",
          isOn: Binding(
            get: { viewModel.state.remindersEnabled },
            set: { viewModel.handleAction(.toggleRemindersEnabled($0)) }
          ),
          isEnabled: viewModel.isEnabled
        )
        
        if (viewModel.state.remindersEnabled) {
          reminderTimeSection()
        }
        
        NotificationToggleRow(
          title: "목표 위험 경고",
          subtitle: "일일 당 섭취량의 2/3를 넘어가면 알려드릴게요",
          isOn: Binding(
            get: { viewModel.riskWarningsEnabled },
            set: { viewModel.handleAction(.toggleRiskWarningsEnabled($0)) }
          ),
          isEnabled: viewModel.remindersEnabled
        )
        
        NotificationToggleRow(
          title: "새소식",
          subtitle: "카페인 및 음료 업데이트 소식을 받을 수 있어요",
          isOn: Binding(
            get: { viewModel.state.newsUpdatesEnabled },
            set: { viewModel.handleAction(.toggleCaffeineNotification($0)) }
          ),
          isEnabled: viewModel.remindersEnabled
        )
      }
    }
  }
  
  @ViewBuilder
  private func reminderTimeSection() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .center, spacing: 12) {
        Text("알림 시간")
          .amdFont(.mediumRegular)
          .foregroundColor(.gray80)
        
        Spacer()
        
        Button(viewModel.getReminderTimeString()) {
          if viewModel.remindersEnabled {
            viewModel.state.showTimePicker = true
          }
        }
        .amdFont(.mediumRegular)
        .foregroundColor(.primaryDarker)
        .disabled(!viewModel.remindersEnabled)
      }
    }
  }
}

private struct NotificationToggleRow: View {
  let title: String
  let subtitle: String?
  @Binding var isOn: Bool
  let isEnabled: Bool
  
  init(
    title: String,
    subtitle: String? = nil,
    isOn: Binding<Bool>,
    isEnabled: Bool = true
  ) {
    self.title = title
    self.subtitle = subtitle
    self._isOn = isOn
    self.isEnabled = isEnabled
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .amdFont(.mediumRegular)
          .foregroundColor(.gray80)
        
        if let subtitle = subtitle {
          Text(subtitle)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .amdFont(.xsmallRegular)
            .foregroundColor(.gray60)
        }
      }
      
      Spacer()
      
      Toggle("", isOn: $isOn)
        .toggleStyle(SwitchToggleStyle(tint: .amdPrimary))
        .disabled(!isEnabled)
    }
  }
}
