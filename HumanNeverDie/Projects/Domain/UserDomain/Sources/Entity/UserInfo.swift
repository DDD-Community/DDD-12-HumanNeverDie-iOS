//
//  UserInfo.swift
//  CommonFeature
//
//  Created by Seulki Lee on 7/23/25.
//

import SwiftUI

public struct UserInfo: Equatable, Sendable, Hashable {
  public let nickname: String
  public let birthDate: String
  public let selectedGender: Gender
  public let height: Int
  public let weight: Int
  public let selectedActivity: ActivityLevel
  public let selectedDailySugarGoal: SugarGoal
  public var sugarMaxG : Int
  public var sugarIdealG : Int
  
  
  public init(
    nickname: String,
    birthDate: String,
    selectedGender: Gender,
    height: Int,
    weight: Int,
    selectedActivity: ActivityLevel,
    selectedDailySugarGoal: SugarGoal,
    sugarMaxG : Int = 0,
    sugarIdealG : Int = 0
  ) {
    self.nickname = nickname
    self.birthDate = birthDate
    self.selectedGender = selectedGender
    self.height = height
    self.weight = weight
    self.selectedActivity = selectedActivity
    self.selectedDailySugarGoal = selectedDailySugarGoal
    self.sugarMaxG = sugarMaxG
    self.sugarIdealG = sugarIdealG
  }
  
  public static let defaultUserInfo = UserInfo(
    nickname: "",
    birthDate: "",
    selectedGender: .none,
    height: 0,
    weight: 0,
    selectedActivity: .none,
    selectedDailySugarGoal: .none,
    sugarMaxG: 0,
    sugarIdealG: 0
  )
  
}


public extension UserInfo {
  static func mock() -> UserInfo {
    UserInfo.defaultUserInfo
  }
}
