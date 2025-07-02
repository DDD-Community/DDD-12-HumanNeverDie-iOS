//
//  AMDSugarStatusView.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 7/3/25.
//

import SwiftUI
import DesignSystem

public struct AMDSugarStatusView: View {
  private let variant: AMDStatusVariant
  private let sugar: Int
  private let baseSugar: Int
  private let drinkCount: Int
  
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
    sugar: Int,
    baseSugar: Int,
    drinkCount: Int
  ) {
    self.variant = variant
    self.sugar = sugar
    self.baseSugar = baseSugar
    self.drinkCount = drinkCount
  }
  
  public var body: some View {
    VStack(spacing:0) {
      VStack(alignment: .center, spacing: 4) {
        HStack(spacing: 10) {
          characterImage
          contentView
        }
        progressBar
      }
      .padding(.vertical, 10)
      .frame(minHeight: 87, maxHeight: 87)
      
    }
    .amdDivider(isTop: true, isBottom: false)
    .padding(.horizontal, 8)
    .background(Color.white)
    
  }
  
  private var contentView:  some View {
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
  
  private var progressBar: some View {
    AMDProgress(
      glucose: Double(sugar) / Double(baseSugar),
      isStatusLabelHidden: false,
      type: .small,       variant: variant
    )
  }
}
