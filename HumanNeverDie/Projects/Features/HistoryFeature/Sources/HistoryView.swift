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
  @State private var currentDate: Date = Date() // 단일 날짜 선택
  var calendarView: some View {
    AMDCalendarFactory.create(
      currentDate: currentDate,
      valueByDate: sampleData,
      defaultValue: 50
    )
  }

  private let sampleData: [Date: Int] = {
    var dict: [Date: Int] = [:]
    let calendar = Calendar.current
    let baseDate = calendar.date(from: DateComponents(year: 2025, month: 5, day: 1))!

    for i in 0..<40 {
      if let date = calendar.date(byAdding: .day, value: i, to: baseDate) {
        dict[date] = Int.random(in: 0...50)
      }
    }
    return dict
  }()

  public init(viewModel: HistoryViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }

  public var body: some View {
    VStack(spacing: 20) {
      calendarView

      ScrollView(.vertical, showsIndicators: false) {
        Color.red // 선택된 날짜 관련 내용
      }
    }
  }
}

#Preview {
  HistoryView(viewModel: HistoryViewModel())
}
