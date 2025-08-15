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
  func updateUserInfo(userID: String, userInfo: UserInfo) async throws -> UnitInfoRequest
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
  
  public func updateUserInfo(userID: String, userInfo: UserInfo) async throws -> UnitInfoRequest {
    return try await userRepository.updateUserInfo(userID: userID, userInfo: userInfo)
  }
  
}
