//
//  GoalSettingViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import Foundation

import CommonFeature

@Observable
@MainActor
public final class GoalSettingViewModel: ViewModelable {
  public struct State: Equatable {}

  public enum Action {
    case onAppear
  }

  public var state: State = .init()
  public init() {}

  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
    }
  }
}
