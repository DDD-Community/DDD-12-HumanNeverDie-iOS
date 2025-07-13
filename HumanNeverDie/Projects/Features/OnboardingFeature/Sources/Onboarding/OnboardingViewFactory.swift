//
// OnboardingViewFactory.swift
// Onboarding
//
// Created by Seulki Lee on 2025.
//

import SwiftUI

@MainActor
public struct OnboardingViewFactory {
  public static func create() -> some View {
    let viewModel = OnboardingViewModel()
    return OnboardingView(viewModel: viewModel)
  }
}
