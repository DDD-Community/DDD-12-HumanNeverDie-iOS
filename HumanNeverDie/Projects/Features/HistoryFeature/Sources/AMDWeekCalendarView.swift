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
      calendarHeaderView()
      
      HStack {
        ForEach(viewModel.getCurrentWeekDates()) { dateValue in
          calendarDayCellView(value: dateValue)
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
  private func calendarHeaderView() -> some View {
    CalendarTitleView(
      title: viewModel.weekTitleDateString
    ) {
      //데이터피커
    }

    CalendarWeekdayTitleView(
      items: viewModel.weekdayItems,
      columns: viewModel.columns
    )
  }
  
  @ViewBuilder
  func calendarDayCellView(value: DateValue) -> some View {
    CalendarDayView(
      value: value,
      isToday: viewModel.isToday(value.date),
      isSelected: viewModel.isSelected(value.date),
      textColor: viewModel.textColor(for: value.date),
      stateIcon: viewModel.matchingValue(for: value.date).map {
        viewModel.getStateIcon(for: $0)
      },
      onTap: {
        selectedDate = value.date
        viewModel.selectDate(value.date)
      }
    )
  }
}

