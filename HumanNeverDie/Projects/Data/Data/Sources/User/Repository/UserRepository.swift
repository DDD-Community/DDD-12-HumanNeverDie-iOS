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

public extension UserRepositoryInterface {
  static let live: UserRepositoryInterface = .init(
    getUserInfo: { userID in
      @Dependency(\.networkService) var networkService
      let target = UserInfoTarget(userID: userID)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    getUserNotificationInfo: { userID in
      @Dependency(\.networkService) var networkService
      let target = UserNotificationsTarget(userID: userID)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    getUserSugarLavel: { userID in
      @Dependency(\.networkService) var networkService
      let target = UserSugarLevelTarget(userID: userID)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    updateUserInfo: { userID, userInfo in
      @Dependency(\.networkService) var networkService
      let target = UserInfoUpdateTarget(userID: userID, userInfo: userInfo)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    updateNotifications: { userID, isEnabled in
      @Dependency(\.networkService) var networkService
      let target = NotificationUpdateTarget(userID: userID, isEnabled: isEnabled)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    updateUserNotifications: { userID, userNotificationsInfo in
      @Dependency(\.networkService) var networkService
      let target = UserNotificationsUpdateTarget(userID: userID, userNotifications: userNotificationsInfo)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    registerFCMToken: { userID, fcmToken in
      @Dependency(\.networkService) var networkService
      let target = FCMTokenTarget(userID: userID, fcmToken: fcmToken)
      _ = try await networkService.requestDDD(target)
    }
  )
}
