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
    case onAppear
    case onboardingDismissButtonTapped(Bool)
  }
  
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
      
    case .onAppear:
      Task { await checkOnboarding() }
      
    case let .onboardingDismissButtonTapped(isDontShow):
      Task {
        await userDefaultClient.setValue(!isDontShow, forKey: AMDUserDefaultKey.isFirstHome)
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
}

