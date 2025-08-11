//
//  AMDGlucoseValueLabel.swift
//  DesignSystem
//
//  Created by 김규철 on 6/23/25.
//

import SwiftUI

public struct AMDGlucoseValueLabel: View {
  private let consumedGlucose: Double
  private let baseGlucose: Double
  private let type: LabelType
  private let variant: AMDStatusVariant
  
  public enum LabelType {
    case card
    case progress
    
    fileprivate var consumedGlucoseFont: AMDFont {
      switch self {
      case .card:
        return .xxlargeBold
      case .progress:
        return .largeBold
      }
    }
    
    fileprivate var slashFont: AMDFont {
      switch self {
      case .card:
        return .xlargeRegular
      case .progress:
        return .largeRegular
      }
    }
    
    fileprivate var baseGlucoseFont: AMDFont {
      switch self {
      case .card:
        return .xlargeRegular
      case .progress:
        return .largeRegular
      }
    }
  }
    
  private var textColor: Color {
    switch variant {
    case .healthy:
      return .primaryDarker
    case .warning:
      return .yellowDarker
    case .danger:
      return .redDarker
    }
  }
    
  public init(
    consumedGlucose: Double,
    baseGlucose: Double,
    type: LabelType = .card,
    variant: AMDStatusVariant
  ) {
    self.consumedGlucose = consumedGlucose
    self.baseGlucose = baseGlucose
    self.type = type
    self.variant = variant
  }
  
  public var body: some View {
    HStack(spacing: 2) {
      consumedGlucoseText
      slashText
      baseGlucoseText
    }
  }
  
  private var consumedGlucoseText: some View {
    Text("\(Int(consumedGlucose))")
      .amdFont(type.consumedGlucoseFont)
      .foregroundStyle(textColor)
      .amdNumericAnimation(Int(consumedGlucose))
  }
  
  private var slashText: some View {
    Text("\\")
      .amdFont(type.slashFont)
      .foregroundStyle(.gray40)
  }
  
  private var baseGlucoseText: some View {
    Text("\(Int(baseGlucose))g")
      .amdFont(type.baseGlucoseFont)
      .foregroundStyle(.gray60)
      .amdNumericAnimation(Int(consumedGlucose))
  }
}
