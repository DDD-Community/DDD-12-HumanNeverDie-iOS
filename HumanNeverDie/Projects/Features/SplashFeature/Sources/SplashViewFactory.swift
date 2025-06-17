//
//  SplashViewFactory.swift
//  SplashFeature
//
//  Created by 김규철 on 6/17/25.
//

import SwiftUI

@MainActor
public struct SplashViewFactory {
  public static func create() -> some View {
    let viewModel = SplashViewModel()
    return SplashView(viewModel: viewModel)
  }
}
