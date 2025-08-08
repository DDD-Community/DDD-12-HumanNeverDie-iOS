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
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
  }
}

extension HistoryView {
  
  private func contentCalenderView() -> some View {
    AMDCalendarFactory.createMonth(
      currentDate: viewModel.currentDate,
      sugarIntakeRecordData: viewModel.sugarIntakeRecordData,
      userSugarTargetValue: 50,
      selectedDate: $viewModel.state.selectedDate,
      onTapTitle: {
        popUpDate = viewModel.selectedDate ?? Date()
        viewModel.handleAction(.updateisMonthPickerPresented(true))
      },
      onMonthChanged: { newDate in
        viewModel.handleAction(.updateCurrentDate(newDate))
      }
    )
    .onChange(of: viewModel.currentDate) { _, newDate in
      if (!viewModel.isMonthPickerPresented) {
        viewModel.handleAction(.loadHistorDailyList)
      }
    }
    .onChange(of: viewModel.selectedDate) { _, selectedDate in
      if (!viewModel.isMonthPickerPresented) {
        viewModel.handleAction(.loadHistoryForSelectedDate)
      }
    }
    .amdBottomSheet(isPresented: .constant(viewModel.isMonthPickerPresented), detents: [.height(310)]) {
      AMDDatePickerView(
        title: "날짜 선택",
        isResetButtonHidden: false,
        type: .yearMonthDay) {
          
          viewModel.handleAction(.applySelectedDate($0))
        }
    }
  }
  
  private func contentSugerStatusView() -> some View {
    AMDSugarStatusView(
      variant: .healthy,
      style: .history(drinkCount:viewModel.totalCount , sugar: viewModel.totalSugarGrams, baseSugar: 50)
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
        // 변수로 한 번 받아서 사용
        let historyList = viewModel.selectedDateHistoryList
        
        ForEach(historyList, id: \.intakeHistoryId) { data in
          let sugarFreeVariant = AMDSugarFreeVariant.from(data.sugarLevel) ?? .none
          let beverageIdString = String(data.beverageId)
          
          AMDBeverageListView.medium(
            thumbnailURL: data.imgUrl,
            brandTitle: data.cafeBrand,
            beverageSize: data.beverageSize,
            beverageTitle: data.beverageName,
            glucose: Double(data.sugarG),
            kcal: Double(data.servingKcal),
            sugarFreeVariant: sugarFreeVariant,
            menuAction: {
              viewModel.handleAction(.updateSelectedBeverageID(beverageIdString))
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
                  viewModel.handleAction(.updateSelectedBeverageID(beverageIdString))
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
    if viewModel.selectedBeverageID != "" {
      Color.black.opacity(0.001)
        .ignoresSafeArea()
        .onTapGesture {
          viewModel.handleAction(.updateSelectedBeverageID(""))
        }
        .zIndex(0)
    }
  }
  
  @ViewBuilder
  private func popupMenuDailylList() -> some View {
    popupBackgroundOverlay()
    
    if let popupPosition, viewModel.selectedBeverageID != "" {
      VStack(spacing: 0) {
        Button {
          viewModel.handleAction(.beverageListInfoTapped)
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
          viewModel.handleAction(.updateSelectedBeverageID(""))
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

