//
//  BeverageRecordError.swift
//  BeverageDomain
//
//  Created by Claude on 8/24/25.
//

import Foundation

public enum BeverageRecordError: Error, LocalizedError, Equatable {
  case noSizeSelected
  
  public var errorDescription: String? {
    switch self {
    case .noSizeSelected:
      return "음료 사이즈가 선택되지 않았습니다."
    }
  }
}
