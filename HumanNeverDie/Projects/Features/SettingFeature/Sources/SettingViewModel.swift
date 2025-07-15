//
// SettingViewModel.swift
// Setting
//
// Created by Seulki Lee on 2025.
//
import Foundation
import Observation

import CommonFeature

@Observable
@MainActor
public final class SettingViewModel: ViewModelable {
  public struct State: Equatable {}

  public enum Action {
    case onAppear
    case moveToNextStep(SettingItem)
  }

  public var state: State = .init()
  public init() {}

  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case .moveToNextStep(let item):
      switch item {
      case .accountInfo:
        print("정보 관리 화면으로 이동")
      case .goalSetting:
        print("목표 설정 화면으로 이동")
      case .notificationSetting:
        print("알림 수신 설정 화면으로 이동")
      case .feedback:
        print("피드백 작성 화면으로 이동")
      case .terms:
        print("약관 및 정책 화면으로 이동")

        break
      }
    }
  }
}

