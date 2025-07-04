//
//  AMDAlertClient.swift
//  CommonFeature
//
//  Created by 김규철 on 7/4/25.
//

import Foundation

import DesignSystem

import Dependencies

public struct AMDAlertClient {
  public var present: @Sendable (_ property: AMDAlertProperty) async -> Void
  public var dismiss: @Sendable () async -> Void
}

extension AMDAlertClient: DependencyKey {
  public static var liveValue: AMDAlertClient {
    return Self(
      present: { property in
        await AMDAlertManager.shared.showAlert(property)
      },
      dismiss: {
        await AMDAlertManager.shared.hideAlert()
      }
    )
  }
}

public extension DependencyValues {
  var alertClient: AMDAlertClient {
    get { self[AMDAlertClient.self] }
    set { self[AMDAlertClient.self] = newValue }
  }
}
