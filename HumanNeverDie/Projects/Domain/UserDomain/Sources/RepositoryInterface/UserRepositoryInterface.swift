//
//  UserRepositoryInterface.swift
//  UserDomain
//
//  Created by Seulki Lee on 2025/07/20.
//

import Foundation

public protocol UserRepositoryInterface: Sendable {
  func getUserInfo(userID:String) async throws -> UserInfo
  func getUserNotificationInfo(userID:String) async throws -> UserNotifications
  func getUserSugarLavel(userID:String) async throws -> UserSugarLevel
  func updateUserInfo(userID: String, userInfo: UserInfo) async throws -> UserInfo
  func updateNotifications(userID: String, isEnabled: Bool) async throws -> UserNotifications
  func updateUserNotifications(userID: String, userNotificationsInfo: UserNotifications) async throws -> UserNotifications
  func registerFCMToken(userID: String, fcmToken: String) async throws
}
