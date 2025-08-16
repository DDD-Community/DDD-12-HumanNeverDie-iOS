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
    .amdBottomSheet(isPresented: $viewModel.state.showTimePicker, detents: [.height(310)]) {
      AMDDatePickerView(
        title: "생년월일",
        isResetButtonHidden: true,
        type: .time,
        initialDate: viewModel.reminderTime
      ) {
        viewModel.handleAction(.updateReminderTime($0))
      }

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
      
      
      NotificationToggleRow(
        title: "기록 리마인더",
        isOn: Binding(
          get: { viewModel.state.remindersEnabled },
          set: { viewModel.handleAction(.toggleRemindersEnabled($0)) }
        ),
        isEnabled: viewModel.isEnabled
      )
      
      reminderTimeSection()
      
      
      NotificationToggleRow(
        title: "목표 위험 경고",
        subtitle: "일일 당 섭취량의 2/3를 넘어가면 알려드릴게요",
        isOn: Binding(
          get: { viewModel.riskWarningsEnabled },
          set: { viewModel.handleAction(.toggleRiskWarningsEnabled($0)) }
        ),
        isEnabled: viewModel.isEnabled
      )
      
      NotificationToggleRow(
        title: "새소식",
        subtitle: "카페인 및 음료 업데이트 소식을 받을 수 있어요",
        isOn: Binding(
          get: { viewModel.state.newsUpdatesEnabled },
          set: { viewModel.handleAction(.toggleCaffeineNotification($0)) }
        ),
        isEnabled: viewModel.isEnabled
      )
    }
  }
  
  @ViewBuilder
  private func reminderTimeSection() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .center, spacing: 12) {
        Text("알림 시간")
          .amdFont(.mediumRegular)
          .foregroundColor(.gray80)
          .opacity(viewModel.remindersEnabled ? 1.0 : 0.4)
        
        Spacer()
        
        Button(viewModel.getReminderTimeString()) {
          if viewModel.remindersEnabled {
            viewModel.state.showTimePicker = true
          }
        }
        .amdFont(.mediumRegular)
        .foregroundColor(.primaryDarker)
        .disabled(!viewModel.remindersEnabled)
        .opacity(viewModel.remindersEnabled ? 1.0 : 0.4)
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
          .opacity(isEnabled ? 1.0 : 0.4)
        
        if let subtitle = subtitle {
          Text(subtitle)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .amdFont(.xsmallRegular)
            .foregroundColor(.gray60)
            .opacity(isEnabled ? 1.0 : 0.4)
        }
      }
      
      Spacer()
      
      Toggle("", isOn: $isOn)
        .toggleStyle(SwitchToggleStyle(tint: .amdPrimary))
        .disabled(!isEnabled)
    }
  }
}
