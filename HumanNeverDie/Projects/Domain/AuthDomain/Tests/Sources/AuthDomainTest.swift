//
//  AuthDomainTest.swift
//  AuthDomainTest
//
//  Created by 김규철 on 2025/08/23.
//

import Foundation
import Testing

import Dependencies
import Shared

@testable import AuthDomain

@Suite("AuthUseCase.live")
struct AuthUseCaseTests {

  @Test("loginWithApple: 유저 정보를 반환하고 토큰/userID 를 키체인에 저장한다")
  func loginWithApple() async throws {
    let keychain = StubKeychainClient()
    let token = AuthToken(
      accessToken: "AT",
      refreshToken: "RT",
      idToken: "ID",
      expiresIn: Date(timeIntervalSince1970: 10_000)
    )
    let user = AuthUserInfo(userID: "user-1", isFirstLogin: true)

    var repo = AuthRepositoryInterface.testValue
    repo.loginWithApple = { () async throws(AuthError) -> AuthToken in token }
    repo.getUserInfo = { () async throws(AuthError) -> AuthUserInfo in user }

    let result = try await withDependencies {
      $0.authRepository = repo
      $0.keychainClient = keychain
    } operation: {
      try await AuthUseCase.live.loginWithApple()
    }

    #expect(result.userID == "user-1")
    #expect(keychain.getValue(forKey: AMDKeychainKey.accessToken) == "AT")
    #expect(keychain.getValue(forKey: AMDKeychainKey.userID) == "user-1")
  }

  @Test("logout: 키체인을 비우고 true 를 반환한다")
  func logout() async throws {
    let keychain = StubKeychainClient()
    try await keychain.setValue("AT", forKey: AMDKeychainKey.accessToken)

    var repo = AuthRepositoryInterface.testValue
    repo.logout = { () async throws(AuthError) -> Void in }

    let result = try await withDependencies {
      $0.authRepository = repo
      $0.keychainClient = keychain
    } operation: {
      try await AuthUseCase.live.logout()
    }

    #expect(result == true)
    #expect(keychain.getValue(forKey: AMDKeychainKey.accessToken) == nil)
  }

  @Test("withdraw: 서버 탈퇴 후 키체인을 비우고 true 를 반환한다")
  func withdraw() async throws {
    let keychain = StubKeychainClient()
    try await keychain.setValue("AT", forKey: AMDKeychainKey.accessToken)

    var repo = AuthRepositoryInterface.testValue
    repo.withdraw = { () async throws(AuthError) -> Void in }
    repo.logout = { () async throws(AuthError) -> Void in }

    let result = try await withDependencies {
      $0.authRepository = repo
      $0.keychainClient = keychain
    } operation: {
      try await AuthUseCase.live.withdraw()
    }

    #expect(result == true)
    #expect(keychain.getValue(forKey: AMDKeychainKey.accessToken) == nil)
  }

  @Test(
    "hasValidAccessToken: accessToken 존재 여부에 따라 true/false",
    arguments: [
      (stored: "AT" as String?, expected: true),
      (stored: nil, expected: false)
    ]
  )
  func hasValidAccessToken(stored: String?, expected: Bool) async throws {
    let keychain = StubKeychainClient()
    if let stored {
      try await keychain.setValue(stored, forKey: AMDKeychainKey.accessToken)
    }

    let result = withDependencies {
      $0.keychainClient = keychain
    } operation: {
      AuthUseCase.live.hasValidAccessToken()
    }

    #expect(result == expected)
  }

  @Test("refreshToken: 새 토큰을 키체인에 저장하고 true 를 반환한다")
  func refreshToken() async throws {
    let keychain = StubKeychainClient()
    let newToken = AuthToken(
      accessToken: "NEW_AT",
      refreshToken: "NEW_RT",
      idToken: "NEW_ID",
      expiresIn: Date(timeIntervalSince1970: 20_000)
    )

    var repo = AuthRepositoryInterface.testValue
    repo.refreshToken = { () async throws(AuthError) -> AuthToken in newToken }

    let result = try await withDependencies {
      $0.authRepository = repo
      $0.keychainClient = keychain
    } operation: {
      try await AuthUseCase.live.refreshToken()
    }

    #expect(result == true)
    #expect(keychain.getValue(forKey: AMDKeychainKey.accessToken) == "NEW_AT")
    #expect(keychain.getValue(forKey: AMDKeychainKey.refreshToken) == "NEW_RT")
  }
}
