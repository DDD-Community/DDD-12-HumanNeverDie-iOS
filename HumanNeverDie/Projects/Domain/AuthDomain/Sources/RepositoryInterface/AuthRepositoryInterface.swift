//
//  AuthRepositoryInterface.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Foundation

public struct AuthRepositoryInterface: Sendable {
  /// Apple 로그인으로 인증 토큰 발급
  public var loginWithApple: @Sendable () async throws(AuthError) -> AuthToken
  /// Apple 세션 로그아웃
  public var logout: @Sendable () async throws(AuthError) -> Void
  /// 서버에서 사용자 정보 조회 (토큰 검증 겸용)
  public var getUserInfo: @Sendable () async throws(AuthError) -> AuthUserInfo
  /// 회원 탈퇴 API 요청
  public var withdraw: @Sendable () async throws(AuthError) -> Void
  /// 리프레시 토큰으로 액세스 토큰 재발급
  public var refreshToken: @Sendable () async throws(AuthError) -> AuthToken

  public init(
    loginWithApple: @Sendable @escaping () async throws(AuthError) -> AuthToken,
    logout: @Sendable @escaping () async throws(AuthError) -> Void,
    getUserInfo: @Sendable @escaping () async throws(AuthError) -> AuthUserInfo,
    withdraw: @Sendable @escaping () async throws(AuthError) -> Void,
    refreshToken: @Sendable @escaping () async throws(AuthError) -> AuthToken
  ) {
    self.loginWithApple = loginWithApple
    self.logout = logout
    self.getUserInfo = getUserInfo
    self.withdraw = withdraw
    self.refreshToken = refreshToken
  }
}
