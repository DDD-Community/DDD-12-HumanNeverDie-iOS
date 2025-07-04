//
//  AMDAlertProperty.swift
//  DesignSystem
//
//  Created by 김규철 on 7/4/25.
//

import Foundation

public struct AMDAlertProperty {
  public let title: String
  public let message: String
  public let subMessage: String?
  public let primaryButton: AMDAlertButtonProperty
  public let secondaryButton: AMDAlertButtonProperty?
  
  public init(
    title: String,
    message: String,
    subMessage: String? = nil,
    primaryButton: AMDAlertButtonProperty,
    secondaryButton: AMDAlertButtonProperty? = nil
  ) {
    self.title = title
    self.message = message
    self.subMessage = subMessage
    self.primaryButton = primaryButton
    self.secondaryButton = secondaryButton
  }
}

public struct AMDAlertButtonProperty {
  public let title: String
  public let type: AMDButton.AMDButtonType
  public let action: () async -> Void
  
  public init(
    title: String,
    type: AMDButton.AMDButtonType,
    action: @escaping () async -> Void
  ) {
    self.title = title
    self.type = type
    self.action = action
  }
}
