//
//  BeverageSearchEmptyView.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/11/25.
//

import SwiftUI

import DesignSystem

struct BeverageSearchEmptyView: View {
  private let type: SearchEmptyType
  @Bindable private var viewModel: BeverageSearchViewModel

  enum SearchEmptyType {
    case recentSearch
    case beverageList

    var title: String {
      switch self {
      case .recentSearch:
        return "최근 검색어가 없어요"
      case .beverageList:
        return "해당 메뉴가 없어요"
      }
    }
  }

  init(
    type: SearchEmptyType,
    viewModel: BeverageSearchViewModel
  ) {
    self.type = type
    self.viewModel = viewModel
  }

  var body: some View {
    VStack(alignment: .center) {
      Spacer()
      emptyTitleView
      addBeverageButtonView
      Spacer()
      Spacer()
      Spacer()
    }
  }

  private var emptyTitleView: some View {
    Text(type.title)
      .amdFont(.largeBold)
      .foregroundStyle(.gray80)
  }

  @ViewBuilder
  private var addBeverageButtonView: some View {
    switch type {
    case .recentSearch:
      Spacer()

    case .beverageList:
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
    }
  }
}
