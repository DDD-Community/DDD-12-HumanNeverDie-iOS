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
  @State private var popUpDate = Date()
  @State private var popupPosition: CGPoint? = nil
  @State private var isMonthPickerPresented = false
  
  public init(viewModel: HistoryViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ZStack(alignment: .top) {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 0) {
          contentCalenderView()
          
          Rectangle()
            .fill(.gray10)
            .frame(height: 8)
          
          VStack(alignment: .leading, spacing: 0) {
            contentSugerStatusView()
            contentDrinkButton
          }.padding(.horizontal, 20)
          
          selectedHistoryDailylList
        }
      }
      
      popupMenuDailylList()
    }
  }
}

extension HistoryView {
  
  private func contentCalenderView() -> some View {
    AMDCalendarFactory.createMonth(
      currentDate: viewModel.currentDate,
      sugarIntakeRecordData: viewModel.state.sugarIntakeRecordData,
      userSugarTargetValue: 50,
      selectedDate: $viewModel.state.selectedDate,
      onTapTitle: {
        popUpDate = viewModel.state.selectedDate ?? Date()
        isMonthPickerPresented = true
      },
      onMonthChanged: { newDate in
        viewModel.state.currentDate = newDate
      }
    )
    .onChange(of: viewModel.state.currentDate) { _, newDate in
      if (isMonthPickerPresented) {
        viewModel.handleAction(.loadHistorDailyList)
      }
    }
    .onChange(of: viewModel.state.selectedDate) { _, selectedDate in
      if (isMonthPickerPresented) {
        viewModel.handleAction(.loadHistoryForSelectedDate)
      }
    }
    .amdDatePickerBottomSheet(
      pickerTitle: "날짜 선택",
      isResetButtonHidden: false,
      isPresented: $isMonthPickerPresented,
      selectedDate: $popUpDate,
      onConfirm: { date in
        viewModel.state.currentDate = date
        viewModel.state.selectedDate = date
        
        viewModel.handleAction(.datePickeronConfirm)
      }
    )
  }
  
  private func contentSugerStatusView() -> some View {
    AMDSugarStatusView(
      variant: .healthy,
      style: .history(drinkCount:viewModel.state.totalCount , sugar: viewModel.state.totalSugarGrams, baseSugar: 50)
    )
  }
  
  private var contentDrinkButton: some View {
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
    .padding(.vertical, 10)
  }
  
  private var selectedHistoryDailylList: some View {
    
    VStack(alignment: .leading, spacing: 0) {
      LazyVStack(spacing: 20) {
        ForEach(viewModel.state.selectedDateHistoryList, id: \.beverageId) { data in
          
          let sugarFreeVariant = AMDSugarFreeVariant.from(data.sugarLevel) ?? .none
          let beverageIdString = String(data.beverageId)
          
          AMDBeverageListView.medium(
            thumbnailURL: "",//thumbnailURL,
            brandTitle: data.cafeBrand,
            beverageSize: "Tall", // 사이즈관련 데이터 없음
            beverageTitle: data.beverageName,
            glucose: Double(data.sugarG),
            kcal: Double(data.servingKcal),
            sugarFreeVariant: sugarFreeVariant,
            menuAction: {
              viewModel.handleAction(.beverageListInfoTapped(beverageIdString))
            }
          )
          .padding(.horizontal, 20)
          .background(
            GeometryReader { geo in
              Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                  let frame = geo.frame(in: .global)
                  self.popupPosition = CGPoint(x: frame.maxX - 100, y: frame.midY - 60)
                  viewModel.state.selectedBeverageID = beverageIdString
                }
            }
          )
        }
      }
      .padding(.vertical, 8)
    }
  }
  
  @ViewBuilder
  private func popupBackgroundOverlay() -> some View {
    if viewModel.state.selectedBeverageID != nil {
      Color.black.opacity(0.001)
        .ignoresSafeArea()
        .onTapGesture {
          viewModel.state.selectedBeverageID  = nil
        }
        .zIndex(0)
    }
  }
  
  @ViewBuilder
  private func popupMenuDailylList() -> some View {
    popupBackgroundOverlay()
    
    if let popupPosition, let productID = viewModel.state.selectedBeverageID {
      VStack(spacing: 0) {
        Button {
          viewModel.handleAction(.beverageListInfoTapped(productID))
          viewModel.state.selectedBeverageID  = nil
        } label: {
          HStack(spacing: 8) {
            Image(systemName: "info.circle")
              .foregroundStyle(.gray80)
              .amdFont(.mediumMedium)
            Text("영양정보")
              .foregroundStyle(.gray80)
              .amdFont(.mediumMedium)
          }
          .padding(.vertical, 13)
          .padding(.horizontal, 20)
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        Divider()
        
        Button {
          viewModel.state.selectedBeverageID = nil
        } label: {
          HStack(spacing: 8) {
            Image(systemName: "trash")
              .foregroundStyle(.danger)
              .amdFont(.mediumMedium)
            Text("기록 삭제")
              .foregroundStyle(.danger)
              .amdFont(.mediumMedium)
          }
          .padding(.vertical, 13)
          .padding(.horizontal, 20)
          .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      .frame(width: 130)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .shadow(radius: 4)
      .position(x: popupPosition.x, y: popupPosition.y)
      .zIndex(1)
    }
  }
}
