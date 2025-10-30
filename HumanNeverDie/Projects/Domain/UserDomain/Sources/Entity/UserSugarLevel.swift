//
//  UserSugarLevel.swift
//  UserDomain
//
//  Created by Seulki Lee on 10/20/25.
//

import Foundation

public struct UserSugarLevel: Equatable, Sendable {
  public let message: String
  public let status: Int
  public let data: SugarData
  
  public init(message: String, status: Int, data: SugarData) {
    self.message = message
    self.status = status
    self.data = data
  }
}

public struct SugarData: Equatable, Sendable {
  public let easy: SugarLevel
  public let normal: SugarLevel
  public let hard: SugarLevel
  
  public init(easy: SugarLevel, normal: SugarLevel, hard: SugarLevel) {
    self.easy = easy
    self.normal = normal
    self.hard = hard
  }
}

public struct SugarLevel: Equatable, Sendable {
  public let sugarMaxG: Int
  public let sugarIdealG: Int
  
  public init(sugarMaxG: Int, sugarIdealG: Int) {
    self.sugarMaxG = sugarMaxG
    self.sugarIdealG = sugarIdealG
  }
}

public extension UserSugarLevel {
  static func mock() -> UserSugarLevel {
    return UserSugarLevel(
      message: "OK",
      status: 200,
      data: SugarData(
        easy: SugarLevel(sugarMaxG: 76, sugarIdealG: 38),
        normal: SugarLevel(sugarMaxG: 38, sugarIdealG: 19),
        hard: SugarLevel(sugarMaxG: 15, sugarIdealG: 8)
      )
    )
  }
}

