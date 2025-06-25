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
  

  init(viewModel: AMDCalendarViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Button(action: {
          // selectDatePicker...
        }) {
          HStack(spacing: 4) {
            Text(extraDate())
              .amdFont(.xlargeBold)
              .foregroundColor(Color.gray100)
            
            Image(systemName: "chevron.down")
              .foregroundColor(Color.gray50)
          }
        }
        Spacer()
      }
      .padding(.horizontal)
      
      LazyVGrid(columns: viewModel.columns, spacing: 15) {
        ForEach(Array(viewModel.days.enumerated()), id: \.offset) { index, day in
          Text(day)
            .amdFont(.mediumMedium)
            .fontWeight(.semibold)
            .foregroundColor(viewModel.weekdayColor(index + 1))
            .frame(width: 44, height: 20)
        }
      }
      
      //Dates
      //Lazy Grid
      let columns = Array(repeating: GridItem(.flexible()), count: 7)
      
      LazyVGrid(columns: columns, spacing: 15) {
        ForEach(viewModel.extractDate()) { dateValue in
          CardView(value: dateValue)
            .frame(width: 44, height: 44)
        }
      }
    }
    .onChange(of: viewModel.currentMonth) {
      //updateing Month
      viewModel.currentDate = viewModel.getCurrentMonth()
    }.highPriorityGesture(
      DragGesture()
        .onEnded { value in
          if value.translation.width < -50 {
            withAnimation { viewModel.currentMonth += 1 }
          } else if value.translation.width > 50 {
            withAnimation { viewModel.currentMonth -= 1 }
          }
        }
    )
  }
  
  @ViewBuilder
  func CardView(value: DateValue) -> some View {
    let calendar = Calendar.current
    let isToday = calendar.isDateInToday(value.date)
    let weekday = calendar.component(.weekday, from: value.date)
    let isSelected = viewModel.selectedDate != nil && calendar.isDate(viewModel.selectedDate!, inSameDayAs: value.date)
    let matchingValue = viewModel.valueByDate.first { calendar.isDate($0.key, inSameDayAs: value.date) }?.value
    let textColor = viewModel.weekdayColor(weekday)
    
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
          viewModel.selectedDate = value.date
          viewModel.currentDate = value.date
        }
      }
    }
    .frame(maxWidth: .infinity)
  }
  
  func extraDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM"
    
    return formatter.string(from: viewModel.currentDate)
  }
  
  func getCurrentMonth() -> Date {
    let calender = Calendar.current
    
    guard let currentMonth = calender.date(byAdding: .month, value: viewModel.currentMonth, to: Date()) else {
      return Date()
    }
    
    return currentMonth
  }
  

}

extension Date {
  func getAllDates()->[Date] {
    let calender = Calendar.current
    let startDate = calender.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    
    let range = calender.range(of: .day, in: .month, for: startDate)!
    
    //getting date..
    return range.compactMap { day -> Date in
      return calender.date(byAdding: .day, value: day - 1, to: startDate)!
    }
  }
}
