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
  @Binding var userSugarTargetValue: Int
  private let onTapTitle: () -> Void
  private let onMonthChanged: (Date) -> Void
  private let currentDate: Date
  private let sugarIntakeRecordData: [SugarIntakeRecord]
  
  init(
    currentDate: Date,
    sugarIntakeRecordData: [SugarIntakeRecord],
    userSugarTargetValue: Binding<Int>,
    selectedDate: Binding<Date?>,
    onTapTitle: @escaping () -> Void,
    onMonthChanged: @escaping (Date) -> Void
  ) {
    // 외부 데이터 저장
    self.currentDate = currentDate
    self.sugarIntakeRecordData = sugarIntakeRecordData
    self._userSugarTargetValue = userSugarTargetValue
    self._selectedDate = selectedDate
    self.onTapTitle = onTapTitle
    self.onMonthChanged = onMonthChanged
    
    // viewModel 초기 생성 (Binding을 넘겨줌)
    self._viewModel = State(initialValue: AMDMonthCalendarViewModel(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue  // 🎯 Binding 전달
    ))
  }
  
  var body: some View {
    VStack(spacing: 0) {
      
      calendarHeaderView()
      calendarDayCellView()
      
    }
    .onChange(of: viewModel.currentMonth) {
      viewModel.updateCurrentDateToCurrentMonth()
      
      let newDate = viewModel.getCurrentMonth()
      onMonthChanged(newDate)
    }
    .onChange(of: sugarIntakeRecordData) { _, newData in
      viewModel.updateSugarIntakeData(newData)
    }
    // 🎯 userSugarTargetValue 변경 감지 추가
    .onChange(of: userSugarTargetValue) { _, _ in
      viewModel.updateDayModels() // 캘린더 다시 그리기
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
