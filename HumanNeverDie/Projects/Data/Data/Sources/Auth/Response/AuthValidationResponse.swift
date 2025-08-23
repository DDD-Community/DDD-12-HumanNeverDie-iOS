//
//  AuthValidationResponse.swift
//  Data
//
//  Created by Claude on 8/21/25.
//

import Foundation

import AuthDomain

struct AuthValidationResponse: Decodable {
  let fakeId: String
  let firstLogin: Bool
}

extension AuthValidationResponse {
  public func toDomain() -> AuthUserInfo {
    return AuthUserInfo(
      userID: fakeId,
      isFirstLogin: firstLogin
    )
  }
}
