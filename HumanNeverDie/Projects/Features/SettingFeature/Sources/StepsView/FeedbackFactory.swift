//
//  FeedbackFactory.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI

@MainActor
public struct FeedbackFactory {
  public static func create() -> some View {
    let viewModel = FeedbackViewModel()
    return FeedbackView(viewModel: viewModel)
  }
}
