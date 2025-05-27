//
// SplashViewModel.swift
// Splash
//
// Created by 김규철 on 2025.
//

import Foundation
import Observation

@Observable
public final class SplashViewModel {
  enum Action {
    case onAppear
  }
  
  public init() {}
  
  func handleAction(action: Action) {
    switch action {
    case .onAppear:
      break
    }
  }
}
