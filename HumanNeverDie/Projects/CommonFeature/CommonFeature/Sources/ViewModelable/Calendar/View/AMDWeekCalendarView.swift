//
//  AMDWeekCalendar.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/26/25.
//

import SwiftUI

struct AMDWeekCalendarView: View {
  @StateObject private var viewModel: AMDWeekCalendarViewModel
  @Binding var selectedDate: Date?

  init(viewModel: AMDWeekCalendarViewModel, selectedDate: Binding<Date?>) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _selectedDate = selectedDate
  }
  
  var body: some View {
    VStack(spacing: 0) {
      calendarHeaderView()
      
      HStack(spacing: 0) {
          calendarDayCellView()
      }.highPriorityGesture(
        DragGesture()
          .onEnded { value in
            withAnimation(.easeInOut) {
              viewModel.handleDragGesture(value.translation)
            }
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
  func calendarDayCellView() -> some View {
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

