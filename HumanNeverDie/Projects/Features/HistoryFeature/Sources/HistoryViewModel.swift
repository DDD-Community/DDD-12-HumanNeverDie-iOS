//
// HistoryViewModel.swift
// History
//
// Created by 김규철 on 2025.
//

import Foundation
import Observation

import CommonFeature

@Observable
@MainActor
public final class HistoryViewModel :ViewModelable {
  @ObservationIgnored
  private(set) var currentDate: Date = Date()
  @ObservationIgnored
  private(set) var sugarIntakeRecordData: [SugarIntakeRecord] = HistoryViewModel.sampleData
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
  
  @ObservationIgnored
  public static var sampleData: [SugarIntakeRecord] {
    let calendar = Calendar.current
    let baseDate = calendar.date(from: DateComponents(year: 2025, month: 5, day: 1))!
    return (0..<40).compactMap {
      guard let date = calendar.date(byAdding: .day, value: $0, to: baseDate) else { return nil }
      return SugarIntakeRecord(date: date, value: Int.random(in: 0...50))
    }
  }
}
