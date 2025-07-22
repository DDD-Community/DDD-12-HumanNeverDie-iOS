//
//  NotificationSettingFactory.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import SwiftUI
import UserDomain

@MainActor
public struct NotificationSettingFactory {
  public static func create(userInfo: UserInfo) -> some View {
    let viewModel = NotificationSettingViewModel(userInfo: userInfo)
    return NotificationSettingView(viewModel: viewModel)
  }
}

