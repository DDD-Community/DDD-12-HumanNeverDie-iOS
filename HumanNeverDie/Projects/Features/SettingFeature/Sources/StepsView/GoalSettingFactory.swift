//
//  GoalSettingFactory.swift
//  SettingFeature
//
//  Created by Seulki Lee on 8/16/25.
//

import SwiftUI
import UserDomain

@MainActor
public struct GoalSettingFactory {
  public static func create(userInfo: UserInfo) -> some View {
    let viewModel = GoalSettingViewModel(userInfo: userInfo)
    return GoalSettingView(viewModel: viewModel)
  }
}

