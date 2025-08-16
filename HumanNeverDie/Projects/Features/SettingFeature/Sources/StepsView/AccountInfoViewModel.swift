//
//  AccountInfoViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation

import UserDomain
import CommonFeature

import Dependencies

@Observable
@MainActor
public final class AccountInfoViewModel: ViewModelable {
  @ObservationIgnored
  @Dependency(\.alertClient) private var alertClient
  
  private let validator: UserInfoValidationUseCase
  private var router: Router?

  public struct State: Equatable {
    var nickname: String = ""
    var birthDate: Date = Date()
    var selectedGender: Gender = .none
    var height: Int = 0
    var weight: Int = 0
    var selectedActivity: ActivityLevel = .none
    var selectedDailySugarGoal: SugarGoal = .none
    
    var showAlert = false
  }
  
  public enum Action {
    case onAppear
    
    // AccountInfoView
    case updateNickname(String)
    case updateBirthDate(Date)
    case updateGender(Gender)
    case updateHeight(String)
    case updateWeight(String)
    case updateActivity(ActivityLevel)
    
    case updateAccountInfoUserInfo
  }
  
  public var state: State = .init()
  private var originalState: State
  
  public init(
    userInfo: UserInfo,
    validator: UserInfoValidationUseCase = DefaultUserInfoValidationUseCase()
  ) {
    self.validator = validator
    
    let initialState = State(
      nickname: userInfo.nickname,
      birthDate: Date.toStringConvertDate(from:userInfo.birthDate),
      selectedGender: userInfo.selectedGender,
      height: userInfo.height,
      weight: userInfo.weight,
      selectedActivity: userInfo.selectedActivity,
      selectedDailySugarGoal: userInfo.selectedDailySugarGoal
    )
    
    self.state = initialState
    self.originalState = initialState
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
    case .updateNickname(let nickname):
      state.nickname = nickname
      
    case .updateBirthDate(let birthDate):
      state.birthDate = birthDate
      state.showAlert = false
      
    case .updateGender(let gender):
      state.selectedGender = gender
      
    case .updateHeight(let height):
      
      guard let intValue = Int(height) else { state.height = 0
        return
      }
      state.height = intValue
      
    case .updateWeight(let weight):
      
      guard let intValue = Int(weight) else { state.weight = 0
        return
      }
      state.weight = intValue
      
    case .updateActivity(let activity):
      state.selectedActivity = activity
      
    case .updateAccountInfoUserInfo:
      Task {
        await showDeleteAlert()
      }
      
//    case .goBack:
//      settingViewModel?.handleAction(.goBack)
    }
  }
}

//AccountInfoView
extension AccountInfoViewModel {
  public func setRouter(_ router: Router) {
      self.router = router
  }
  
  public var isChangedAccountInfo: Bool {
    return state != originalState
  }
  
  public var nicknameErrorMessage: String? {
    return validator.nicknameErrorMessage(for: state.nickname)
  }
  
  public var heightErrorMessage: String? {
    return validator.heightErrorMessage(for: state.height)
  }
  
  public var weightErrorMessage: String? {
    return validator.weightErrorMessage(for: state.weight)
  }
  
  public var getBirthDateConvertString: String {
    return Date.toDateTitleString(from: state.birthDate)
  }
  
  public var birthDate: Date {
    return state.birthDate
  }
  
  // 현재 상태를 UserInfo로 변환하는 메서드 추가
  public func getCurrentUserInfo() -> UserInfo {
    return UserInfo(
      nickname: state.nickname,
      birthDate: Date.toDateKeyString(from:state.birthDate),
      selectedGender: state.selectedGender,
      height: state.height,
      weight: state.weight,
      selectedActivity: state.selectedActivity,
      selectedDailySugarGoal: state.selectedDailySugarGoal
    )
  }
  
  nonisolated private func showDeleteAlert() async {
    await alertClient.showAlert(.init(
      title: "일일 당 섭취 목표가 변경될 수 있어요.",
      message: "수정한 신체 정보에 맞춰 일일 권장 당 섭취량이 변경될 예정이에요",
      primaryButton: .init(title: "저장", type: .default) {
        
        let updatedUserInfo = await self.getCurrentUserInfo()
        // Router를 통해 전달
        await MainActor.run {
          self.router?.onUserInfoUpdated?(updatedUserInfo)
          self.router?.pop()
        }
      },
      secondaryButton: .init(title: "취소", type: .secondary) {
        
      }
    ))
  }
}
