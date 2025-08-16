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
  case logout = "로그아웃"
  case unsubscribe = "탈퇴하기"
  
  
  public var title: String {
    return rawValue
  }
}
