//
//  BeverageSugarStatusType.swift
//  BeverageDomain
//
//  Created by 김규철 on 8/11/25.
//

import Foundation

public enum BeverageSugarStatusType: Sendable {
  case healthy
  case warning
  case danger
  
  public init(baseSugar: Int, totalSugar: Int) {
    guard baseSugar > 0 else {
      self = .healthy
      return
    }
    
    let percentage = Double(totalSugar) / Double(baseSugar) * 100
    
    switch percentage {
    case 0...33:
      self = .healthy
    case 34...66:
      self = .warning
    default:
      self = .danger
    }
  }
}
