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
