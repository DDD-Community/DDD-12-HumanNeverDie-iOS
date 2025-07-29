//
//  BeverageSearchView.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/10/25.
//

import SwiftUI
import AsyncAlgorithms

import CommonFeature
import DesignSystem
import Shared

public struct BeverageSearchView: View {
  @State private var viewModel: BeverageSearchViewModel
  @Environment(Router.self) private var router
  
  @FocusState private var isFocus: Bool
  private let searchChannel = AsyncChannel<String>()
  
  private enum Constants {
    static let navigationBarHeight: CGFloat = 56
    static let sugarStatusViewHeight: CGFloat = 110
  }
  
  public init(viewModel: BeverageSearchViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        navigationBar
        contentView(geometry.size.height)
      }
    }
    .overlay(alignment: .bottom) {
      sugarProgressView
    }
    .ignoresSafeArea([.keyboard, .container], edges: .bottom)
    .toolbarVisibility(.hidden, for: .navigationBar)
    .amdSwipeBackEnabled()
    .onAppear { isFocus = true }
  }
  
  private var navigationBar: some View {
    HStack(spacing: 18) {
      Button {
        router.pop()
      } label: {
        AMDImage.arrowLeft24.swiftUIImage
      }
      
      AMDTextField(
        text: Binding(
          get: { viewModel.searchText },
          set: { viewModel.handleAction(.searchTextChanged($0)) }
        ),
        isFocused: $isFocus,
        placeholder: "음료 이름 검색",
        hiddenClearButton: false,
        rightButtonType: .search
      )
      .debounce($viewModel.state.searchText, using: searchChannel, for: .seconds(1.0)) {
        viewModel.handleAction(.debounceSearchTextChanged($0))
      }
          
    }
    .padding(.horizontal, 20)
    .frame(height: Constants.navigationBarHeight)
    .background(.white)
  }
  
  @ViewBuilder
  private func contentView(_ height: CGFloat) -> some View {
    switch viewModel.searchType {
    case .search:
      beverageSearchView
      
    case .list:
      beverageSearchListView(height)
    }
  }
  
  private var sugarProgressView: some View {
    AMDSugarStatusView(
      variant: .healthy,
      style: .main(sugar: 50, baseSugar: 100)
    )
    .frame(minHeight: Constants.sugarStatusViewHeight, maxHeight: Constants.sugarStatusViewHeight, alignment: .top)
  }
}
// MARK: - 검색 화면

private extension BeverageSearchView {
  private var beverageSearchView: some View {
    Group {
      if !viewModel.recentSearchList.isEmpty {
        recentSearchListView
      } else {
        recentSearchEmptyView
      }
    }
    .padding(.horizontal, 20)
  }
  
  private var recentSearchListView: some View {
    VStack(spacing: 0) {
      BevergeRecentSearchListView(viewModel: viewModel)
      Spacer()
      Spacer()
      Spacer()
    }
    .padding(.top, 20)
  }
  
  private var recentSearchEmptyView: some View {
    BeverageSearchEmptyView(type: .recentSearch, viewModel: viewModel)
  }
}

// MARK: - 검색 결과 음료 리스트 화면

private extension BeverageSearchView {
  private func beverageSearchListView(_ height: CGFloat) -> some View {
    Group {
      if !viewModel.isBeverageListEmpty {
        beverageListView
      } else {
        beverageListEmptyView
      }
    }
    .frame(maxWidth: .infinity, minHeight: height - Constants.navigationBarHeight)
  }
  
  private var beverageListView: some View {
    BeverageListView(viewModel: viewModel.listViewModel)
  }
  
  private var beverageListEmptyView: some View {
    BeverageSearchEmptyView(type: .beverageList, viewModel: viewModel)
  }
}

