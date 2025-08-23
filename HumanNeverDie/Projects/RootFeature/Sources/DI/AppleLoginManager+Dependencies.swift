//
//  AppleLoginManager+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 8/20/25.
//

import BaseNetwork

import Dependencies

// MARK: - AppleLoginManager

extension AppleLoginManagerKey: @retroactive DependencyKey {
  public static let liveValue: AppleLoginManagerProtocol = AppleLoginManager()
}
