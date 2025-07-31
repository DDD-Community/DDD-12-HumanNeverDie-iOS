//
//  BeverageRecordView.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/28/25.
//

import SwiftUI

import CommonFeature
import DesignSystem

import NukeUI

public struct BeverageRecordView: View {
  @State private var viewModel: BeverageRecordViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: BeverageRecordViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    VStack(alignment: .center, spacing: 40) {
      navigationBar
      titleView
      beverageView
      beverageSizeView
      Spacer()
      recordButton
    }
    .padding(.horizontal, 24)
    .toolbarVisibility(.hidden, for: .navigationBar)
  }
  
  private var navigationBar: some View {
    HStack(spacing: 0) {
      Button {
        router.pop()
      } label: {
        AMDImage.arrowLeft24.swiftUIImage
      }
      
      Spacer()
    }
    .frame(height: 56)
  }
  
  private var titleView: some View {
    Text("음료 사이즈를 선택해주세요")
      .amdFont(.xlargeBold)
      .foregroundStyle(.gray80)
  }
  
  
  private var beverageView: some View {
    HStack(alignment: .center, spacing: 0) {
      LazyImage(url: URL(string: viewModel.beverageDetail.thumbnailURL)) { image in
        image.image?
          .resizable()
          .scaledToFill()
          .frame(width: 56, height: 56)
          .amdCornerRadius(.small)
      }
      
      VStack(alignment: .leading, spacing: 4) {
        Text(viewModel.beverageDetail.brandName)
          .amdFont(.smallRegular)
          .foregroundStyle(.gray60)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text(viewModel.beverageDetail.name)
          .amdFont(.mediumMedium)
          .foregroundStyle(.gray80)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.leading, 12)
      
      Button {
        viewModel.handleAction(.likeButtonTapped)
      } label: {
        Group {
          if viewModel.isLiked {
            AMDImage.liked24.swiftUIImage
          } else {
            AMDImage.unliked24.swiftUIImage
          }
        }
        .animation(.bouncy(duration: 0.6, extraBounce: 0.2), value: viewModel.isLiked)
      }
    }
    .padding(.vertical, 16)
    .padding(.horizontal, 20)
    .background(.gray10)
    .amdCornerRadius(.large)
  }
  
  private var beverageSizeView: some View {
    AMDOptionButton(
      title: "Tall",
      subtitle: "저당",
      subtitleBadgeType: .yellow,
      sugarAndCaloriesText: AMDSugarAndCalories(suger: 4, caloriesText: 140),
      isSelected: true,
      action: {}
    )
  }
  
  private var recordButton: some View {
    AMDButton(
      title: "기록하기",
      action: {}
    )
  }
}
