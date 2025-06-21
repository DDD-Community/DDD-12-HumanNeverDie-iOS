//
// HistoryView.swift
// History
//
// Created by 김규철 on 2025.
//

import SwiftUI

import CommonFeature

public struct HistoryView: View {
  @State private var viewModel: HistoryViewModel
  
  public init(viewModel: HistoryViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    Color.green
  }
}
