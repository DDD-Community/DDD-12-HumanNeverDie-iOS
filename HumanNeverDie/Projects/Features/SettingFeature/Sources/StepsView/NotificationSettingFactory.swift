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
  public static func create(userID: String) -> some View {
    let viewModel = NotificationSettingViewModel(userID: userID)
    return NotificationSettingView(viewModel: viewModel)
  }
}

