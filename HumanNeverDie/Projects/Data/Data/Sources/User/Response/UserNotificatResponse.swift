//
//  UserNotificatResponse.swift
//  Data
//
//  Created by Seulki Lee on 8/15/25.
//

import Foundation
import UserDomain

struct UserNotificationsResponse: Decodable {
  let isEnabled: Bool
  let remindersEnabled: Bool
  let reminderTime: String
  let riskWarningsEnabled: Bool
  let newsUpdatesEnabled: Bool
}

extension UserNotificationsResponse {
  public func toDomain() -> UserNotifications {
    return UserNotifications(
      isEnabled: isEnabled,
      remindersEnabled: remindersEnabled,
      reminderTime: reminderTime,
      riskWarningsEnabled: riskWarningsEnabled,
      newsUpdatesEnabled: newsUpdatesEnabled
    )
  }
}
