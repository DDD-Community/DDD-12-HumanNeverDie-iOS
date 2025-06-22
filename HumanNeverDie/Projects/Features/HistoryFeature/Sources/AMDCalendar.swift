//
//  AMDCalendar.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/23/25.
//

import SwiftUI

struct AMDCalendar: View {
  @State var currentMonth: Int = 0
  @Binding var currentDate: Date
  let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
  
  var body: some View {
    VStack(spacing: 20) {
      HStack(spacing: 20) {
        
        Text(extraDate())
          .font(.title)
          .fontWeight(.semibold)
      
        Button {
          withAnimation {
            currentMonth -= 1
          }
          
        } label: {
          Image(systemName: "chevron.left")
            .font(.title2)
        }
        
        Button {
          withAnimation {
            currentMonth += 1
          }
          
        } label: {
          Image(systemName: "chevron.right")
            .font(.title2)
        }
        
        Spacer()
      }
      .padding(.horizontal)
      
      //Day View..
      HStack(spacing: 0) {
        ForEach(days, id: \.self) { day in
          Text(day)
            .font(.caption)
            .fontWeight(.semibold)
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
    }
  }
  
  @ViewBuilder
  func CardView(value: DateValue)->some View{
    VStack {
      if value.day != -1 {
        Text("\(value.day)")
          .font(.caption)
      }
    }
    .padding(.vertical, 8)
    .frame(height: 20, alignment: .top)
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
