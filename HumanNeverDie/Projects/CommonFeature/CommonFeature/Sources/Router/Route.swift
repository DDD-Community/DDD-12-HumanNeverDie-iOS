//
//  Route.swift
//  CommonFeature
//
//  Created by 김규철 on 5/25/25.
//

import Foundation
import UserDomain

public enum Route: Hashable {
  case beverageRecordList(recordDate: Date)
  case beverageSearch(recordDate: Date)
  case beverageRecord(productID: String, isLiked: Bool, recordDate: Date)
  case onboardingProfile
  case Setting
  case SettingAccountInfo(userInfo: UserInfo)
  case SettingGoalSetting(userInfo: UserInfo)
  case SettingNotificationSetting(userID: String)
  case SettingTerms
  
}
