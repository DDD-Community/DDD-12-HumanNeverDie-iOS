//
//  BeverageDetailView.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/12/25.
//

import SwiftUI

import CommonFeature
import DesignSystem
import BeverageDomain

public struct BeverageDetailView: View {
  @State private var viewModel: BeverageDetailViewModel
  
  public init(productID: String) {
    self.viewModel = .init(productID: productID)
  }
  
  public var body: some View {
    contentView
    
  }
  
  @ViewBuilder
  private var contentView: some View {
    if let beverageDetail = viewModel.beverageDetail {
      VStack(spacing: 0) {
        titleView(brandName: beverageDetail.brandName, name: beverageDetail.name)
        sizeView
        infoView(beverageDetail)
      }
      .padding([.top, .horizontal], 20)
    }
  }
  
  private func titleView(brandName: String, name: String) -> some View {
    VStack(spacing: 10) {
      Text(brandName)
        .amdFont(.smallRegular)
        .foregroundStyle(.gray70)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text(name)
        .amdFont(.largeBold)
        .foregroundStyle(.gray80)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.vertical, 10)
  }
  
  // 백엔드 사이즈 별 리스폰스 업데이트 이후 수정
  private var sizeView: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 4) {
        ForEach(BeverageDetailViewModel.Size.allCases, id: \.self) { size in
          AMDFilterChip(
            title: size.rawValue,
            isSelected: viewModel.size == size,
            action: { viewModel.handleAction(.sizeItemTapped(size)) }
          )
        }
      }
    }
    .scrollIndicators(.hidden)
    .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36, alignment: .leading)
    .padding(.vertical, 8)
  }
  
  /*
   탄수화물
   지방
   콜레스테롤
   트랜스지방
   4개 정보 백엔드 미존재
   */
  private func infoView(_ beverageDetail: BeverageDetail) -> some View {
    VStack(spacing: 12) {
      infoItemView(title: "1회 제공량", info: "\(beverageDetail.kcal)kcal")
      infoItemView(title: "탄수화물", info: "\(0)g")
      infoItemView(title: "당류", info: "\(beverageDetail.sugar)g")
      infoItemView(title: "나트륨", info: "\(beverageDetail.sodium)mg")
      infoItemView(title: "단백질", info: "\(beverageDetail.protein)g")
      infoItemView(title: "지방", info: "\(0)g")
      infoItemView(title: "콜레스테롤", info: "\(0)mg")
      infoItemView(title: "트랜스지방", info: "\(0)g")
      infoItemView(title: "카페인", info: "\(beverageDetail.caffeine)mg")
      infoItemView(title: "포화지방", info: "\(beverageDetail.saturatedFat)g")
    }
    .padding(.vertical, 10)
  }
  
  private func infoItemView(title: String, info: String) -> some View {
    HStack {
      Text(title)
        .amdFont(.mediumRegular)
        .foregroundStyle(.gray85)
        .frame(alignment: .leading)
      
      Text(info)
        .amdFont(.mediumRegular)
        .foregroundStyle(.gray60)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
  }
}
