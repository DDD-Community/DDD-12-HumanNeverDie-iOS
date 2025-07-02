//
//  AMDSugarFreeVariant+.swift
//  CommonFeature
//
//  Created by 김규철 on 7/2/25.
//

import Foundation

import DesignSystem
import BeverageDomain

public extension BeverageSugarFreeType {
  /// BeverageSugarFreeType → AMDSugarFreeVariant 변환
  var sugarFreeVariant: AMDSugarFreeVariant {
    switch self {
    case .lowSugar:
      return .low
    case .zeroSugar:
      return .zero
    }
  }
}
