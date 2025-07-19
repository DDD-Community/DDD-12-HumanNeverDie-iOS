//
// UserViewModel.swift
// User
//
// Created by Seulki Lee on 2025.
//

import Foundation
import Observation

import CommonFeature

@Observable
@MainActor
public final class UserViewModel: ViewModelable {
  public struct State: Equatable {
  }
  
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
