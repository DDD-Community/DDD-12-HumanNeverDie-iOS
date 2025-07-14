//
// SettingView.swift
// Setting
//
// Created by Seulki Lee on 2025.
//

import SwiftUI

import CommonFeature

public struct SettingView: View {
  @State private var viewModel: SettingViewModel
  
  public init(viewModel: SettingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {

  }
}
