//
// BeverageRecordListViewFactory.swift
// BeverageRecordList
//
// Created by 김규철 on 2025.
//

import SwiftUI

@MainActor
public struct BeverageRecordListViewFactory {
  public static func create() -> some View {
    let viewModel = BeverageRecordListViewModel()
    return BeverageRecordListView(viewModel: viewModel)
  }
}
