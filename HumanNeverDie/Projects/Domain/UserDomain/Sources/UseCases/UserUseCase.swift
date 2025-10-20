//
//  UserUseCase.swift
//  UserDomain
//
//  Created by Seulki Lee on 2025/07/20.
//

import Foundation

import Dependencies

public protocol UserUseCaseProtocol: Sendable {
  func getUserInfo(userID:String) async throws -> UserInfo
  func getUserNotificationInfo(userID:String) async throws -> UserNotifications
  func getUserSugarLavel(userID: String) async throws -> UserSugarLevel
  func updateUserInfo(userID: String, userInfo: UserInfo) async throws -> UserInfo
  func updateNotifications(userID: String, isEnabled: Bool) async throws -> UserNotifications
  func updateUserNotifications(userID: String, userNotifications: UserNotifications) async throws -> UserNotifications
}

public final class UserUseCase: UserUseCaseProtocol, @unchecked Sendable {
  @Dependency(\.userRepository) private var userRepository
  public init() {}
  
  public func getUserInfo(userID: String) async throws -> UserInfo {
    return try await userRepository.getUserInfo(userID: userID)
  }
  
  public func getUserNotificationInfo(userID: String) async throws -> UserNotifications {
    return try await userRepository.getUserNotificationInfo(userID: userID)
  }
  
  public func getUserSugarLavel(userID: String) async throws -> UserSugarLevel {
    return try await userRepository.getUserSugarLavel(userID: userID)
  }
  
  public func updateUserInfo(userID: String, userInfo: UserInfo) async throws -> UserInfo {
    return try await userRepository.updateUserInfo(userID: userID, userInfo: userInfo)
  }
  
  public func updateNotifications(userID: String, isEnabled: Bool) async throws -> UserNotifications {
    return try await userRepository.updateNotifications(userID: userID, isEnabled: isEnabled)
  }
  
  public func updateUserNotifications(userID: String, userNotifications: UserNotifications) async throws -> UserNotifications {
    return try await userRepository.updateUserNotifications(userID: userID, userNotificationsInfo: userNotifications)
  }
}
