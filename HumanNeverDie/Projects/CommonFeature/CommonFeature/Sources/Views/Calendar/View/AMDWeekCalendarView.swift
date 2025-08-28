//
//  AMDWeekCalendar.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/26/25.
//

import SwiftUI

struct AMDWeekCalendarView: View {
  @State private var viewModel: AMDWeekCalendarViewModel
  @Binding var selectedDate: Date?
  @Binding var userSugarTargetValue: Int
  private let onTapTitle: () -> Void
  private let onWeekChanged: (Date) -> Void
  private let currentDate: Date
  private let sugarIntakeRecordData: [SugarIntakeRecord]
  
  init(
    currentDate: Date,
    sugarIntakeRecordData: [SugarIntakeRecord],
    userSugarTargetValue: Binding<Int>,
    selectedDate: Binding<Date?>,
    onTapTitle: @escaping () -> Void,
    onWeekChanged: @escaping (Date) -> Void
  ) {
    // 외부 데이터 저장
    self.currentDate = currentDate
    self.sugarIntakeRecordData = sugarIntakeRecordData
    self._userSugarTargetValue = userSugarTargetValue
    self._selectedDate = selectedDate
    self.onTapTitle = onTapTitle
    self.onWeekChanged = onWeekChanged
    
    // viewModel 초기 생성
    self._viewModel = State(initialValue: AMDWeekCalendarViewModel(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue
    ))
  }
  
  
  var body: some View {
    VStack(spacing: 0) {
      calendarHeaderView()
      
      LazyVGrid(columns: viewModel.columns, spacing: 15) {
         calendarDayCellView()
       }.highPriorityGesture(
        DragGesture()
          .onEnded { value in
            withAnimation(.easeInOut) {
              viewModel.handleDragGesture(value.translation)
              let newWeekDate = viewModel.getCurrentWeekStartDate()
              onWeekChanged(newWeekDate)
            }
          }
      )
    }.onChange(of: sugarIntakeRecordData) { _, newData in
      viewModel.updateSugarIntakeData(newData)
    }
    .padding()
  }
  
  @ViewBuilder
  private func calendarHeaderView() -> some View {
    CalendarTitleView(
      title: viewModel.weekTitleDateString,
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

