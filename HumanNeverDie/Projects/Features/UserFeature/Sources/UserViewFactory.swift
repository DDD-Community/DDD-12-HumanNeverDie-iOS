//
// UserViewFactory.swift
// User
//
// Created by Seulki Lee on 2025.
//

import SwiftUI

@MainActor
public struct UserViewFactory {
  public static func create() -> some View {
    let viewModel = UserViewModel()
    return UserView(viewModel: viewModel)
  }
}
