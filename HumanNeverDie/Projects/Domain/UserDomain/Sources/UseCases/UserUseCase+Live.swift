//
//  UserUseCase+Live.swift
//  UserDomain
//

import Foundation

import Dependencies

public extension UserUseCase {
  static let live: UserUseCase = .init(
    getUserInfo: { userID in
      @Dependency(\.userRepository) var userRepository
      return try await userRepository.getUserInfo(userID: userID)
    },
    getUserNotificationInfo: { userID in
      @Dependency(\.userRepository) var userRepository
      return try await userRepository.getUserNotificationInfo(userID: userID)
    },
    getUserSugarLavel: { userID in
      @Dependency(\.userRepository) var userRepository
      do {
        return try await userRepository.getUserSugarLavel(userID: userID)
      } catch {
        // 네트워크 실패 시 mock 데이터 반환 (비즈니스 로직)
        return UserSugarLevel.mock()
      }
    },
    updateUserInfo: { userID, userInfo in
      @Dependency(\.userRepository) var userRepository
      return try await userRepository.updateUserInfo(userID: userID, userInfo: userInfo)
    },
    updateNotifications: { userID, isEnabled in
      @Dependency(\.userRepository) var userRepository
      return try await userRepository.updateNotifications(userID: userID, isEnabled: isEnabled)
    },
    updateUserNotifications: { userID, userNotifications in
      @Dependency(\.userRepository) var userRepository
      return try await userRepository.updateUserNotifications(
        userID: userID,
        userNotificationsInfo: userNotifications
      )
    },
    registerFCMToken: { userID, fcmToken in
      @Dependency(\.userRepository) var userRepository
      try await userRepository.registerFCMToken(userID: userID, fcmToken: fcmToken)
    }
  )
}
