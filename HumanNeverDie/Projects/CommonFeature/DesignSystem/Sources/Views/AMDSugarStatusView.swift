//
//  AMDSugarStatusView.swift
//  DesignSystem
//
//  Created by 김규철 on 7/2/25.
//

import SwiftUI

public struct AMDSugarStatusView: View {
  public enum Style {
    case main(sugar: Int, baseSugar: Int)
    case history(drinkCount: Int, sugar: Int, baseSugar: Int)
  }

  private let variant: AMDStatusVariant
  private let style: Style
  
  private var characterImage: Image {
    switch variant {
    case .healthy:
      return AMDImage.healthyCharacter.swiftUIImage
    case .warning:
      return AMDImage.warningCharacter.swiftUIImage
    case .danger:
      return AMDImage.dangerCharacter.swiftUIImage
    }
  }
  
  public init(
    variant: AMDStatusVariant,
    style: Style
  ) {
    self.variant = variant
    self.style = style
  }
  
  public var body: some View {
    switch style {
    case .main(let base, let sugar):
      mainStyleBody(baseSugar: base, sugar: sugar)
      
    case .history(let drinkCount, let baseSugar, let sugar):
      historyStyleBody(drinkCount: drinkCount, baseSugar: baseSugar, sugar: sugar)
    }
  }
  
  private func mainStyleBody(baseSugar: Int, sugar: Int) -> some View {
    HStack(alignment: .center, spacing: 18) {
      characterImage
      
      VStack(spacing: 10) {
        contentMainView(baseSugar: baseSugar, sugar: sugar)
        progressBar(baseSugar: baseSugar, sugar: sugar)
      }
    }
    .padding(.horizontal, 20)
    .amdDivider(isTop: true, isBottom: true)
    .frame(minHeight: 84, maxHeight: 84)
    .background(.white)
    .amdShadow(.tabbar)
  }
  
  private func contentMainView(baseSugar: Int, sugar: Int) -> some View {
    HStack {
      HStack(spacing: 4) {
        Text("\(baseSugar - sugar)g")
          .amdFont(.largeBold)
          .foregroundStyle(.gray85)
        
        Text("더 마실 수 있당!")
          .amdFont(.largeRegular)
          .foregroundStyle(.gray70)
      }
      
      Spacer()
      
      AMDGlucoseValueLabel(
        consumedGlucose: Double(sugar),
        baseGlucose: Double(baseSugar),
        type: .progress,
        variant: variant
      )
    }
  }
  
  private func historyStyleBody(drinkCount: Int, baseSugar: Int, sugar: Int) -> some View {
    VStack(spacing:0) {
      VStack(alignment: .center, spacing: 4) {
        HStack(spacing: 10) {
          characterImage
          contentHistoryView(drinkCount: drinkCount, baseSugar: baseSugar, sugar: sugar)
      
        }
        progressBar(baseSugar: baseSugar, sugar: sugar)
      }
      .frame(minHeight: 87, maxHeight: 87)
      
    }
    .padding(.vertical, 10)
    .background(Color.white)
  }
  
  private func contentHistoryView(drinkCount: Int, baseSugar: Int, sugar: Int) -> some View {
    HStack(spacing: 4.5){
      HStack(spacing: 2) {
        Text("총 ")
          .amdFont(.largeRegular)
          .foregroundStyle(.gray70)
        
        Text("\(drinkCount)잔")
          .amdFont(.largeBold)
          .foregroundStyle(.gray85)
        
        Text("이당!")
          .amdFont(.largeRegular)
          .foregroundStyle(.gray70)
      }
      
      Spacer()
      
      VStack {
        Text("총 당 섭취량")
          .amdFont(.xsmallRegular)
          .foregroundStyle(.gray50)
        
        AMDGlucoseValueLabel(
          consumedGlucose: Double(sugar),
          baseGlucose: Double(baseSugar),
          type: .progress,
          variant: variant
        )
      }
    }
  }
  
  private func progressBar(baseSugar: Int, sugar: Int) -> some View {
    AMDProgress(
      glucose: Double(sugar) / Double(baseSugar),
      isStatusLabelHidden: true,
      type: .small,
      variant: variant
    )
  }
}
