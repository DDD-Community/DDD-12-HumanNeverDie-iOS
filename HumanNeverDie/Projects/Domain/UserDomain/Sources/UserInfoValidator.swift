//
//  UserInfoValidator.swift
//  UserDomain
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation
import Shared

public class UserInfoValidator {
  
    public static func isValidNickname(_ nickname: String) -> Bool {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedNickname.isEmpty &&
               trimmedNickname.count >= 2 &&
               trimmedNickname.count <= 10 &&
               trimmedNickname.isValidNicknameFormat
    }
    
    public static func nicknameErrorMessage(for nickname: String) -> String? {
        if nickname.isEmpty {
            return nil
        }
        
        if nickname.count < 2 {
            return "닉네임은 2자 이상 입력해주세요."
        }
        
        if nickname.count > 10 {
            return "닉네임은 10자 이하로 입력해주세요."
        }
        
        if !nickname.isValidNicknameFormat {
            return "닉네임은 띄어쓰기 없이 한글, 영문, 숫자로 입력해주세요."
        }
        
        return nil
    }
    
    public static func isValidHeight(_ height: String) -> Bool {
        guard !height.isEmpty else { return false }
        guard let heightValue = Int(height) else { return false }
        return heightValue > 0 && heightValue <= 300
    }
    
    public static func heightErrorMessage(for height: String) -> String? {
        if height.isEmpty {
            return nil
        }
        
        guard let heightValue = Int(height) else {
            return "키는 0-300 사이의 숫자를 입력해주세요"
        }
        
        if heightValue <= 0 || heightValue > 300 {
            return "키는 0-300 사이의 숫자를 입력해주세요"
        }
        
        return nil
    }
    
    public static func isValidWeight(_ weight: String) -> Bool {
        guard !weight.isEmpty else { return false }
        guard let weightValue = Int(weight) else { return false }
        return weightValue > 0 && weightValue <= 300
    }
    
    public static func weightErrorMessage(for weight: String) -> String? {
        if weight.isEmpty {
            return nil
        }
        
        guard let weightValue = Int(weight) else {
            return "몸무게는 0-300 사이의 숫자를 입력해주세요"
        }
        
        if weightValue <= 0 || weightValue > 300 {
            return "몸무게는 0-300 사이의 숫자를 입력해주세요"
        }
        
        return nil
    }
}
