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

@Observable
@MainActor
public final class MainViewModel: ViewModelable {
  public struct State: Equatable {
    var selectedTab: AMDTabBarType  = .home
  }
  
  public enum Action {
    case tabBarItemTapped(AMDTabBarType)
  }
  
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
    }
  }
}

