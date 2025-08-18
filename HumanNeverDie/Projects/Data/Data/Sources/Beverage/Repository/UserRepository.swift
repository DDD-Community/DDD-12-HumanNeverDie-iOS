//
//  UserRepository.swift
//  Data
//
//  Created by Seulki Lee on 8/12/25.
//

import Foundation

import BaseNetwork
import UserDomain

import Dependencies

public final class UserRepository: UserRepositoryInterface, @unchecked Sendable {
  
  @Dependency(\.networkService) private var networkService
  public init() {}
  
  public func getUserInfo(userID: String) async throws -> UserDomain.UserInfo {
    let target = UserInfoTarget(userID: userID)
    let result = try await networkService.requestDDD(target)

    guard let response = result.data else {
      throw AMDNetworkError.emptyResponse
    }

    return response.toDomain()
  }
  
  public func getUserNotificationInfo(userID: String) async throws -> UserDomain.UserNotifications {
    let target = UserNotificationsTarget(userID: userID)
    let result = try await networkService.requestDDD(target)

    guard let response = result.data else {
      throw AMDNetworkError.emptyResponse
    }

    return response.toDomain()
  }
  
  public func updateUserInfo(userID: String, userInfo: UserInfo) async throws -> UserDomain.UserInfo {
    let target = UserInfoUpdateTarget(userID: userID, userInfo: userInfo)
    let result = try await networkService.requestDDD(target)

    guard let response = result.data else {
      throw AMDNetworkError.emptyResponse
    }

    return response.toDomain()
  }
  
  public func updateUserNotifications(userID: String, userNotificationsInfo: UserNotifications) async throws -> UserNotifications {
    let target = UserNotificationsUpdateTarget(userID: userID, userNotifications: userNotificationsInfo)
    let result = try await networkService.requestDDD(target)

    guard let response = result.data else {
      throw AMDNetworkError.emptyResponse
    }

    return response.toDomain()
  }
}

