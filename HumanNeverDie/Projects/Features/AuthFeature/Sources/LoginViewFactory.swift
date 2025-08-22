//
// LoginViewFactory.swift
// Auth
//
// Created by 김규철 on 2025.
//

import SwiftUI

@MainActor
public struct LoginViewFactory {
  public static func create() -> some View {
    let viewModel = LoginViewModel()
    return LoginView(viewModel: viewModel)
  }
}
