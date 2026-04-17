//
//  UserRepositoryInterface.swift
//  UserDomain
//
//  Created by Seulki Lee on 2025/07/20.
//

import Foundation

import DependenciesMacros

@DependencyClient
public struct UserRepositoryInterface: Sendable {
  /// 사용자 프로필 조회
  public var getUserInfo: @Sendable (_ userID: String) async throws -> UserInfo
  /// 사용자 알림 설정 조회
  public var getUserNotificationInfo: @Sendable (_ userID: String) async throws -> UserNotifications
  /// 사용자 당 섭취 레벨 조회
  public var getUserSugarLavel: @Sendable (_ userID: String) async throws -> UserSugarLevel
  /// 사용자 프로필 업데이트
  public var updateUserInfo: @Sendable (_ userID: String, _ userInfo: UserInfo) async throws -> UserInfo
  /// 알림 수신 여부 단일 토글 업데이트
  public var updateNotifications: @Sendable (_ userID: String, _ isEnabled: Bool) async throws -> UserNotifications
  /// 알림 상세 설정(시간대 등) 일괄 업데이트
  public var updateUserNotifications: @Sendable (_ userID: String, _ userNotificationsInfo: UserNotifications) async throws -> UserNotifications
  /// FCM 푸시 토큰 등록
  public var registerFCMToken: @Sendable (_ userID: String, _ fcmToken: String) async throws -> Void
}
