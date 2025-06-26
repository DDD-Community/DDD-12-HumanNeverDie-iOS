//
//  AMDPickerDemoView.swift
//  DesignSystem
//
//  Created by 김규철 on 6/26/25.
//

import SwiftUI

import DesignSystem

struct AMDPickerDemoView: View {
  @State private var yearMonthDate = Date()
  @State private var yearMonthDayDate = Date()
  @State private var timeDate = Date()
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {
        yearMonthSection
        yearMonthDaySection
        timeSection
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 32)
    }
  }
  
  private var yearMonthSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Year Month Picker")
        .amdFont(.mediumBold)
        .foregroundColor(.gray60)
      
      VStack(spacing: 16) {
        AMDPicker(
          selectedDate: $yearMonthDate,
          pickerType: .yearMonth
        )
        .frame(height: 200)
        
        selectedDateDisplay(
          title: "선택된 날짜 (년월):",
          date: yearMonthDate,
          format: "yyyy년 MM월"
        )
      }
      .padding(.horizontal, 24)
    }
  }
  
  private var yearMonthDaySection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Year Month Day Picker")
        .amdFont(.mediumBold)
        .foregroundColor(.gray60)
      
      VStack(spacing: 16) {
        AMDPicker(
          selectedDate: $yearMonthDayDate,
          pickerType: .yearMonthDay
        )
        .frame(height: 200)
        
        selectedDateDisplay(
          title: "선택된 날짜 (년월일):",
          date: yearMonthDayDate,
          format: "yyyy년 MM월 dd일"
        )
      }
      .padding(.horizontal, 24)
    }
  }
  
  private var timeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Time Picker")
        .amdFont(.mediumBold)
        .foregroundColor(.gray60)
      
      VStack(spacing: 16) {
        AMDPicker(
          selectedDate: $timeDate,
          pickerType: .time
        )
        .frame(height: 200)
        
        selectedDateDisplay(
          title: "선택된 시간:",
          date: timeDate,
          format: "a h:mm"
        )
      }
      .padding(.horizontal, 24)
    }
  }
  
  private func selectedDateDisplay(title: String, date: Date, format: String) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .amdFont(.smallRegular)
        .foregroundColor(.gray40)
      
      Text(dateFormatter(format: format).string(from: date))
        .amdFont(.mediumBold)
        .foregroundColor(.gray95)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray5)
        .amdCornerRadius(.medium)
    }
  }
  
  private func dateFormatter(format: String) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
  }
}
