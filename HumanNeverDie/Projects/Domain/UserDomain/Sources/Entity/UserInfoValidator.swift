//
//  UserInfoValidator.swift
//  UserDomain
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation
import Shared

public protocol UserInfoValidationUseCase {
  func isValidNickname(_ nickname: String) -> Bool
  func nicknameErrorMessage(for nickname: String) -> String?
  func isValidHeight(_ height: Int) -> Bool
  func heightErrorMessage(for height: Int) -> String?
  func isValidWeight(_ weight: Int) -> Bool
  func weightErrorMessage(for weight: Int) -> String?
}

public final class DefaultUserInfoValidationUseCase: UserInfoValidationUseCase {
  
  public init() {}
  
  public func isValidNickname(_ nickname: String) -> Bool {
    let trimmed = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
    return !trimmed.isEmpty &&
    trimmed.count >= 2 &&
    trimmed.count <= 10 &&
    trimmed.isValidNicknameFormat
  }
  
  public func nicknameErrorMessage(for nickname: String) -> String? {
    if nickname.isEmpty {
      return nil
    }
    if nickname.count < 2 { return "닉네임은 2자 이상 입력해주세요." }
    if nickname.count > 10 { return "닉네임은 10자 이하로 입력해주세요." }
    if !nickname.isValidNicknameFormat {
      return "닉네임은 띄어쓰기 없이 한글, 영문, 숫자로 입력해주세요."
    }
    return nil
  }
  
  public func isValidHeight(_ height: Int) -> Bool {
    if (height > 0 && height <= 300) {
      return true
    }
    return false
  }
  
  public func heightErrorMessage(for height: Int) -> String? {
    if ( height >= 0 && height < 300 ) {
      return nil
    }
    return "키는 0-300 사이의 숫자를 입력해주세요"
  }
  
  public func isValidWeight(_ weight: Int) -> Bool {
    if ( weight > 0 && weight <= 300 ) {
      return true
    }
    return false
  }
  
  public func weightErrorMessage(for weight: Int) -> String? {
    if ( weight >= 0 && weight < 300 ) {
      return nil
    }
    return "몸무게는 0-300 사이의 숫자를 입력해주세요"
  }
}

