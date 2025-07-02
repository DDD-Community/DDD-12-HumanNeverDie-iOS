//
//  AMDSugarStatusView.swift
//  DesignSystem
//
//  Created by 김규철 on 7/2/25.
//

import SwiftUI

public struct AMDSugarStatusView: View {
  private let variant: AMDStatusVariant
  private let sugar: Int
  private let baseSugar: Int
  
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
    baseSugar: Int
  ) {
    self.variant = variant
    self.sugar = sugar
    self.baseSugar = baseSugar
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: 18) {
      characterImage
      
      VStack(spacing: 10) {
        contentView
        progressBar
      }
    }
    .padding(.horizontal, 20)
    .amdDivider(isTop: true, isBottom: true)
    .frame(minHeight: 84, maxHeight: 84)
    .background(.white)
    .amdShadow(.tabbar)
  }
  
  private var contentView: some View {
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
  
  private var progressBar: some View {
    AMDProgress(
      glucose: Double(sugar) / Double(baseSugar),
      isStatusLabelHidden: true,
      type: .small,
      variant: variant
    )
  }
}
