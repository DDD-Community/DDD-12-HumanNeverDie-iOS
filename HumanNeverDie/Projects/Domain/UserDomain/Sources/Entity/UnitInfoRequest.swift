//
//  UnitInfoRequest.swift
//  UserDomain
//
//  Created by Seulki Lee on 8/15/25.
//

import SwiftUI

public struct UnitInfoRequest: Equatable, Sendable {
  public let nickname: String
  public let birthDate: String
  public let selectedGender: Gender
  public let height: Int
  public let weight: Int
  public let selectedActivity: ActivityLevel
  public let selectedDailySugarGoal: SugarGoal
  public let sugarMaxG : Int
  public let sugarIdealG : Int
  
  public init(
    nickname: String,
    birthDate: String,
    selectedGender: Gender,
    height: Int,
    weight: Int,
    selectedActivity: ActivityLevel,
    selectedDailySugarGoal: SugarGoal,
    sugarMaxG : Int,
    sugarIdealG : Int
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
  
  public static let defaultUserInfo = UnitInfoRequest(
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
  
  public func toUserInfo() -> UserInfo {
    return UserInfo(
      nickname: nickname,
      birthDate: birthDate,
      selectedGender: selectedGender,
      height: height,
      weight: weight,
      selectedActivity: selectedActivity,
      selectedDailySugarGoal: selectedDailySugarGoal
    )
  }
  
}


public extension UnitInfoRequest {
  static func mock() -> UnitInfoRequest {
    UnitInfoRequest.defaultUserInfo
  }
}

