//
//  AuthUseCase.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Foundation

public struct AuthUseCase: Sendable {
  /// Apple 로그인 → 토큰/userID 키체인 저장 → 유저 정보 반환
  public var loginWithApple: @Sendable () async throws(AuthError) -> AuthUserInfo
  /// 키체인 clear + Apple 로그아웃
  public var logout: @Sendable () async throws(AuthError) -> Bool
  /// 서버 탈퇴 요청 + 키체인 clear + Apple 로그아웃
  public var withdraw: @Sendable () async throws(AuthError) -> Bool
  /// 키체인 내 accessToken 존재 여부 확인
  public var hasValidAccessToken: @Sendable () -> Bool
  /// 리프레시 토큰으로 갱신 후 키체인 저장
  public var refreshToken: @Sendable () async throws(AuthError) -> Bool

  public init(
    loginWithApple: @Sendable @escaping () async throws(AuthError) -> AuthUserInfo,
    logout: @Sendable @escaping () async throws(AuthError) -> Bool,
    withdraw: @Sendable @escaping () async throws(AuthError) -> Bool,
    hasValidAccessToken: @Sendable @escaping () -> Bool,
    refreshToken: @Sendable @escaping () async throws(AuthError) -> Bool
  ) {
    self.loginWithApple = loginWithApple
    self.logout = logout
    self.withdraw = withdraw
    self.hasValidAccessToken = hasValidAccessToken
    self.refreshToken = refreshToken
  }
}
