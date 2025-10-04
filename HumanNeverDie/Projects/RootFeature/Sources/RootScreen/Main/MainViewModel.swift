//
//  MainViewModel.swift
//  MainFeature
//
//  Created by 김규철 on 5/25/25.
//

import Foundation
import Observation

import HomeFeature
import HistoryFeature
import SettingFeature
import CommonFeature
import Shared

import Dependencies

@Observable
@MainActor
public final class MainViewModel: ViewModelable {
  public struct State: Equatable {
    var selectedTab: AMDTabBarType  = .home
    var isOnboardingPresented: Bool = false
  }
  
  public enum Action {
    case tabBarItemTapped(AMDTabBarType)
    case onViewDidLoad
    case onboardingDismissButtonTapped
  }
  
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  
  @ObservationIgnored
  @Dependency(\.keychainClient) private var keychainClient
  
  @ObservationIgnored
  @Dependency(\.userDefaultClient) private var userDefaultClient
  
  @ObservationIgnored
  var homeViewModel: HomeViewModel = .init()
  
  @ObservationIgnored
  var historyViewModel: HistoryViewModel = .init()
  
  @ObservationIgnored
  var settingViewModel: SettingViewModel = .init()
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .tabBarItemTapped(let tab):
      state.selectedTab = tab
      
    case .onViewDidLoad:
      Task {
        await checkOnboarding()
        await registerFCMToken()
      }
      
    case .onboardingDismissButtonTapped:
      Task {
        await userDefaultClient.setValue(false, forKey: AMDUserDefaultKey.isFirstHome)
        await MainActor.run {
          state.isOnboardingPresented = false
        }
      }
    }
  }
  
  private func checkOnboarding() async {
    guard let isFirstHome: Bool = userDefaultClient.getValue(forKey: AMDUserDefaultKey.isFirstHome) else {
      return
    }
    
    await MainActor.run {
      state.isOnboardingPresented = isFirstHome
    }
  }
  
  private func registerFCMToken() async {
    guard let fcmToken: String = userDefaultClient.getValue(forKey: AMDUserDefaultKey.fcmToken),
          let userID = keychainClient.getValue(forKey: AMDKeychainKey.userID) else {
      printIfDebug("❌ FCM 토큰 없음")
      return
    }
    
    do {
      try await userUseCase.registerFCMToken(userID: userID, fcmToken: fcmToken)
      printIfDebug("✅ FCM 토큰 서버 전송 성공")
    } catch {
      printIfDebug("❌ FCM 토큰 서버 전송 실패: \(error)")
    }
  }
}
