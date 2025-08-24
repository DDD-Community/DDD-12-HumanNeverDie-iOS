//
//  AMDCalenderModel.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/29/25.
//

import Foundation
import DesignSystem
import SwiftUICore

public struct SugarIntakeRecord : Equatable {
  public let date: Date
  public let value: Int
  public let recordCount: Int
  
  public init(date: Date, value: Int, recordCount: Int) {
    self.date = date
    self.value = value
    self.recordCount = recordCount
  }
}

public struct DateValue: Identifiable {
  public var id: UUID = UUID()
  public var day: Int
  public var date : Date
}

public enum AMDStateIcon {
  case none
  case healthy
  case warning
  case danger
  
  init(percentage: Double, recordCount: Int) {
    switch percentage {
    case 0:
      self = recordCount > 0 ? .healthy : .none
    case ...33:
      self = .healthy
    case ...66:
      self = .warning
    default:
      self = .danger
    }
  }
  
  public var icon: Image? {
    switch self {
    case .none:   return nil
    case .healthy: return AMDImage.stateHealthy.swiftUIImage
    case .warning: return AMDImage.stateWarning.swiftUIImage
    case .danger:  return AMDImage.stateDanger.swiftUIImage
    }
  }
}

public enum AMDWeekdayTile: Int, CaseIterable, Identifiable{
  case sunday = 1
  case monday = 2
  case tuesday = 3
  case wednesday = 4
  case thursday = 5
  case friday = 6
  case saturday = 7
  
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

public struct CalendarDayModel: Identifiable {
  public let id = UUID()
  public let value: DateValue
  public let isToday: Bool
  public let isSelected: Bool
  public let textColor: Color
  public let stateIcon: Image?
}


