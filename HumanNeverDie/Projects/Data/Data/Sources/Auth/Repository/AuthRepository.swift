//
//  AuthRepository.swift
//  Data
//
//  Created by 김규철 on 8/20/25.
//

import Foundation

import AuthDomain
import BaseNetwork

import Dependencies

public extension AuthRepositoryInterface {
  static let live: AuthRepositoryInterface = .init(
    loginWithApple: { () async throws(AuthError) -> AuthToken in
      @Dependency(\.appleLoginManager) var appleLoginManager
      do {
        let appleAuthToken = try await appleLoginManager.loginWithApple()
        return AuthToken(
          accessToken: appleAuthToken.accessToken,
          refreshToken: appleAuthToken.refreshToken,
          idToken: appleAuthToken.idToken,
          expiresIn: appleAuthToken.expiresIn
        )
      } catch {
        switch error {
        case AppleLoginError.userCancelled:
          throw AuthError.userCancelled
        case AppleLoginError.authenticationFailed(let authError):
          throw AuthError.loginFailed(authError.localizedDescription)
        case AppleLoginError.credentialStoreFailed:
          throw AuthError.tokenStorageFailed
        case AppleLoginError.unknown(let unknownError):
          throw AuthError.unknown(unknownError.localizedDescription)
        default:
          throw AuthError.unknown("알 수 없는 에러가 발생")
        }
      }
    },
    logout: { () async throws(AuthError) -> Void in
      @Dependency(\.appleLoginManager) var appleLoginManager
      do {
        try await appleLoginManager.logout()
      } catch {
        switch error {
        case AppleLoginError.authenticationFailed(let authError):
          throw AuthError.logoutFailed(authError.localizedDescription)
        case AppleLoginError.unknown(let unknownError):
          throw AuthError.unknown(unknownError.localizedDescription)
        default:
          throw AuthError.logoutFailed(error.localizedDescription)
        }
      }
    },
    getUserInfo: { () async throws(AuthError) -> AuthUserInfo in
      @Dependency(\.networkService) var networkService
      do {
        let target = AuthValidationTarget()
        let response = try await networkService.requestDDD(target)

        guard let data = response.data else {
          throw AuthError.tokenValidationFailed("응답 데이터가 없습니다")
        }

        return data.toDomain()
      } catch {
        throw AuthError.tokenValidationFailed(error.localizedDescription)
      }
    },
    withdraw: { () async throws(AuthError) -> Void in
      @Dependency(\.networkService) var networkService
      do {
        let target = AuthWithdrawTarget()
        _ = try await networkService.requestDDD(target)
      } catch {
        throw AuthError.unknown(error.localizedDescription)
      }
    },
    refreshToken: { () async throws(AuthError) -> AuthToken in
      @Dependency(\.appleLoginManager) var appleLoginManager
      do {
        let appleAuthToken = try await appleLoginManager.refreshCredentials()
        return AuthToken(
          accessToken: appleAuthToken.accessToken,
          refreshToken: appleAuthToken.refreshToken,
          idToken: appleAuthToken.idToken,
          expiresIn: appleAuthToken.expiresIn
        )
      } catch {
        switch error {
        case AppleLoginError.invalidRefreshToken:
          throw AuthError.tokenValidationFailed("유효하지 않은 리프레시 토큰")
        case AppleLoginError.authenticationFailed(let authError):
          throw AuthError.loginFailed(authError.localizedDescription)
        case AppleLoginError.unknown(let unknownError):
          throw AuthError.unknown(unknownError.localizedDescription)
        default:
          throw AuthError.unknown("토큰 재발급 중 알 수 없는 에러가 발생")
        }
      }
    }
  )
}
