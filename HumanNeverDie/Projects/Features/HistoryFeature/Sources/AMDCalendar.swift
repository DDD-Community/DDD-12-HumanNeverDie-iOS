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
  @Binding var currentDate: Date
  @State private var selectedDate: Date? = nil
  let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
  
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Button(action: {
          // selectDatePicker...
        }) {
          HStack(spacing: 4) {
            Text(extraDate()) // "2025.1"
              .amdFont(.xlargeBold)
              .foregroundColor(DesignSystemAsset.Colors.gray100.swiftUIColor)
            
            Image(systemName: "chevron.down")
              .foregroundColor(DesignSystemAsset.Colors.gray50.swiftUIColor)
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
        }
      }
      
      //Dates
      //Lazy Grid
      let columns = Array(repeating: GridItem(.flexible()), count: 7)
      
      LazyVGrid(columns: columns, spacing: 15) {
        ForEach(extractDate()) { dateValue in
          CardView(value: dateValue)
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
    VStack {
      if value.day != -1 {
        let weekday = Calendar.current.component(.weekday, from: value.date)
        let isSelected = selectedDate != nil && Calendar.current.isDate(selectedDate!, inSameDayAs: value.date)
        
        // 클릭 시 색상 처리 조건
        let textColor: Color = {
          if isSelected && !(weekday == 1 || weekday == 7) {
            return DesignSystemAsset.Colors.gray100.swiftUIColor
          } else {
            return weekdayColor(weekday)
          }
        }()
        
        Text("\(value.day)")
          .amdFont(.mediumMedium)
          .foregroundColor(textColor)
          .frame(width: 36, height: 36)
          .padding(6)
          .overlay(
            RoundedRectangle(cornerRadius: 15)
              .stroke(isSelected ? DesignSystemAsset.Colors.gray25.swiftUIColor : .clear, lineWidth: 1)
          )
          .onTapGesture {
            selectedDate = value.date
            currentDate = value.date
          }
      }
    }
    .frame(maxWidth: .infinity)
  }
  
  func weekdayColor(_ weekday: Int) -> Color {
    switch weekday {
    case 1: return DesignSystemAsset.Colors.redDarker.swiftUIColor
    case 7: return DesignSystemAsset.Colors.primaryDarker.swiftUIColor
    default: return DesignSystemAsset.Colors.gray60.swiftUIColor
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

