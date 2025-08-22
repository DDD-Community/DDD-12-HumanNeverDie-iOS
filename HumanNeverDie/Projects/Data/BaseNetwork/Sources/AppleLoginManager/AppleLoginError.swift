//
//  AppleLoginError.swift
//  BaseNetwork
//
//  Created by 김규철 on 8/20/25.
//

import Foundation

public enum AppleLoginError: Error, LocalizedError {
  case authenticationFailed(Error)
  case userCancelled
  case credentialStoreFailed
  case invalidRefreshToken
  case unknown(Error)
  
  public var userMessage: String {
    switch self {
    case .authenticationFailed(let error):
      return "애플 로그인 인증에 실패했어요. \(error.localizedDescription)"
    case .userCancelled:
      return "로그인이 취소되었어요."
    case .credentialStoreFailed:
      return "인증 정보 저장에 실패했어요."
    case .invalidRefreshToken:
      return "유효하지 않은 리프레시 토큰"
    case .unknown(let error):
      return "알 수 없는 오류가 발생했어요. \(error.localizedDescription)"
    }
  }
}
