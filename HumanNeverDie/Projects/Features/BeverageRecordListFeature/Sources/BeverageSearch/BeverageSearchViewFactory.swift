//
//  BeverageSearchViewFactory.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/10/25.
//

import SwiftUI

@MainActor
public struct BeverageSearchViewFactory {
  public static func create() -> some View {
    let viewModel = BeverageSearchViewModel()
    return BeverageSearchView(viewModel: viewModel)
  }
}
