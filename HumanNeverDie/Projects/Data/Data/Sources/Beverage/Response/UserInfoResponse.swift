//
//  UserInfoResponse.swift
//  Data
//
//  Created by Seulki Lee on 8/12/25.
//

import Foundation
import UserDomain

struct UserInfoResponse: Decodable {
  let nickname: String
  let birthDay: String
  let gender: String
  let heightCm: Int
  let weightKg: Int
  let activityRange: String
  let sugarIntakeLevel: String
}

extension UserInfoResponse {
   public func toDomain() -> UserInfo {
       return UserInfo(
           nickname: nickname,
           birthDate: birthDay,
           selectedGender: Gender(rawValue: gender) ?? .none,
           height: heightCm,
           weight: weightKg,
           selectedActivity: ActivityLevel(rawValue: activityRange) ?? .none,
           selectedDailySugarGoal: SugarGoal(rawValue: sugarIntakeLevel) ?? .none
       )
   }
}
