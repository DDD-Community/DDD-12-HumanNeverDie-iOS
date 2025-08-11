//
//  BeverageSearchViewFactory.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/10/25.
//

import SwiftUI

@MainActor
public struct BeverageSearchViewFactory {
  public static func create(recordDate: Date) -> some View {
    let viewModel = BeverageSearchViewModel(beverageRecordDate: recordDate)
    return BeverageSearchView(viewModel: viewModel)
  }
}
