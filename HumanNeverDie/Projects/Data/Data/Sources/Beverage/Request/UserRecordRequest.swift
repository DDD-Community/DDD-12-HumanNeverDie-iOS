//
//  UserRecordRequest.swift
//  Data
//
//  Created by Seulki Lee on 8/15/25.
//

import Foundation

struct UserRecordRequest: Encodable {
  let nickname: String
  let birthDay: String
  let gender: String
  let heightCm: Int
  let weightKg: Int
  let activityRange: String
  let sugarIntakeLevel: String
}


struct UserNotificationsRequest: Encodable {
 let isEnabled: Bool
 let remindersEnabled: Bool
 let reminderTime: String
 let riskWarningsEnabled: Bool
 let newsUpdatesEnabled: Bool
}
