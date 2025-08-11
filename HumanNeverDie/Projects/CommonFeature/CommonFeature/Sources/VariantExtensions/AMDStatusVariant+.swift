//
//  AMDStatusVariant+.swift
//  CommonFeature
//
//  Created by 김규철 on 8/11/25.
//

import Foundation

import DesignSystem
import BeverageDomain

public extension BeverageSugarStatusType {
  /// BeverageSugarStatusType → AMDStatusVariant 변환
  var statusVariant: AMDStatusVariant {
    switch self {
    case .healthy:
      return .healthy
    case .warning:
      return .warning
    case .danger:
      return .danger
    }
  }
}
