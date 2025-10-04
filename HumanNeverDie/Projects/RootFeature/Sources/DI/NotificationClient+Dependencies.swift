//
//  NotificationClient+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 10/4/25.
//

import Shared

import Dependencies

// MARK: - AMDNotificationClient

extension AMDNotificationClientKey: @retroactive DependencyKey {
  public static let liveValue: AMDNotificationClientProtocol = AMDNotificationClient()
}
