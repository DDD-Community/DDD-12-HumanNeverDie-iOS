//
//  AMDCalendarSampleView.swift
//  CommonFeature
//
//  Created by Seulki Lee on 7/1/25.
//
import SwiftUI

public struct AMDCalendarSampleView: View {
  @State private var viewModel: AMDCalendarSampleViewModel
  @State private var isMonthPickerPresented = false
  @State private var isWeekPickerPresented = false
  @State private var tempDate = Date()
  
  public init(viewModel: AMDCalendarSampleViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }

  public var body: some View {
    VStack(spacing: 20) {
      
      Text("📅 월별 캘린더")
        .font(.title3.bold())
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
      
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
          datePickerSheet(
            isPresented: $isMonthPickerPresented,
            selection: $tempDate,
            onConfirm: {
              viewModel.selectedDate = tempDate
            }
          )
        }

        Divider().padding(.vertical, 16)
        
        Text("📆 주별 캘린더")
          .font(.title3.bold())
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal)
        
        AMDCalendarFactory.createWeekly(
          currentDate: viewModel.currentDate,
          sugarIntakeRecordData: viewModel.sugarIntakeRecordData,
          userSugarTargetValue: 50,
          selectedDate: $viewModel.selectedDate,
          onTapTitle: {
            tempDate = viewModel.selectedDate ?? Date()
            isWeekPickerPresented = true
          }
        ).sheet(isPresented: $isMonthPickerPresented) {
          datePickerSheet(
            isPresented: $isMonthPickerPresented,
            selection: $tempDate,
            onConfirm: {
              viewModel.selectedDate = tempDate
            }
          )
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
  
  @ViewBuilder
  private func datePickerSheet(
    isPresented: Binding<Bool>,
    selection: Binding<Date>,
    onConfirm: @escaping () -> Void
  ) -> some View {
    VStack(spacing: 20) {
      DatePicker(
        "날짜 선택",
        selection: selection,
        displayedComponents: [.date]
      )
      .datePickerStyle(.wheel)
      .labelsHidden()
      
      Button("확인") {
        onConfirm()
        isPresented.wrappedValue = false
      }
      
      Button("닫기") {
        isPresented.wrappedValue = false
      }
      .foregroundColor(.red)
    }
    .padding()
  }
}

extension DateFormatter {
  static let calendarDayFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter
  }()
}

