//
// BeverageRecordListViewFactory.swift
// BeverageRecordList
//
// Created by 김규철 on 2025.
//

import SwiftUI

@MainActor
public struct BeverageRecordListViewFactory {
  public static func create(recordDate: Date) -> some View {
    let viewModel = BeverageRecordListViewModel(beverageRecordDate: recordDate)
    return BeverageRecordListView(viewModel: viewModel)
  }
}
