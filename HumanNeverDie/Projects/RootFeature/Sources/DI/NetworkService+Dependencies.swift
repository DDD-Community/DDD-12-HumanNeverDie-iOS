//
//  NetworkService+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 6/19/25.
//


import BaseNetwork

import Dependencies

// MARK: - AMDNetworkService

extension AMDNetworkServiceKey: @retroactive DependencyKey {
  public static let liveValue: AMDNetworkServiceProtocol = AMDNetworkService()
}
