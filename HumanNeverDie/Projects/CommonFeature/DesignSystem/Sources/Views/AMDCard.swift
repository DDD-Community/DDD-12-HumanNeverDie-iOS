//
//  AMDCard.swift
//  DesignSystem
//
//  Created by 김규철 on 6/21/25.
//

import SwiftUI

public struct AMDCard: View {
  private let totalSugar: Int
  private let baseSugar: Int
  private let variant: AMDStatusVariant
    
  private var characterImage: Image {
    switch variant {
    case .healthy:
      return AMDImage.homeHealthyCharacter.swiftUIImage
    case .warning:
      return AMDImage.homeWarningCharacter.swiftUIImage
    case .danger:
      return AMDImage.homeDangerCharacter.swiftUIImage
    }
  }
  
  private var backgroundGradient: LinearGradient {
    switch variant {
    case .healthy:
      return .cardHealthy
    case .warning:
      return .cardWarning
    case .danger:
      return .cardDanger
    }
  }
  
  public init(
    totalSugar: Int,
    baseSugar: Int,
    variant: AMDStatusVariant
  ) {
    self.totalSugar = totalSugar
    self.baseSugar = baseSugar
    self.variant = variant
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      characterImage
      title
      sugarText
      progress
    }
    .padding(.horizontal, 30)
    .padding(.bottom, 24)
    .frame(width: 295, height: 384, alignment: .bottom)
    .background(backgroundGradient)
    .amdCornerRadius(.large)
  }
    
  private var image: some View {
    characterImage
      .resizable()
      .scaledToFill()
      .frame(width: 165, height: 165)
      .padding(.top, 40)
  }
  
  private var title: some View {
    Text("\(variant.rawValue) 고미당")
      .amdFont(.largeBold)
      .foregroundStyle(.gray95)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.top, 10)
  }
  
  private var sugarText: some View {
    AMDGlucoseValueLabel(
      consumedGlucose: Double(totalSugar),
      baseGlucose: Double(baseSugar),
      variant: variant
    )
    .padding(.top, 27)
  }
  
  private var progress: some View {
    AMDProgress(
      glucose: Double(totalSugar),
      type: .small,
      variant: variant
    )
    .padding(.top, 18)
  }
}
