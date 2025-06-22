//
// HomeViewModel.swift
// Home
//
// Created by 김규철 on 2025.
//

import Foundation
import Observation

import CommonFeature

@Observable
@MainActor
public final class HomeViewModel: ViewModelable {
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
