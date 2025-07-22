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
    func isValidHeight(_ height: String) -> Bool
    func heightErrorMessage(for height: String) -> String?
    func isValidWeight(_ weight: String) -> Bool
    func weightErrorMessage(for weight: String) -> String?
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

    public func isValidHeight(_ height: String) -> Bool {
        guard let value = Int(height), value > 0, value <= 300 else { return false }
        return true
    }

    public func heightErrorMessage(for height: String) -> String? {
        if height.isEmpty { return nil }
        guard let value = Int(height) else {
            return "키는 0-300 사이의 숫자를 입력해주세요"
        }
        if value <= 0 || value > 300 {
            return "키는 0-300 사이의 숫자를 입력해주세요"
        }
        return nil
    }

    public func isValidWeight(_ weight: String) -> Bool {
        guard let value = Int(weight), value > 0, value <= 300 else { return false }
        return true
    }

    public func weightErrorMessage(for weight: String) -> String? {
        if weight.isEmpty { return nil }
        guard let value = Int(weight) else {
            return "몸무게는 0-300 사이의 숫자를 입력해주세요"
        }
        if value <= 0 || value > 300 {
            return "몸무게는 0-300 사이의 숫자를 입력해주세요"
        }
        return nil
    }
}

