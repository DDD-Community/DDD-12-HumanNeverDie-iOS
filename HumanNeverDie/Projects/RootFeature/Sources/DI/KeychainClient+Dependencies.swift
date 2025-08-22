//
//  KeychainClient+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 8/21/25.
//

import Shared

import Dependencies

// MARK: - AMDKeychainClient

extension AMDKeychainClientKey: @retroactive DependencyKey {
  public static let liveValue: AMDKeychainClientProtocol = AMDKeychainClient()
}