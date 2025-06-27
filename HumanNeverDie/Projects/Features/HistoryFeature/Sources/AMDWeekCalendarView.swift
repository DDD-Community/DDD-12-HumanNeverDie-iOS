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
        ForEach(viewModel.getCurrentWeekDates()) { dateValue in
          DayView(value: dateValue)
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
      title: viewModel.weekTitleDateString
    ) {
      //데이터피커
    }

    CalendarWeekdayView(
      items: viewModel.weekdayItems,
      columns: viewModel.columns
    )
  }
  
  @ViewBuilder
  func DayView(value: DateValue) -> some View {
    let isToday = viewModel.isToday(value.date)
    let isSelected = viewModel.isSelected(value.date)
    let textColor = viewModel.textColor(for: value.date)
    let matchingValue = viewModel.matchingValue(for: value.date)
    
    VStack {
      if value.day != -1 {
        ZStack {
          if let val = matchingValue {
            viewModel.getStateIcon(for: val)
              .frame(width: 36, height: 36)
          }
          
          Text("\(value.day)")
            .amdFont(.mediumMedium)
            .foregroundColor(textColor)
        }
        .frame(width: 44, height: 44)
        .padding(2)
        .background(
          Group {
            if isSelected {
              RoundedRectangle(cornerRadius: 13)
                .fill(Color.gray10)
            } else {
              Color.clear
            }
          }
        )
        .overlay(
          (!isSelected && isToday) ?
            RoundedRectangle(cornerRadius: 13)
              .stroke(Color.gray25, lineWidth: 1) : nil
        )
        .onTapGesture {
          selectedDate = value.date
          viewModel.selectDate(value.date)
        }
      }
    }
    .frame(maxWidth: .infinity)
  }
}

