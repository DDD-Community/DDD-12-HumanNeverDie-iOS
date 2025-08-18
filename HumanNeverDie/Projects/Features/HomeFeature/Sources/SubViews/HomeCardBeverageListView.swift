//
//  HomeCardBeverageListView.swift
//  HomeFeature
//
//  Created by 김규철 on 8/16/25.
//

import SwiftUI

import BeverageDomain
import DesignSystem

struct HomeCardBeverageListView: View {
 private var beverageCalendar: BeverageCalendar?
  
  init(beverageCalendar: BeverageCalendar?) {
    self.beverageCalendar = beverageCalendar
  }
  
  var body: some View {
    VStack(spacing: 10) {
      headerView
      beverageListView
    }
    .padding(.top, 20)
    .frame(width: 295, height: 384)
    .background(AMDGradient.cardDefault)
    .amdStrokeBorder(.gray25, radius: .large, linewidth: 1)
    .amdShadow(.card)
  }
  
  private var headerView: some View {
    HStack {
      Text("총 \(beverageCalendar?.records.count ?? 0)잔")
        .amdFont(.largeBold)
        .foregroundStyle(.gray85)
      
      Spacer()
      
      AMDGlucoseValueLabel(
        consumedGlucose: Double(beverageCalendar?.totalSugarGrams ?? 0),
        baseGlucose: 50,
        variant: sugarStatusVariant
      )
    }
    .padding(.horizontal, 20)
  }
  
  private var beverageListView: some View {
    Group {
      if let beverageCalendar {
        ScrollView {
          LazyVStack(spacing: 0) {
            ForEach(beverageCalendar.records, id: \.intakeHistoryId) { item in
              beverageItemView(item)
            }
          }
        }
      }
    }
  }
  
  private func beverageItemView(_ item: BeverageCalendarRecoders) -> some View {
    AMDBeverageListView.card(
      thumbnailURL: item.imgUrl,
      brandTitle: item.cafeBrand,
      beverageSize: item.beverageSize,
      beverageTitle: item.beverageName,
      glucose: Double(item.sugarG),
      kcal: Double(item.servingKcal),
      sugarFreeVariant: BeverageSugarFreeType(sugar: item.sugarG)?.sugarFreeVariant
    )
  }
  
  private var sugarStatusVariant: AMDStatusVariant {
    BeverageSugarStatusType(
      baseSugar: 50,
      totalSugar: beverageCalendar?.totalSugarGrams ?? 0
    ).statusVariant
  }
}
