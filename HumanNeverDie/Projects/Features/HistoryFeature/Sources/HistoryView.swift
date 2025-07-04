//
// HistoryView.swift
// History
//
// Created by 김규철 on 2025.
//

import SwiftUI
import DesignSystem
import CommonFeature

public struct HistoryView: View {
  @Environment(Router.self) private var router
  @State private var viewModel: HistoryViewModel
  @State private var isMonthPickerPresented = false
  @State private var tempDate = Date()
  
  public init(viewModel: HistoryViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 0) {
        AMDCalendarFactory.createMonth(
          currentDate: viewModel.currentDate,
          sugarIntakeRecordData: viewModel.sugarIntakeRecordData,
          userSugarTargetValue: 50,
          selectedDate: $viewModel.selectedDate,
          onTapTitle: {
            tempDate = viewModel.selectedDate ?? Date()
            isMonthPickerPresented = true
          }
        )
        .sheet(isPresented: $isMonthPickerPresented) {
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
        
        Rectangle()
          .fill(.gray10)
          .frame(height: 8)
        
        VStack(alignment: .leading, spacing: 0) {
          AMDSugarStatusView(
            variant: .healthy,
            style: .history(drinkCount: 2, sugar: 100, baseSugar: 50)
          )
          addDrinkButton
        }
        .padding(.horizontal, 20)
        mediumSampleSection
        
      }
    }
  }
  
  
  private var addDrinkButton: some View {
    Button(action: {
      router.push(to: .beverageRecordList) 
      print("음료 추가하기 눌림")
    }) {
      HStack(spacing: 8) {
        Image(systemName: "plus.circle")
          .font(.system(size: 16))
        Text("음료 추가하기")
          .amdFont(.mediumMedium)
      }
      .foregroundStyle(.gray60)
      .frame(maxWidth: .infinity)
      .frame(minHeight: 52, maxHeight: 52)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
          .foregroundColor(Color.gray40)
      )
    }
    .padding(.vertical, 10) // 버튼 외부 여백
  }
  
  private var mediumSampleSection: some View {
    VStack(alignment: .leading, spacing: 0) {        LazyVStack(spacing: 20) {
      ForEach(3..<30, id: \.self) { index in
        AMDBeverageListView.medium(
          thumbnailURL: "https://picsum.photos/200/300?random=\(index)",
          brandTitle: "Brand \(index + 1)",
          beverageSize: "Tall",
          beverageTitle: "Medium Beverage \(index + 1)",
          glucose: Double(30 + index * 15),
          kcal: Double(80 + index * 30),
          sugarFreeVariant: index % 3 == 0 ? nil : (index % 3 == 1 ? .zero : .low),
          menuAction: {
            print("Menu tapped for medium item \(index)")
          }
        )
        .padding(.horizontal, 20)
      }
    }
    .padding(.vertical, 8)
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
