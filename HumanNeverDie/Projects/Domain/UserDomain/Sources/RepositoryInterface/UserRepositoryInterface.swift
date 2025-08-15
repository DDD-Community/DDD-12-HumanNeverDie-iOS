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
  func updateUserInfo(userID: String, userInfo: UserInfo) async throws -> UnitInfoRequest
}
