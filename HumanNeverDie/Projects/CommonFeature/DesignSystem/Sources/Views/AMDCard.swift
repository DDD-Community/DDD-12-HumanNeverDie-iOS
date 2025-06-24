//
//  AMDCard.swift
//  DesignSystem
//
//  Created by 김규철 on 6/21/25.
//

import SwiftUI

public struct AMDCard: View {
  private let consumedGlucose: Double
  private let baseGlucose: Double
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
    consumedGlucose: Double,
    baseGlucose: Double,
    variant: AMDStatusVariant
  ) {
    self.consumedGlucose = consumedGlucose
    self.baseGlucose = baseGlucose
    self.variant = variant
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      title
      Spacer()
      characterImage
      glucoseText
      progress
    }
    .padding([.top, .horizontal], 30)
    .padding(.bottom, 24)
    .frame(width: 295, height: 384, alignment: .top)
    .background(backgroundGradient)
    .amdCornerRadius(.large)
  }
  
  private var title: some View {
    Text("\(variant.rawValue) 고미당")
      .amdFont(.largeBold)
      .foregroundStyle(.gray95)
      .frame(maxWidth: .infinity, alignment: .center)
  }
  
  private var image: some View {
    characterImage
      .resizable()
      .scaledToFill()
      .frame(width: 165, height: 165)
      .padding(.top, 34)
  }
  
  private var glucoseText: some View {
    AMDGlucoseValueLabel(
      consumedGlucose: consumedGlucose,
      baseGlucose: baseGlucose,
      variant: variant
    )
    .padding(.top, 24)
  }
  
  private var progress: some View {
    RoundedRectangle(cornerRadius: 20)
      .foregroundStyle(.phase2)
      .frame(maxWidth: .infinity, minHeight: 33, maxHeight: 33)
      .padding(.top, 20)
  }
}
