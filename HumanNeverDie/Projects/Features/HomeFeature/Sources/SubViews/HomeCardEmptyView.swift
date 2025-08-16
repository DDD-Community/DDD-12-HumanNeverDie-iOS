//
//  HomeCardEmptyView.swift
//  HomeFeature
//
//  Created by 김규철 on 8/16/25.
//

import SwiftUI

import DesignSystem

struct HomeCardEmptyView: View {
  var body: some View {
    VStack(alignment: .center, spacing: 30) {
      emptyImage
      emptyTitle
    }
  }
  
  private var emptyImage: some View {
    AMDImage.homeEmpty.swiftUIImage
      .resizable()
      .scaledToFill()
      .frame(width: 215, height: 136)
  }
  
  private var emptyTitle: some View {
    Text("음료 기록이 없어요")
      .amdFont(.largeRegular)
      .foregroundStyle(.gray60)
      .frame(maxWidth: .infinity, alignment: .center)
  }
}
