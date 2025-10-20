//
//  UserUseCase+Dependency.swift
//  UserDomain
//
//  Created by Seulki Lee on 8/14/25.
//

import Foundation
import Dependencies

// MARK: - TestDependencyKey
public struct UserUseCaseKey: TestDependencyKey {
  public static let testValue: UserUseCaseProtocol = MockUserUseCase()
}

// MARK: - DependencyValues
public extension DependencyValues {
  var userUseCase: UserUseCaseProtocol {
    get { self[UserUseCaseKey.self] }
    set { self[UserUseCaseKey.self] = newValue }
  }
}

// MARK: - MockUserUseCase
private struct MockUserUseCase: UserUseCaseProtocol {
  func getUserInfo(userID: String) async throws -> UserInfo { UserInfo.mock()}
  func getUserNotificationInfo(userID: String) async throws -> UserNotifications { UserNotifications.mock()}
  func getUserSugarLavel(userID: String) async throws -> UserSugarLevel { UserSugarLevel.mock()}
  func updateUserInfo(userID: String, userInfo: UserInfo) async throws -> UserInfo { UserInfo.mock()}
  func updateNotifications(userID: String, isEnabled: Bool) async throws -> UserNotifications { UserNotifications.mock()}
  func updateUserNotifications(userID: String, userNotifications: UserNotifications) async throws -> UserNotifications {
    UserNotifications.mock()
  }
  
}
