//
//  SettingModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/15/25.
//

import Foundation

public enum SettingItem: String, CaseIterable {
  case accountInfo = "정보 관리"
  case goalSetting = "목표 설정"
  case notificationSetting = "알림 수신 설정"
  case feedback = "의견 남기기"
  case terms = "약관 및 정책"
  
  var title: String {
    rawValue
  }
}

