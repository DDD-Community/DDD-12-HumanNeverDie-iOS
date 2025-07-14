//
//  BeverageFilterType.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/2/25.
//

import Foundation

public enum BeverageFilterType: CaseIterable, Sendable {
  case all
  case zero
  case low
  case like
  
  public var title: String? {
    switch self {
    case .all:
      return "전체"
    case .zero:
      return "무당"
    case .low:
      return "저당"
    case .like:
      return nil
    }
  }
}
