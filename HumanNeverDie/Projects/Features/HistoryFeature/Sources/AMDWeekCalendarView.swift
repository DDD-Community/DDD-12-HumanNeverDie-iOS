//
//  AMDWeekCalendar.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/26/25.
//

import SwiftUI

struct AMDWeekCalendarView: View {
  @StateObject private var viewModel: AMDCalendarViewModel
  @Binding var selectedDate: Date?
  
  init(viewModel: AMDCalendarViewModel, selectedDate: Binding<Date?>) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _selectedDate = selectedDate
  }

  
  var body: some View {
    VStack(spacing: 10) {
      calendarCommonView()
      
      // 주간 날짜 표시
      HStack {
        ForEach(viewModel.getCurrentWeekDates(), id: \.self) { date in
          let day = viewModel.getWeekCalendarDay(from: date)
          let isToday = viewModel.isToday(date)
          
          Text("\(day)")
            .font(.body)
            .frame(width: 44, height: 44)
            .background(isToday ? Color.blue : Color.gray.opacity(0.2))
            .foregroundColor(isToday ? .white : .primary)
            .clipShape(Circle())
            .onTapGesture {
              selectedDate = date
              viewModel.selectDate(date)
            }
        }
      }.highPriorityGesture(
        
        DragGesture()
          .onEnded { value in
            viewModel.handleWeekDragGesture(value.translation)
          }
      )
    }
    .padding()
  }
  @ViewBuilder
  private func calendarCommonView() -> some View {
    CalendarTitleView(
      title: viewModel.titleDateString
    ) {
      //데이터피커
    }

    CalendarWeekdayView(
      items: viewModel.weekdayItems,
      columns: viewModel.columns
    )
  }
}
