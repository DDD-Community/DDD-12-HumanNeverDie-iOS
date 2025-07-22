//
// SettingViewFactory.swift
// Setting
//
// Created by Seulki Lee on 2025.
//

import SwiftUI

@MainActor
public struct SettingViewFactory {
  public static func create() -> some View {
    let viewModel = SettingViewModel()
    return SettingView(viewModel: viewModel)
  }
}
