//
// BeverageRecordListView.swift
// BeverageRecordList
//
// Created by 김규철 on 2025.
//

import SwiftUI

import CommonFeature

public struct BeverageRecordListView: View {
  @State private var viewModel: BeverageRecordListViewModel
  
  public init(viewModel: BeverageRecordListViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {

  }
}
