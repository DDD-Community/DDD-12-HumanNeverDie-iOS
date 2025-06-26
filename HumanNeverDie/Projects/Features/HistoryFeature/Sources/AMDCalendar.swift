//
//  AMDCalendar.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/23/25.
//

import SwiftUI
import DesignSystem

struct AMDCalendar: View {
  @StateObject private var viewModel: AMDCalendarViewModel
  @Binding var selectedDate: Date?
  

  init(viewModel: AMDCalendarViewModel, selectedDate: Binding<Date?>) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _selectedDate = selectedDate
  }
  
  var body: some View {
    VStack(spacing: 20) {
      
      calendarCommonView()
      DateView()
    
    }
    .onChange(of: viewModel.currentMonth) {
      viewModel.updateCurrentDateToCurrentMonth()
    }.highPriorityGesture(
      
      DragGesture()
        .onEnded { value in
          viewModel.handleDragGesture(value.translation)
        }
    )
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
  
  @ViewBuilder
  func DateView() -> some View {
    LazyVGrid(columns: viewModel.columns, spacing: 15) {
      ForEach(viewModel.extractDate()) { dateValue in
        DayView(value: dateValue)
          .frame(width: 44, height: 44)
      }
    }
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
              .resizable()
              .scaledToFit()
//              .frame(width: 36, height: 36) //디자인 사이즈는 36인데 모양이 다름
          }
          
          Text("\(value.day)")
            .amdFont(.mediumMedium)
            .foregroundColor(textColor)
        }
        .frame(width: 44, height: 44)
        .padding(6) //디자인상은 10인데..?
        .background(
          Group {
            if isSelected {
              RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray10)
            } else {
              Color.clear
            }
          }
        )
        .overlay(
          (!isSelected && isToday) ?
            RoundedRectangle(cornerRadius: 15)
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
