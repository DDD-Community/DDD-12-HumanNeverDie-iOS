//
//  UNUserNotificationCenter+.swift
//  Shared
//
//  Created by 김규철 on 10/2/25.
//

import UserNotifications

public extension UNUserNotificationCenter {
  nonisolated func authorizationStatus() async -> sending UNAuthorizationStatus {
    await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
  }
}
