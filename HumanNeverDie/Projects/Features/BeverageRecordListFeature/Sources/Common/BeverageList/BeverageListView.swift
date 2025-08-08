//
//  BeverageListView.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/10/25.
//

import SwiftUI

import BeverageDomain
import CommonFeature
import DesignSystem

struct BeverageListView: View {
  @Bindable private var viewModel: BeverageListViewModel
  
  init(viewModel: BeverageListViewModel) {
    self.viewModel = viewModel
  }
  
  private enum Constants {
    static let beverageFilterChipViewHeight: CGFloat = 68
    static let scrollViewBottomPadding: CGFloat = 110
  }
  
  var body: some View {
    VStack(spacing: 0) {
      beverageFilterChipView
      beverageList
    }
    .padding(.horizontal, 20)
    .amdBottomSheet(isPresented: $viewModel.state.isBevarageDetailPresented, detents: [.height(474)]) {
      AMDBeverageDetailView(productID: viewModel.beverageProductID)
    }
  }
  
  private var beverageFilterChipView: some View {
    HStack(spacing: 4) {
      ForEach(BeverageFilterType.allCases, id: \.self) { type in
        AMDFilterChip(
          icon: type == .like ? AMDImage.liked18.swiftUIImage : nil,
          title: type == .like ? nil : type.title,
          count: viewModel.filterCount.toValue(type),
          isSelected: viewModel.filterType == type,
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
        ForEach(Array(viewModel.beverageList.enumerated()), id: \.element.id) { index, beverage in
          AMDBeverageListView.large(
            thumbnailURL: beverage.thumbnailURL,
            brandTitle: beverage.brandName,
            beverageTitle: beverage.name,
            glucose: Double(beverage.sugar),
            kcal: Double(beverage.kcal),
            sugarFreeVariant: beverage.sugarFreeType?.sugarFreeVariant,
            likeState: .init(
              isLiked: beverage.isLiked,
              action: { viewModel.handleAction(.beverageListFavoriteTapped(index, beverage)) }
            ),
            infoAction: { viewModel.handleAction(.beverageListInfoTapped(beverage.productID)) }
          )
          .onTapGesture {
            viewModel.handleAction(.beverageListItemTapped(beverage))
          }
        }
      }
      .scrollTargetLayout()
    }
    .onScrollTargetVisibilityChange(idType: Beverage.ID.self) { item in
      viewModel.handleAction(.loadNextBeverageList(item))
    }
    .scrollIndicators(.hidden)
    .scrollDismissesKeyboard(.immediately)
    .padding(.bottom, Constants.scrollViewBottomPadding)
  }
}
