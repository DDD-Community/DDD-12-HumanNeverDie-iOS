//
//  SugarGoalCalculator.swift
//  UserDomain
//
//  Created by Seulki Lee on 8/19/25.
//

import Foundation

public func sugarGoalCalculator(userInfo: UserInfo) -> Int {
  let sugarService = SugarUserCalculation()
  return sugarService.calculateUserSugarGoal(for: userInfo)
}
