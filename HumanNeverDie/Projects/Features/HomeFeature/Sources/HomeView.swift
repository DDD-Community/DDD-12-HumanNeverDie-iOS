//
// HomeView.swift
// Home
//
// Created by 김규철 on 2025.
//

import SwiftUI

import CommonFeature

public struct HomeView: View {
  @State private var viewModel: HomeViewModel
  
  public init(viewModel: HomeViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    Color.pink
  }
}
