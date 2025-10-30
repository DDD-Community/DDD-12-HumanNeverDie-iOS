//
//  AMDToastClient.swift
//  CommonFeature
//
//  Created by 김규철 on 7/5/25.
//

import Foundation

import DesignSystem

import Dependencies

public struct AMDToastClient: Sendable {
  public var showToast: @Sendable (_ property: AMDToastProperty) async -> Void
}

extension AMDToastClient: DependencyKey {
  public static var liveValue: AMDToastClient {
    return Self(
      showToast: { property in
        await MainActor.run {
          AMDToastManager.shared.showToast(property)
        }
      }
    )
  }
}

public extension DependencyValues {
  var toastClient: AMDToastClient {
    get { self[AMDToastClient.self] }
    set { self[AMDToastClient.self] = newValue }
  }
}
