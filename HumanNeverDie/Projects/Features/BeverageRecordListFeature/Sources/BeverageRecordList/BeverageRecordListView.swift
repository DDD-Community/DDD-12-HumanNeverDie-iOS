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

import Dependencies

public struct BeverageRecordListView: View {
  @State private var viewModel: BeverageRecordListViewModel
  @Environment(Router.self) private var router
  @Dependency(\.globalState) private var globalState


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
    .onReceive(globalState.beverageLikeUpdatePublisher) { likeUpdate in
      viewModel.handleAction(.beverageLikeStatusChanged(
        productID: likeUpdate.productID,
        isLiked: likeUpdate.isLiked
      ))
    }
    .onChange(of: viewModel.route) { _, route in
      guard let route else { return }
      router.push(to: route)
      viewModel.handleAction(.clearRoute)
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
        router.push(to: .beverageSearch(recordDate: viewModel.beverageRecordDate))
      }
    }
    .padding(.horizontal, 20)
    .frame(height: Constants.navigationBarHeight)
    .background(.white)
  }

  private var contentView: some View {
    VStack(spacing: 0) {
      filterinfoView
      BeverageListView(viewModel: viewModel.listViewModel)
    }
  }
  
  private var filterinfoView: some View {
    VStack {
      HStack(spacing: 0) {
        Text("저당/무당 기준이 궁금하다면?")
          .amdFont(.smallRegular)
          .foregroundStyle(.gray60)
        
        AMDImage.arrowRight18.swiftUIImage
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 10)
      .onTapGesture {
        viewModel.handleAction(.filterinfoViewTapped)
      }
      .padding(.horizontal, 20)
      
      AMDDevider()
    }
    .frame(minHeight: 40, maxHeight: 40)
    .padding(.top, 4)
  }

  private var sugarProgressView: some View {
    AMDSugarStatusView(
      variant: BeverageSugarStatusType(baseSugar: viewModel.baseSugar, totalSugar: viewModel.totalSugar).statusVariant,
      style: .main(sugar: viewModel.totalSugar, baseSugar: viewModel.baseSugar)
    )
    .frame(minHeight: Constants.sugarStatusViewHeight, maxHeight: Constants.sugarStatusViewHeight, alignment: .top)
  }
}
