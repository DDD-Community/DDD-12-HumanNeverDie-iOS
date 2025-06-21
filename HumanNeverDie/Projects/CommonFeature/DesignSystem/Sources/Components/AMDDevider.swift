//
//  AMDDevider.swift
//  DesignSystem
//
//  Created by 김규철 on 6/21/25.
//

import SwiftUI

public enum AMDDeviderType {
  case list
  case section
  
  fileprivate var height: CGFloat {
    switch self {
    case .list:
      return 1
    case .section:
      return 8
    }
  }
  
  fileprivate var color: Color {
    switch self {
    case .list:
      return .gray15
    case .section:
      return .gray10
    }
  }
}

public struct AMDDevider: View {
  private var type: AMDDeviderType
  
  public init(type: AMDDeviderType = .list) {
    self.type = type
  }
  
  public var body: some View {
    Divider()
      .foregroundStyle(type.color)
      .frame(maxWidth: .infinity, minHeight: type.height, maxHeight: type.height)
  }
}
