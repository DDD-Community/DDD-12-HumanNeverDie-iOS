//
//  BeverageRecordCompletedView.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 8/16/25.
//

import SwiftUI

import BeverageDomain
import CommonFeature
import DesignSystem

import Dependencies

public struct BeverageRecordCompletedView: View {
  @Environment(Router.self) private var router
  @Dependency(\.globalState) private var globalState
  
  private let beverageDetail: BeverageDetail
  private let selectedSizeType: BeverageSize?
  
  init(
    beverageDetail: BeverageDetail,
    selectedSizeType: BeverageSize?
  ) {
    self.beverageDetail = beverageDetail
    self.selectedSizeType = selectedSizeType
  }
  
  public var body: some View {
    ZStack {
      backgroundView
      contentView
      lottieEffectView
    }
    .toolbarVisibility(.hidden, for: .navigationBar)
  }
  
  private var backgroundView: some View {
    Color.white
      .ignoresSafeArea()
  }
  
  private var contentView: some View {
    VStack(spacing: 0) {
      topSpacerArea
      completionMessageSection
      middleSpacerArea
      infoSection
      bottomSpacerArea
      actionSection
    }
    .padding(.horizontal, 20)
  }
  
  private var lottieEffectView: some View {
    AMDLottieView(asset: .honeyEffect)
      .allowsHitTesting(false)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  private var topSpacerArea: some View {
    VStack {
      Spacer()
      Spacer()
    }
  }
  
  private var middleSpacerArea: some View {
    Spacer(minLength: 60)
  }
  
  private var bottomSpacerArea: some View {
    VStack {
      Spacer()
      Spacer()
    }
  }
  
  private var completionMessageSection: some View {
    VStack(spacing: 20) {
      successIconView
      completionTextView
    }
  }
  
  private var successIconView: some View {
    AMDImage.success48.swiftUIImage
  }
  
  private var completionTextView: some View {
    Text("음료 기록이 완료되었어요!")
      .amdFont(.xlargeBold)
      .foregroundStyle(.gray80)
      .frame(maxWidth: .infinity, alignment: .center)
  }
  
  private var infoSection: some View {
    VStack(spacing: 16) {
      sugarInfoView
      beverageCardView
    }
    .padding(.vertical, 20)
  }
  
  private var actionSection: some View {
    closeButton
  }
  
  private var sugarInfoView: some View {
    HStack(alignment: .center, spacing: 4) {
      Text("당류")
        .amdFont(.mediumMedium)
        .foregroundStyle(.gray80)
      
      Text("\(selectedSizeType?.nutrition.sugar ?? 0)g")
        .amdFont(.xlargeBold)
        .foregroundStyle(.gray85)
      
      Text("획득")
        .amdFont(.mediumMedium)
        .foregroundStyle(.gray80)
    }
  }
  
  private var beverageCardView: some View {
    AMDBeverageListView.completed(
      thumbnailURL: beverageDetail.thumbnailURL,
      brandTitle: beverageDetail.brandName,
      beverageSize: selectedSizeType?.sizeType ?? "",
      beverageTitle: beverageDetail.name,
      glucose: Double(selectedSizeType?.nutrition.sugar ?? 0),
      kcal: Double(selectedSizeType?.nutrition.kcal ?? 0),
      sugarFreeVariant: BeverageSugarFreeType(sugar: Double(selectedSizeType?.nutrition.sugar ?? 0))?.sugarFreeVariant
    )
  }
  
  private var closeButton: some View {
    AMDButton(
      title: "닫기",
      action: {
        Task {
          await globalState.sendEvent(.homeRefresh)
          await globalState.sendEvent(.historyRefresh)
          await MainActor.run { router.popToRoot() }
        }
      }
    )
    .padding(.bottom, 10)
  }
}
