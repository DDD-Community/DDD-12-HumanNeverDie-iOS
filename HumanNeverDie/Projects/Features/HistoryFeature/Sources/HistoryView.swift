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
            style: .history(drinkCount: 2, sugar: 50, baseSugar: 100)
          )
          addDrinkButton
        }
        .padding(.horizontal, 20)
        selectedDateBeverageSection
        
      }
    }
  }
  
  
  private var addDrinkButton: some View {
    Button(action: {
      router.push(to: .beverageRecordList)
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
  
  private var selectedDateBeverageSection: some View {
    VStack(alignment: .leading, spacing: 0) {
      LazyVStack(spacing: 20) {
        ForEach(viewModel.frequentBeverageList, id: \.productID) { beverage in
          AMDBeverageListView.medium(
            thumbnailURL: beverage.thumbnailURL,
            brandTitle: beverage.brandName,
            beverageSize: "Tall", // 필요하다면 beverage.size로 교체 가능
            beverageTitle: beverage.name,
            glucose: Double(beverage.sugar),
            kcal: Double(beverage.kcal),
            sugarFreeVariant: beverage.sugarFreeType?.sugarFreeVariant,
            menuAction: {
              viewModel.handleAction(.beverageListInfoTapped(beverage.productID))
            }
          )
          .padding(.horizontal, 20)
        }
      }
      .padding(.vertical, 8)
    }
  }
}
