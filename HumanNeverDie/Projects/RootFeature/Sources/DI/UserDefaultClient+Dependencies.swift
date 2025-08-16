//
//  UserDefaultClient+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 8/11/25.
//

import Shared

import Dependencies

// MARK: - AMDUserDefaultClient

extension AMDUserDefaultClientKey: @retroactive DependencyKey {
  public static let liveValue: AMDUserDefaultClientProtocol = AMDUserDefaultClient()
}
