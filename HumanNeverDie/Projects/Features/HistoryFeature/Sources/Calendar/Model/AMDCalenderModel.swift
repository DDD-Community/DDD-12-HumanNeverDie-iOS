//
//  AMDCalenderModel.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/29/25.
//

import Foundation
import DesignSystem
import SwiftUICore

public struct SugarIntakeRecord {
  let date: Date
  let value: Int
}

public struct WeekdayValue: Identifiable {
  public let id = UUID()
  let label: String
  let color: Color
}

public struct DateValue: Identifiable {
  public var id: UUID = UUID()
  var day: Int
  var date : Date
}

public enum AMDStateIcon {
  case healthy
  case warning
  case danger

  init(percentage: Double) {
    switch percentage {
    case ...33:
      self = .healthy
    case ...66:
      self = .warning
    default:
      self = .danger
    }
  }

  var icon: Image {
    switch self {
    case .healthy: return AMDImage.stateHealthy.swiftUIImage
    case .warning: return AMDImage.stateWarning.swiftUIImage
    case .danger:  return AMDImage.stateDanger.swiftUIImage
    }
  }
}
