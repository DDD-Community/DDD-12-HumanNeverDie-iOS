//
//  UserRepositoryInterface+Dependency.swift
//  UserDomain
//
//  Created by Seulki Lee on 8/12/25.
//

import Foundation

import Dependencies

// MARK: - TestDependencyKey

public struct UserRepositoryKey: TestDependencyKey, Sendable {
  public static let testValue: UserRepositoryInterface = MockUserRepository()
}

// MARK: - DependencyValues

extension DependencyValues {
  var userRepository: UserRepositoryInterface {
    get { self[UserRepositoryKey.self] }
    set { self[UserRepositoryKey.self] = newValue }
  }
}

// MARK: - MockUserRepository

private struct MockUserRepository: UserRepositoryInterface {
  func getUserInfo(userID: String) async throws -> UserInfo { UserInfo.mock() }
  func getUserNotificationInfo(userID: String) async throws -> UserNotifications { UserNotifications.mock()}
  func updateUserInfo(userID: String, userInfo: UserInfo) async throws -> UserInfo { UserInfo.mock()}
  func updateNotifications(userID: String, isEnabled: Bool) async throws -> UserNotifications {UserNotifications.mock()}
  func updateUserNotifications(userID: String, userNotificationsInfo: UserNotifications) async throws -> UserNotifications { UserNotifications.mock()}
}

