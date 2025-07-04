//
// BeverageRecordListView.swift
// BeverageRecordList
//
// Created by 김규철 on 2025.
//

import SwiftUI

import CommonFeature
import DesignSystem
import BeverageDomain

public enum BeverageListType {
  /// 기본 리스트 + 검색 결과
  case list
  /// 검색
  case search
}

public struct BeverageRecordListView: View {
  @State private var viewModel: BeverageRecordListViewModel
  @Environment(Router.self) private var router
  
  @FocusState private var isFocus: Bool
  
  private enum Constants {
    static let navigationBarHeight: CGFloat = 56
    static let sugarProgressViewHeight: CGFloat = 110
    static let beverageFilterChipViewHeight: CGFloat = 68
    static let beverageSearchViewHeight: CGFloat = 36
  }
  
  public init(viewModel: BeverageRecordListViewModel) {
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
    .onChange(of: isFocus) { _, newValue in
      viewModel.handleAction(.searchBarFocusChanged(newValue))
    }
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
    }
    .padding(.horizontal, 20)
    .frame(height: Constants.navigationBarHeight)
    .background(.white)
  }
  
  private func contentView(_ height: CGFloat) -> some View {
    Group {
      switch viewModel.listType {
      case .list:
        beverageListView(height)
        
      case .search:
        beverageSearchView
      }
    }
    .padding(.horizontal, 20)
  }
  
  private var sugarProgressView: some View {
    AMDSugarStatusView(
      variant: .healthy,
      style: .main(sugar: 50, baseSugar: 100)
    )
    .frame(minHeight: Constants.sugarProgressViewHeight, maxHeight: Constants.sugarProgressViewHeight, alignment: .top)
  }
}

// MARK: - 음료 리스트 화면

private extension BeverageRecordListView {
  private func beverageListView(_ height: CGFloat) -> some View {
    Group {
      if viewModel.beverageList.isEmpty {
        beverageListEmptyView
      } else {
        VStack(spacing: 0) {
          beverageFilterChipView
          beverageList
        }
      }
    }
    .frame(maxWidth: .infinity, minHeight: height - Constants.navigationBarHeight)
  }
  
  private var beverageFilterChipView: some View {
    HStack(spacing: 4) {
      ForEach(BeverageFilterType.allCases, id: \.self) { type in
        AMDFilterChip(
          icon: type == .favorite ? AMDImage.liked18.swiftUIImage : nil,
          title: type != .favorite ? type.title : nil,
          count: 50,
          isSelected: type == viewModel.filterType,
          action: { viewModel.handleAction(.beverageFilterChipItemTapped(type)) }
        )
      }
    }
    .padding(.vertical, 16)
    .frame(maxWidth: .infinity, minHeight: Constants.beverageFilterChipViewHeight, maxHeight: Constants.beverageFilterChipViewHeight, alignment: .leading)
  }
  
  private var beverageList: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(viewModel.beverageList, id: \.productID) { beverage in
          AMDBeverageListView.large(
            thumbnailURL: beverage.thumbnailURL,
            brandTitle: beverage.brandName,
            beverageTitle: beverage.name,
            glucose: Double(beverage.sugar),
            kcal: Double(beverage.kcal),
            sugarFreeVariant: beverage.sugarFreeType?.sugarFreeVariant,
            favoriteState: .init(
              isFavorite: beverage.isFavorite,
              action: { viewModel.handleAction(.beverageListFavoriteTapped(beverage.isFavorite, beverage.productID)) }
            ),
            infoAction: { viewModel.handleAction(.beverageListInfoTapped(beverage.productID)) }
          )
        }
      }
    }
    .scrollIndicators(.hidden)
    .scrollDismissesKeyboard(.immediately)
    .padding(.bottom, Constants.sugarProgressViewHeight)
  }
  
  private var beverageListEmptyView: some View {
    VStack(alignment: .center) {
      Spacer()
      
      Text("해당 메뉴가 없어요")
        .amdFont(.largeBold)
        .foregroundStyle(.gray80)
      
      Spacer()
      
      VStack(spacing: 10) {
        Text("찾으시는 음료가 없으신가요?")
          .amdFont(.smallRegular)
          .foregroundStyle(.gray80)
        
        AMDFloatingButton(
          type: .secondary,
          title: "음료 추가 요청",
          rightIcon: nil,
          action: { viewModel.handleAction(.addBeverageButtonTapped) }
        )
      }
      
      Spacer()
      
      Spacer()
      
      Spacer()
    }
  }
}

// MARK: - 검색 화면

private extension BeverageRecordListView {
  private var beverageSearchView: some View {
    VStack(alignment: .leading, spacing: 40) {
      if !viewModel.recentSearchList.isEmpty {
        recentSearchList
      }
      
      frequentBeveragesView
      Spacer()
      Spacer()
    }
  }
  
  private var recentSearchList: some View {
    VStack(spacing: 10) {
      Text("최근 검색어")
        .amdFont(.mediumBold)
        .foregroundStyle(.gray85)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
      
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
      .frame(maxWidth: .infinity, minHeight: Constants.beverageSearchViewHeight, maxHeight: Constants.beverageSearchViewHeight, alignment: .leading)
    }
  }
  
  private var frequentBeveragesView: some View {
    VStack(spacing: 10) {
      Text("자주 마시는 음료")
        .amdFont(.mediumBold)
        .foregroundStyle(.gray85)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      VStack(spacing: 0) {
        ForEach(viewModel.frequentBeverageList, id: \.productID) { beverage in
          AMDBeverageListView.large(
            thumbnailURL: beverage.thumbnailURL,
            brandTitle: beverage.brandName,
            beverageTitle: beverage.name,
            glucose: Double(beverage.sugar),
            kcal: Double(beverage.kcal),
            sugarFreeVariant: beverage.sugarFreeType?.sugarFreeVariant,
            favoriteState: .init(
              isFavorite: beverage.isFavorite,
              action: { viewModel.handleAction(.beverageListFavoriteTapped(beverage.isFavorite, beverage.productID)) }
            ),
            infoAction: { viewModel.handleAction(.beverageListInfoTapped(beverage.productID)) }
          )
        }
      }
    }
  }
}
