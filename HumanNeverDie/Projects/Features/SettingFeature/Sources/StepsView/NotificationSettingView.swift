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
  @State private var showTimePicker = false
  
  let settingViewModel: SettingViewModel // 상위 ViewModel 참조
  
  public init(viewModel: NotificationSettingViewModel, settingViewModel: SettingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
    self.settingViewModel = settingViewModel
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
    .settingToolbar(item: .notificationSetting)
    .amdBottomSheet(isPresented: $viewModel.state.showTimePicker, detents: [.height(474)]) {
      AMDDatePicker(
        selectedDate: $viewModel.state.reminderTime,
        pickerType: .time
      )
      .frame(height: 200)
    }.onAppear {
      viewModel.handleAction(.onAppear)
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
          get: { viewModel.state.isPermissionGranted },
          set: { viewModel.handleAction(.toggleGeneralNotification($0)) }
        )
      )
      
      if(viewModel.state.isPermissionGranted) {
        NotificationToggleRow(
          title: "기록 리마인더",
          isOn: Binding(
            get: { viewModel.state.isGoalReminderEnabled },
            set: { viewModel.handleAction(.toggleGoalReminder($0)) }
          ),
          isEnabled: viewModel.isOtherNotificationsEnabled
        )
        
        if (viewModel.state.isGoalReminderEnabled) {
          reminderTimeSection()
        }
        
        NotificationToggleRow(
          title: "목표 위험 경고",
          subtitle: "일일 당 섭취량의 2/3를 넘어가면 알려드릴게요",
          isOn: Binding(
            get: { viewModel.state.isGoalWarningEnabled },
            set: { viewModel.handleAction(.toggleGoalWarning($0)) }
          ),
          isEnabled: viewModel.isOtherNotificationsEnabled
        )
        
        NotificationToggleRow(
          title: "새소식",
          subtitle: "카페인 및 음료 업데이트 소식을 받을 수 있어요",
          isOn: Binding(
            get: { viewModel.state.isCaffeineNotificationEnabled },
            set: { viewModel.handleAction(.toggleCaffeineNotification($0)) }
          ),
          isEnabled: viewModel.isOtherNotificationsEnabled
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
          if viewModel.isOtherNotificationsEnabled {
            viewModel.state.showTimePicker = true
          }
        }
        .amdFont(.mediumRegular)
        .foregroundColor(.primaryDarker)
        .disabled(!viewModel.isOtherNotificationsEnabled)
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
