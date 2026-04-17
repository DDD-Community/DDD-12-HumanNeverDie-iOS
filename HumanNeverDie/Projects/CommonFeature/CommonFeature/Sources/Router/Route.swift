//
//  Route.swift
//  CommonFeature
//
//  Created by 김규철 on 5/25/25.
//

import Foundation

import UserDomain

public enum Route: Hashable {
  /// 특정 날짜의 음료 섭취 기록 리스트 화면
  case beverageRecordList(recordDate: Date)
  /// 음료 검색 화면 (기록 대상 날짜 전달)
  case beverageSearch(recordDate: Date)
  /// 음료 상세/기록 입력 화면 (좋아요 초기 상태 포함)
  case beverageRecord(productID: String, isLiked: Bool, recordDate: Date)
  /// 온보딩 프로필 입력 화면
  case onboardingProfile
  /// 설정 메인 화면
  case setting
  /// 설정 > 계정 정보 화면
  case settingAccountInfo(userInfo: UserInfo)
  /// 설정 > 목표 당 섭취량 설정 화면
  case settingGoalSetting(userInfo: UserInfo)
  /// 설정 > 알림 설정 화면
  case settingNotificationSetting(userID: String)
  /// 설정 > 약관/정책 화면
  case settingTerms
}
