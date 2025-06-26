//
//  AMDWeekCalendar.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/26/25.
//

import SwiftUI

struct AMDWeekCalendar: View {
  @StateObject private var viewModel: AMDCalendarViewModel
  @Binding var selectedDate: Date?
  
  init(viewModel: AMDCalendarViewModel, selectedDate: Binding<Date?>) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _selectedDate = selectedDate
  }
  
    @State private var currentWeekStartDate: Date = Date().startOfWeek()
    let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 10) {
            // 요일 헤더
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }

            // 주간 날짜 표시
            HStack {
                ForEach(getCurrentWeekDates(), id: \.self) { date in
                    let day = calendar.component(.day, from: date)
                    let isToday = calendar.isDateInToday(date)

                    Text("\(day)")
                        .font(.body)
                        .frame(width: 44, height: 44)
                        .background(isToday ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(isToday ? .white : .primary)
                        .clipShape(Circle())
                }
            }

            // 이전/다음 주 이동 버튼
            HStack(spacing: 20) {
                Button("〈 이전 주") {
                    moveWeek(by: -1)
                }

                Button("다음 주 〉") {
                    moveWeek(by: 1)
                }
            }
            .font(.footnote)
            .padding(.top, 10)
        }
        .padding()
    }

    // 현재 주의 날짜 배열 가져오기
    func getCurrentWeekDates() -> [Date] {
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: currentWeekStartDate)
        }
    }

    // 주 이동
    func moveWeek(by weeks: Int) {
        if let newWeek = calendar.date(byAdding: .weekOfYear, value: weeks, to: currentWeekStartDate) {
            currentWeekStartDate = newWeek
        }
    }
}

extension Date {
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
}
