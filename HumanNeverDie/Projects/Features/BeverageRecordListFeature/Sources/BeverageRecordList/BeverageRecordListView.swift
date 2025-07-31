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

public struct BeverageRecordListView: View {
  @State private var viewModel: BeverageRecordListViewModel
  @Environment(Router.self) private var router
  
  private enum Constants {
    static let navigationBarHeight: CGFloat = 56
    static let sugarStatusViewHeight: CGFloat = 110
  }
  
  public init(viewModel: BeverageRecordListViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      navigationBar
      contentView
    }
    .overlay(alignment: .bottom) {
      sugarProgressView
    }
    .ignoresSafeArea([.keyboard, .container], edges: .bottom)
    .toolbarVisibility(.hidden, for: .navigationBar)
    .amdSwipeBackEnabled()
    .onChange(of: viewModel.route) { _, route in
      guard let route else { return }
      router.push(to: route)
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
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
        text: .constant(""),
        placeholder: "음료 이름 검색",
        hiddenClearButton: false,
        rightButtonType: .search
      )
      .disabled(true)
      .onTapGesture {
        router.push(to: .beverageSearch)
      }
    }
    .padding(.horizontal, 20)
    .frame(height: Constants.navigationBarHeight)
    .background(.white)
  }
  
  private var contentView: some View {
    BeverageListView(viewModel: viewModel.listViewModel)
  }
  
  private var sugarProgressView: some View {
    AMDSugarStatusView(
      variant: .healthy,
      style: .main(sugar: 50, baseSugar: 100)
    )
    .frame(minHeight: Constants.sugarStatusViewHeight, maxHeight: Constants.sugarStatusViewHeight, alignment: .top)
  }
}
