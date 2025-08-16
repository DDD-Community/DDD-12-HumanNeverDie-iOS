//
//  GlobalState+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 8/16/25.
//

import CommonFeature

import Dependencies

// MARK: - GlobalState

extension GlobalStateKey: @retroactive DependencyKey {
  public static let liveValue: GlobalStateProtocol = GlobalState.shared
}
