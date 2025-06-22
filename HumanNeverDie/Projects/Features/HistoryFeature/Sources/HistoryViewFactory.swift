//
// HistoryViewFactory.swift
// History
//
// Created by 김규철 on 2025.
//

import SwiftUI

@MainActor
public struct HistoryViewFactory {
  public static func create() -> some View {
    let viewModel = HistoryViewModel()
    return HistoryView(viewModel: viewModel)
  }
}
