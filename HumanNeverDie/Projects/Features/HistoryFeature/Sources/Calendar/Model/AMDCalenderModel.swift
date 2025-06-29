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

enum AMDWeekdayTile: Int, CaseIterable, Identifiable{
  case sunday
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  
  public var id: Int { rawValue }
  
  public init(_ rawValue: Int) {
    self = AMDWeekdayTile(rawValue: rawValue) ?? .monday //
  }
  
  public var label: String {
    switch self {
    case .sunday: return "일"
    case .monday: return "월"
    case .tuesday: return "화"
    case .wednesday: return "수"
    case .thursday: return "목"
    case .friday: return "금"
    case .saturday: return "토"
    }
  }

  public var color: Color {
    switch self {
    case .sunday: return .redDarker
    case .saturday: return .primaryDarker
    default: return .gray80
    }
  }
}
