//
//  AccountInfoViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/16/25.
//

import Foundation
import Observation

import CommonFeature

@Observable
@MainActor
public final class AccountInfoViewModel: ViewModelable {
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

