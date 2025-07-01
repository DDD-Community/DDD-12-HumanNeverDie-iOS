//
// HistoryView.swift
// History
//
// Created by 김규철 on 2025.
//

import SwiftUI
import CommonFeature

public struct HistoryView: View {
  @State private var viewModel: HistoryViewModel
  @State private var isMonthPickerPresented = false
  @State private var isWeekPickerPresented = false
  @State private var tempDate = Date()
  
  public init(viewModel: HistoryViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }

  public var body: some View {
    VStack(spacing: 20) {
      ScrollView(.vertical, showsIndicators: false) {
        AMDCalendarFactory.createMonth(
          currentDate: viewModel.currentDate,
          sugarIntakeRecordData: viewModel.sugarIntakeRecordData,
          userSugarTargetValue: 50,
          selectedDate: $viewModel.selectedDate,
          onTapTitle: {
            tempDate = viewModel.selectedDate ?? Date()
            isMonthPickerPresented = true
          }
        ).sheet(isPresented: $isMonthPickerPresented) {
          VStack(spacing: 20) {
            DatePicker(
              "날짜 선택",
              selection: $tempDate,
              displayedComponents: [.date]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()

            Button("확인") {
              viewModel.selectedDate = tempDate
              isMonthPickerPresented = false
            }

            Button("닫기") {
              isMonthPickerPresented = false
            }
            .foregroundColor(.red)
          }
          .padding()
        }

        
        Color.gray // 선택된 날짜 관련 내용
        
        AMDCalendarFactory.createWeekly(
          currentDate: viewModel.currentDate,
          sugarIntakeRecordData: viewModel.sugarIntakeRecordData,
          userSugarTargetValue: 50,
          selectedDate: $viewModel.selectedDate,
          onTapTitle: {
            tempDate = viewModel.selectedDate ?? Date()
            isWeekPickerPresented = true
          }
        ).sheet(isPresented: $isWeekPickerPresented) {
          VStack(spacing: 20) {
            DatePicker(
              "날짜 선택",
              selection: $tempDate,
              displayedComponents: [.date]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()

            Button("확인") {
              viewModel.selectedDate = tempDate
              isWeekPickerPresented = false
            }

            Button("닫기") {
              isWeekPickerPresented = false
            }
            .foregroundColor(.red)
          }
          .padding()
        }

        
        if let selected = viewModel.selectedDate {
          Text("선택한 날짜: \(DateFormatter.calendarDayFormat.string(from: selected))")
        } else {
          Text("날짜를 선택해주세요.")
            .padding()
        }
      }
    }
  }
}

extension DateFormatter {
  static let calendarDayFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter
  }()
}

#Preview {
  HistoryView(viewModel: HistoryViewModel())
}
