//
//  BeverageBrandType.swift
//  BeverageDomain
//
//  Created by 김규철 on 8/27/25.
//

import Foundation

public enum BeverageBrandType: String, Sendable {
  case starbucks = "STARBUCKS"
  
  public var koreanName: String {
    switch self {
    case .starbucks:
      return "스타벅스"
    }
  }
  
  public init?(rawValue: String) {
    switch rawValue.uppercased() {
    case "STARBUCKS":
      self = .starbucks
    default:
      return nil
    }
  }
}