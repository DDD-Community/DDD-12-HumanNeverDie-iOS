//
//  ViewModelable.swift
//  CommonFeature
//
//  Created by 김규철 on 6/17/25.
//

import Foundation

@dynamicMemberLookup
@MainActor
public protocol ViewModelable {
  associatedtype State: Equatable
  associatedtype Action
  
  var state: State { get }
  
  func handleAction(_ action: Action)
}

public extension ViewModelable {
  subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T {
    self.state[keyPath: keyPath]
  }
}
