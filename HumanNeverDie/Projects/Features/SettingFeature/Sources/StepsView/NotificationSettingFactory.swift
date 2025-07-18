//
//  NotificationSettingFactory.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI

@MainActor
public struct NotificationSettingFactory {
  public static func create() -> some View {
    let viewModel = NotificationSettingViewModel()
    return NotificationSettingView(viewModel: viewModel)
  }
}
