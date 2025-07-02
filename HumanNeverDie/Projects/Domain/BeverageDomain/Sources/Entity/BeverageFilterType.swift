//
//  BeverageFilterType.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/2/25.
//

import Foundation

public enum BeverageFilterType: CaseIterable {
  case all
  case lowSugar
  case zeroSugar
  case favorite
  
  public var title: String? {
    switch self {
    case .all:
      return "전체"
    case .lowSugar:
      return "저당"
    case .zeroSugar:
      return "무당"
    case .favorite:
      return nil
    }
  }
}
