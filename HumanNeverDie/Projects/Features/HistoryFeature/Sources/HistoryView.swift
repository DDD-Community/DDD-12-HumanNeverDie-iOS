//
// HistoryView.swift
// History
//
// Created by 김규철 on 2025.
//

import SwiftUI
import DesignSystem
import CommonFeature

private enum Constants {
  static let sugarProgressViewHeight: CGFloat = 110
}

private var sugarProgressView: some View {
  AMDSugarStatusView(
    variant: .healthy,
    sugar: 50,
    baseSugar: 100,
    drinkCount: 2
  )
  .frame(minHeight: Constants.sugarProgressViewHeight, maxHeight: Constants.sugarProgressViewHeight, alignment: .top)
}

public struct HistoryView: View {
  @State private var viewModel: HistoryViewModel
  @State private var isMonthPickerPresented = false
  @State private var tempDate = Date()
  
  public init(viewModel: HistoryViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    VStack(spacing: 20) {
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
      
      VStack(alignment: .leading, spacing: 0) {
        sugarProgressView
        addDrinkButton
        mediumSampleSection
      }
      
    }
  }
  
  private var addDrinkButton: some View {
    Button(action: {
      print("음료 추가하기 눌림")
    }) {
      HStack(spacing: 8) {
        Image(systemName: "plus.circle")
          .font(.system(size: 16))
        Text("음료 추가하기")
          .amdFont(.mediumMedium)
      }
      .foregroundStyle(.gray60)
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
          .foregroundColor(Color.gray40)
      )
    }
    .padding(.horizontal, 20)
  }
  
  private var mediumSampleSection: some View {
    VStack(alignment: .leading, spacing: 0) {
      ScrollView(.vertical, showsIndicators: true) {
        LazyVStack(spacing: 20) {
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
      .frame(maxHeight: 300)
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
