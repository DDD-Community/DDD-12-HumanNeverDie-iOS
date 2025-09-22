//
//  AmplitudeClient+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 9/22/25.
//

import Shared

import Dependencies

// MARK: - AMDAmplitudeClient

extension AMDAmplitudeClientKey: @retroactive DependencyKey {
  public static let liveValue: AMDAmplitudeClientProtocol =  AMDAmplitudeClient()
}
