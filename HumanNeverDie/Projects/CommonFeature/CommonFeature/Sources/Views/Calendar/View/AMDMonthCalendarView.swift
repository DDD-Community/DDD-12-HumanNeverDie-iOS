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
  private let currentDate: Date
  private let sugarIntakeRecordData: [SugarIntakeRecord]
  private let userSugarTargetValue: Int
  
  init(
    currentDate: Date,
    sugarIntakeRecordData: [SugarIntakeRecord],
    userSugarTargetValue: Int,
    selectedDate: Binding<Date?>,
    onTapTitle: @escaping () -> Void
  ) {
    // 외부 데이터 저장
    self.currentDate = currentDate
    self.sugarIntakeRecordData = sugarIntakeRecordData
    self.userSugarTargetValue = userSugarTargetValue
    self._selectedDate = selectedDate
    self.onTapTitle = onTapTitle
    
    // viewModel 초기 생성
    self._viewModel = State(initialValue: AMDMonthCalendarViewModel(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue
    ))
  }
  
  var body: some View {
    VStack(spacing: 0) {
      
      calendarHeaderView()
      calendarDayCellView()
      
    }
    .onChange(of: viewModel.currentMonth) {
      viewModel.updateCurrentDateToCurrentMonth()
    }
    .onChange(of: sugarIntakeRecordData) { _, newData in
      viewModel.updateSugarIntakeData(newData) 
    }
    .highPriorityGesture(
      
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
        viewModel.applySelectedDate(date)
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
            viewModel.applySelectedDate(model.value.date)
          }
        )
      }
    }
  }
}
