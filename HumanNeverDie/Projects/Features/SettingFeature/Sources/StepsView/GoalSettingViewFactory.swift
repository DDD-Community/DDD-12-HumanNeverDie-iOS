//
//  GoalSettingViewFactory.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI

@MainActor
public struct GoalSettingViewFactory {
  public static func create() -> some View {
    let viewModel = GoalSettingViewModel()
    return GoalSettingView(viewModel: viewModel)
  }
}
