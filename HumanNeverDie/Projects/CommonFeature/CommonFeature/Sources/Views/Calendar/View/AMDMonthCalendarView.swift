//
//  AMDMonthCalendarView.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/23/25.
//

import SwiftUI

struct AMDMonthCalendarView: View {
  @State private var viewModel: AMDMonthCalendarViewModel
  @Binding var selectedDate: Date?
  private let onTapTitle: () -> Void
  
  init(viewModel: AMDMonthCalendarViewModel, selectedDate: Binding<Date?>, onTapTitle: @escaping () -> Void) {
    self.viewModel = viewModel
    self._selectedDate = selectedDate
    self.onTapTitle = onTapTitle
  }
  
  var body: some View {
    VStack(spacing: 0) {
      
      calendarHeaderView()
      calendarDayCellView()
      
    }
    .onChange(of: viewModel.currentMonth) {
      viewModel.updateCurrentDateToCurrentMonth()
    }.highPriorityGesture(
      
      DragGesture()
        .onEnded { value in
          withAnimation(.easeInOut) {
            viewModel.handleDragGesture(value.translation)
          }
        }
    ).padding()
  }
  
  @ViewBuilder
  private func calendarHeaderView() -> some View {
    CalendarTitleView(
      title: viewModel.MonthTitleDateString,
      onTap: onTapTitle
    ).onChange(of: selectedDate) {
      if let date = selectedDate {
        viewModel.updateCurrentDate(to: date)
        viewModel.selectDate(date)
        viewModel.updateDayModels()
      }
    }
    
    CalendarWeekdayTitleView(
      items: viewModel.weekdayItems,
      columns: viewModel.columns
    )
  }
  
  @ViewBuilder
  func calendarDayCellView() -> some View {
    LazyVGrid(columns: viewModel.columns, spacing: 15) {
      ForEach(viewModel.dayModels) { model in
        CalendarDayView(
          value: model.value,
          isToday: model.isToday,
          isSelected: model.isSelected,
          textColor: model.textColor,
          stateIcon: model.stateIcon,
          onTap: {
            selectedDate = model.value.date
            viewModel.selectDate(model.value.date)
            viewModel.updateDayModels()
          }
        )
      }
    }
  }
}
