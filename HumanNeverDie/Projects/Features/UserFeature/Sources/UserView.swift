//
// UserView.swift
// User
//
// Created by Seulki Lee on 2025.
//

import SwiftUI

import CommonFeature

public struct UserView: View {
  @State private var viewModel: UserViewModel
  
  public init(viewModel: UserViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {

  }
}
