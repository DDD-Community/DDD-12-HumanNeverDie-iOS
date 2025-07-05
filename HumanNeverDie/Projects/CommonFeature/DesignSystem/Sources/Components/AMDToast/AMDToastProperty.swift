//
//  AMDToastProperty.swift
//  DesignSystem
//
//  Created by 김규철 on 7/5/25.
//

import Foundation

public struct AMDToastProperty {
  public let message: String
  public let type: AMDToastType
  
  public init(
    message: String,
    type: AMDToastType = .success
  ) {
    self.message = message
    self.type = type
  }
}

public enum AMDToastType {
  case success
  case failure
}
