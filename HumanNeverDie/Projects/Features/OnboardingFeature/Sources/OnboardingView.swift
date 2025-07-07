//
// OnboardingView.swift
// Onboarding
//
// Created by Seulki Lee on 2025.
//

import SwiftUI

import CommonFeature

public struct OnboardingView: View {
  @State private var viewModel: OnboardingViewModel
  
  public init(viewModel: OnboardingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {

  }
}
