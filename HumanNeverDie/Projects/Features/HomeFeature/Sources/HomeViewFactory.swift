//
// HomeViewFactory.swift
// Home
//
// Created by 김규철 on 2025.
//

import SwiftUI

@MainActor
public struct HomeViewFactory {
  public static func create() -> some View {
    let viewModel = HomeViewModel()
    return HomeView(viewModel: viewModel)
  }
}
