//
//  AuthError.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Foundation

public enum AuthError: Error, LocalizedError, Equatable {
  case loginFailed(String)
  case logoutFailed(String)
  case tokenRefreshFailed(String)
  case tokenStorageFailed
  case userCancelled
  case networkError
  case unknown(String)
  
  public var errorDescription: String? {
    switch self {
    case .loginFailed(let message):
      return "로그인에 실패했어요: \(message)"
    case .logoutFailed(let message):
      return "로그아웃에 실패했어요: \(message)"
    case .tokenRefreshFailed(let message):
      return "토큰 갱신에 실패했어요: \(message)"
    case .tokenStorageFailed:
      return "토큰 저장에 실패했어요"
    case .userCancelled:
      return "로그인이 취소되었어요"
    case .networkError:
      return "네트워크 연결을 확인해주세요"
    case .unknown(let message):
      return "알 수 없는 오류가 발생했어요: \(message)"
    }
  }
}