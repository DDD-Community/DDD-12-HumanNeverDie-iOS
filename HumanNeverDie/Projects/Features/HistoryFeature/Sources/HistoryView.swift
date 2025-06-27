//
// HistoryView.swift
// History
//
// Created by 김규철 on 2025.
//

import SwiftUI
import CommonFeature

public struct HistoryView: View {
  @State private var viewModel: HistoryViewModel
  @State private var currentDate = Date()
  @State private var selectedDate: Date? = nil
  
  var calendarView: some View {
    AMDCalendarFactory.create(
      currentDate: currentDate,
      sugarIntakeRecordData: sampleData,
      userSugarTargetValue: 50,
      selectedDate: $selectedDate
    )
  }
  
  var calendarWeekView: some View {
    AMDCalendarFactory.createWeekly(
      currentDate: currentDate,
      sugarIntakeRecordData: sampleData,
      userSugarTargetValue: 50,
      selectedDate: $selectedDate
    )
  }

  private let sampleData: [SugarIntakeRecord] = {
    var array: [SugarIntakeRecord] = []
    let calendar = Calendar.current
    let baseDate = calendar.date(from: DateComponents(year: 2025, month: 5, day: 1))!

    for i in 0..<40 {
      if let date = calendar.date(byAdding: .day, value: i, to: baseDate) {
        array.append(SugarIntakeRecord(date: date, value: Int.random(in: 0...50)))
      }
    }
    return array
  }()

  public init(viewModel: HistoryViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }

  public var body: some View {
    VStack(spacing: 20) {
      ScrollView(.vertical, showsIndicators: false) {
        
        calendarView
        Color.gray // 선택된 날짜 관련 내용
        calendarWeekView
        
        if let selected = selectedDate {
          Text("선택한 날짜: \(DateFormatter.calendarDayFormat.string(from: selected))")
        } else {
          Text("날짜를 선택해주세요.")
            .padding()
        }
      }
    }
  }
}

extension DateFormatter {
  static let calendarDayFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter
  }()
}

#Preview {
  HistoryView(viewModel: HistoryViewModel())
}
