//
//  SettingModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/15/25.
//

import Foundation
import UserDomain

public enum SettingItem: String, CaseIterable, Hashable {
  case settingTitle = "설정"
  case accountInfo = "정보 관리"
  case goalSetting = "목표 설정"
  case notificationSetting = "알림 수신 설정"
  case feedback = "의견 남기기"
  case terms = "약관 및 정책"
  
  public var title: String {
    return rawValue
  }
}

public struct UserInfo: Equatable {
    public let nickname: String
    public let birthDate: String
    public let selectedGender: Gender
    public let height: String
    public let weight: String
    public let selectedActivity: ActivityLevel
    public let selectedDailySugarGoal: SugarGoal
    public let isPermissionGranted: Bool
    
    public init(
        nickname: String,
        birthDate: String,
        selectedGender: Gender,
        height: String,
        weight: String,
        selectedActivity: ActivityLevel,
        selectedDailySugarGoal: SugarGoal,
        isPermissionGranted: Bool
    ) {
        self.nickname = nickname
        self.birthDate = birthDate
        self.selectedGender = selectedGender
        self.height = height
        self.weight = weight
        self.selectedActivity = selectedActivity
        self.selectedDailySugarGoal = selectedDailySugarGoal
        self.isPermissionGranted = isPermissionGranted
    }
    
  nonisolated(unsafe) static let defaultUserInfo = UserInfo(
        nickname: "아맞당",
        birthDate: "2025-07-25",
        selectedGender: .female,
        height: "150",
        weight: "50",
        selectedActivity: .low,
        selectedDailySugarGoal: .normal,
        isPermissionGranted: false
    )
}

