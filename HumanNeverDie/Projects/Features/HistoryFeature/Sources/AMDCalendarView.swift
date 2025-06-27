//
//  AMDCalendarView.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/23/25.
//

import SwiftUI
import DesignSystem

struct AMDCalendarView: View {
  @StateObject private var viewModel: AMDCalendarViewModel
  @Binding var selectedDate: Date?
  

  init(viewModel: AMDCalendarViewModel, selectedDate: Binding<Date?>) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _selectedDate = selectedDate
  }
  
  var body: some View {
    VStack(spacing: 10) {
      
      calendarHeaderView()
      calendarDayCellView()
    
    }
    .onChange(of: viewModel.currentMonth) {
      viewModel.updateCurrentDateToCurrentMonth()
    }.highPriorityGesture(
      
      DragGesture()
        .onEnded { value in
          viewModel.handleDragGesture(value.translation)
        }
    ).padding()
  }
  
  @ViewBuilder
  private func calendarHeaderView() -> some View {
    CalendarTitleView(
      title: viewModel.titleDateString
    ) {
      //데이터피커
    }

    CalendarWeekdayTitleView(
      items: viewModel.weekdayItems,
      columns: viewModel.columns
    )
  }
  
  @ViewBuilder
  func calendarDayCellView() -> some View {
    LazyVGrid(columns: viewModel.columns, spacing: 15) {
      ForEach(viewModel.extractDate()) { value in
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
  }
}
