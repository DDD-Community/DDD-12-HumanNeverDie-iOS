//
//  AMDCalendarSampleViewModel.swift
//  CommonFeature
//
//  Created by Seulki Lee on 7/1/25.
//
import Foundation
import Observation
import BeverageDomain

@Observable
@MainActor
public final class AMDCalendarSampleViewModel {
  private(set) var currentDate: Date = Date()
  private(set) var sugarIntakeRecordData: [SugarIntakeRecord] = AMDCalendarSampleViewModel.sampleData
  var sugerValue: Int = 50
  var selectedDate: Date? = nil
  
  public struct State: Equatable {
  }
  
  public enum Action {
    case onAppear
  }
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
    }
  }
  
  public static var sampleData: [SugarIntakeRecord] {
    let beverageCalendars = BeverageCalendar.mock()
    
    return beverageCalendars.compactMap { calendar in
      guard let date = String.toDate(from: calendar.date) else { return nil }
      
      return SugarIntakeRecord(
        date: date,
        value: calendar.totalSugarGrams,
        recordCount: calendar.records.count
      )
    }
  }
}

