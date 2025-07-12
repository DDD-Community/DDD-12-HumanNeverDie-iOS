//
//  OnboardingProfileFactory.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/12/25.
//

import SwiftUI

@MainActor
public struct OnboardingProfileFactory {
  public static func create() -> some View {
    let viewModel = OnboardingProfileViewModel()
    return OnboardingContainerView(viewModel: viewModel)
  }
}
