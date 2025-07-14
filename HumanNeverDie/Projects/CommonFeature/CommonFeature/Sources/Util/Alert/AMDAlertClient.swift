//
//  AMDAlertClient.swift
//  CommonFeature
//
//  Created by 김규철 on 7/4/25.
//

import Foundation

import DesignSystem

import Dependencies

public struct AMDAlertClient: Sendable {
  public var showAlert: @Sendable (_ property: AMDAlertProperty) async -> Void
  public var hideAlert: @Sendable () async -> Void
}

extension AMDAlertClient: DependencyKey {
  public static var liveValue: AMDAlertClient {
    return Self(
      showAlert: { @MainActor property in
        AMDAlertManager.shared.showAlert(property)
      },
      hideAlert: {
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
