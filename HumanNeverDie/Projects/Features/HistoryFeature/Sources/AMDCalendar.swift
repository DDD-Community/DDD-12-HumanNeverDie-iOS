//
//  AMDCalendar.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/23/25.
//

import SwiftUI
import DesignSystem

struct AMDCalendar: View {
  @State var currentMonth: Int = 0
  let valueByDate: [Date: Int]
  @Binding var currentDate: Date
  @State private var selectedDate: Date? = nil
  let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
  let defaultValue = 50
  
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Button(action: {
          // selectDatePicker...
        }) {
          HStack(spacing: 4) {
            Text(extraDate()) // "2025.1"
              .amdFont(.xlargeBold)
              .foregroundColor(Color.gray100)
            
            Image(systemName: "chevron.down")
              .foregroundColor(Color.gray50)
          }
        }
        Spacer()
      }
      .padding(.horizontal)
      
      //Day View..
      HStack(spacing: 0) {
        ForEach(Array(days.enumerated()), id: \.offset) { index, day in
          
          Text(day)
            .amdFont(.mediumMedium)
            .fontWeight(.semibold)
            .foregroundColor(weekdayColor(index + 1))
            .frame(maxWidth: .infinity)
            .frame(height: 20)
        }
      }
      
      //Dates
      //Lazy Grid
      let columns = Array(repeating: GridItem(.flexible()), count: 7)
      
      LazyVGrid(columns: columns, spacing: 15) {
        ForEach(extractDate()) { dateValue in
          CardView(value: dateValue)
            .frame(width: 44, height: 44)
        }
      }
    }
    .onChange(of: currentMonth) {
      //updateing Month
      currentDate = getCurrentMonth()
    }.highPriorityGesture(
      DragGesture()
        .onEnded { value in
          if value.translation.width < -50 {
            withAnimation { currentMonth += 1 }
          } else if value.translation.width > 50 {
            withAnimation { currentMonth -= 1 }
          }
        }
    )
  }
  
  @ViewBuilder
  func CardView(value: DateValue) -> some View {
    let calendar = Calendar.current
    let isToday = calendar.isDateInToday(value.date)
    let weekday = calendar.component(.weekday, from: value.date)
    let isSelected = selectedDate != nil && calendar.isDate(selectedDate!, inSameDayAs: value.date)
    let matchingValue = valueByDate.first { calendar.isDate($0.key, inSameDayAs: value.date) }?.value
    
    let textColor: Color = {
      if isSelected && !(weekday == 1 || weekday == 7) {
        return Color.gray100
      } else {
        return weekdayColor(weekday)
      }
    }()
    
    VStack {
      if value.day != -1 {
        ZStack {
          if let val = matchingValue {
            getStateIcon(for: val)
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
          isToday ?
            RoundedRectangle(cornerRadius: 15)
              .stroke(Color.gray25, lineWidth: 1)
          : nil
        )
        .onTapGesture {
          selectedDate = value.date
          currentDate = value.date
        }
      }
    }
    .frame(maxWidth: .infinity)
  }
  
  func getStateIcon(for value: Int) -> Image {
    let percentage = Double(value) / Double(defaultValue) * 100
    
    if percentage <= 33 {
      return AMDImage.stateHealthy.swiftUIImage
    } else if percentage <= 66 {
      return AMDImage.stateWarning.swiftUIImage
    } else {
      return AMDImage.stateDanger.swiftUIImage
    }
  }
  
  func weekdayColor(_ weekday: Int) -> Color {
    switch weekday {
    case 1: return Color.redDarker
    case 7: return Color.primaryDarker
    default: return Color.gray80
    }
  }
  
  func extraDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM"
    
    return formatter.string(from: currentDate)
  }
  
  func getCurrentMonth() -> Date {
    let calender = Calendar.current
    
    guard let currentMonth = calender.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
      return Date()
    }
    
    return currentMonth
  }
  
  
  func extractDate() -> [DateValue] {
    let calendar = Calendar.current
    
    let currentMonth = getCurrentMonth()
    
    var days = currentMonth.getAllDates().compactMap { date -> DateValue in
      let day = calendar.component(.day, from: date)
      
      return DateValue(day: day, date: date)
    }
    
    //adding offset days get exact wook day
    let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
    for _ in 0..<firstWeekday - 1 {
      days.insert(DateValue(day: -1, date: Date()), at: 0)
    }
    return days
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



#Preview {
  HistoryView(viewModel: HistoryViewModel())
}

