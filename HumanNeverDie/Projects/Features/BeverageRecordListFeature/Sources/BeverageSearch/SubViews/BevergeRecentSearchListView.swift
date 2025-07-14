//
//  BevergeRecentSearchListView.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/11/25.
//

import SwiftUI

import DesignSystem

struct BevergeRecentSearchListView: View {
  @Bindable private var viewModel: BeverageSearchViewModel
  
  private enum Constants {
    static let height: CGFloat = 36
  }
  
  init(viewModel: BeverageSearchViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack(spacing: 10) {
      recentSearchTitleView
      recentSearchListView
    }
    .frame(maxWidth: .infinity, minHeight: Constants.height, maxHeight: Constants.height, alignment: .leading)
  }
  
  private var recentSearchTitleView: some View {
    Text("최근 검색어")
      .amdFont(.mediumBold)
      .foregroundStyle(.gray85)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 20)
  }
  
  private var recentSearchListView: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 8) {
        ForEach(viewModel.recentSearchList, id: \.self) { search in
          AMDTagChip(
            title: search,
            action: { viewModel.handleAction(.recentSearchListButtonTapped(search)) }
          )
        }
      }
    }
    .scrollIndicators(.hidden)
    .frame(maxWidth: .infinity, minHeight: Constants.height, maxHeight: Constants.height, alignment: .leading)
  }
}
