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
  public static func create() -> some View {
    let viewModel = NotificationSettingViewModel()
    return NotificationSettingView(viewModel: viewModel)
  }
}

