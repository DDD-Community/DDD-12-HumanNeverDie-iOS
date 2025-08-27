//
//  BeverageRecordView.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/28/25.
//

import SwiftUI

import CommonFeature
import DesignSystem
import BeverageDomain

import NukeUI

public struct BeverageRecordView: View {
  @State private var viewModel: BeverageRecordViewModel
  @Environment(Router.self) private var router
    
  public init(viewModel: BeverageRecordViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    VStack(alignment: .center, spacing: 0) {
      navigationBar
      titleView
      beverageView
      beverageSizeView
      Spacer()
      Spacer()
      sugarProgressView
      recordButton
    }
    .padding(.horizontal, 20)
    .toolbarVisibility(.hidden, for: .navigationBar)
    .overlay {
      if viewModel.isBeverageRecordCompleted {
        beverageRecordCompletedView
          .transition(.opacity)
      }
    }
    .animation(.easeOut(duration: 0.4).delay(0.2), value: viewModel.isBeverageRecordCompleted)
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
      .padding(.top, 40)
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
        Text(viewModel.beverageDetail.brandType?.koreanName ?? "")
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
    .padding(.top, 40)
  }
  
  private var beverageSizeView: some View {
    VStack(spacing: 10) {
      if !viewModel.beverageDetail.sizes.isEmpty {
        ForEach(viewModel.beverageDetail.sizes, id: \.sizeType) { size in
          let sugarFreeType = BeverageSugarFreeType(sugar: Double(size.nutrition.sugar))
          
          AMDOptionButton(
            title: size.sizeType,
            subtitle: sugarFreeType?.sugarFreeVariant.rawValue,
            subtitleBadgeType: sugarFreeType?.sugarFreeVariant == .zero ? .primary : .yellow,
            sugarAndCaloriesText: AMDSugarAndCalories(
              suger: size.nutrition.sugar,
              caloriesText: size.nutrition.kcal
            ),
            isSelected: viewModel.selectedSizeType?.sizeType == size.sizeType,
            action: {
              viewModel.handleAction(.beverageSizeButtonTapped(size))
            }
          )
        }
      }
    }
    .padding(.top, 20)
  }
  
  private var sugarProgressView: some View {
    AMDSugarStatusView(
      variant: BeverageSugarStatusType(baseSugar: viewModel.baseSugar, totalSugar: viewModel.totalSugar).statusVariant,
      style: .record(sugar: viewModel.totalSugar, baseSugar: viewModel.baseSugar)
    )
    .frame(minHeight: 110, maxHeight: 110, alignment: .top)
  }
  
  private var recordButton: some View {
    AMDButton(
      title: "기록하기",
      action: { viewModel.handleAction(.recordButtonTapped) }
    )
    .padding(.vertical, 10)
  }
  
  private var beverageRecordCompletedView: some View {
    BeverageRecordCompletedView(
      beverageDetail: viewModel.beverageDetail,
      selectedSizeType: viewModel.selectedSizeType
    )
  }
}
