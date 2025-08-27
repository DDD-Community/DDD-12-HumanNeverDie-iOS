//
//  BeverageSugarFreeType.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/2/25.
//

import Foundation

public enum BeverageSugarFreeType: Sendable {
  case lowSugar
  case zeroSugar
  
  public init?(sugar: Double) {
    switch sugar {
    case 0:
      self = .zeroSugar
    case 1...8.9:
      self = .lowSugar
    default:
      return nil
    }
  }
}
