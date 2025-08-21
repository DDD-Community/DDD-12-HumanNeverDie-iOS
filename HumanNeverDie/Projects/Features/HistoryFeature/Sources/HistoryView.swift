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
  
  public init(viewModel: HistoryViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ZStack(alignment: .top) {
      ScrollView(.vertical, showsIndicators: false) {
        ZStack {
          popupBackgroundOverlay()
          
          VStack(spacing: 0) {
            contentCalenderView()
            
            Rectangle()
              .fill(.gray10)
              .frame(height: 8)
            
            VStack(alignment: .leading, spacing: 0) {
              selectDateTitle()
              contentSugerStatusView()
              contentDrinkButton
            }.padding(.horizontal, 20)
            
            selectedHistoryDailylList
          }
        }
      }
      .amdBottomSheet(isPresented: $viewModel.state.isBevarageDetailPresented, detents: [.height(474)]) {
        AMDBeverageDetailView(productID: viewModel.selectedProductID)
      }
      .onChange(of: viewModel.state.isBevarageDetailPresented) { _, isPresented in
        if !isPresented {
          viewModel.handleAction(.clearSelectedBeverage)
        }
      }
      .amdBottomSheet(isPresented: $viewModel.state.isMonthPickerPresented, detents: [.height(310)]) {
        AMDDatePickerView(
          title: "날짜 선택",
          isResetButtonHidden: false,
          type: .yearMonthDay) {
            viewModel.handleAction(.applySelectedDate($0))
          }
      }
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
  }
}

extension HistoryView {
  
  private func selectDateTitle() -> some View {
    Text(viewModel.getSelectedDateString())
      .amdFont(.smallRegular)
      .foregroundStyle(.gray60)
      .padding(.top, 8)
  }
  
  private func contentCalenderView() -> some View {
    AMDCalendarFactory.createMonth(
      currentDate: viewModel.currentDate,
      sugarIntakeRecordData: viewModel.sugarIntakeRecordData,
      userSugarTargetValue: $viewModel.state.baseSugar,
      selectedDate: $viewModel.state.selectedDate,
      onTapTitle: {
        viewModel.handleAction(.updateisMonthPickerPresented(true))
      },
      onMonthChanged: { newDate in
        viewModel.handleAction(.updateCurrentDate(newDate))
      }
    )
    .onChange(of: viewModel.currentDate) { _, newDate in
      reloadDataIfNeeded(.loadHistorDailyList)
    }
    .onChange(of: viewModel.selectedDate) { _, selectedDate in
      reloadDataIfNeeded(.loadHistoryForSelectedDate)
    }
  }
  
  private func contentSugerStatusView() -> some View {
    AMDSugarStatusView(
      variant: viewModel.sugarStatus.statusVariant,
      style: .history(drinkCount:viewModel.totalCount , sugar: viewModel.totalSugarGrams, baseSugar: viewModel.baseSugar)
    )
  }
  
  private var contentDrinkButton: some View {
    Button(action: {
      router.push(to: .beverageRecordList(recordDate: viewModel.selectedDate ?? Date()))
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
    .opacity(viewModel.state.isTodayOrPastSelectedDate ? 1 : 0)
    .padding(.vertical, 10)
  }
  
  private var selectedHistoryDailylList: some View {
    VStack(alignment: .leading, spacing: 0) {
      LazyVStack(spacing: 10) {
        
        let historyList = viewModel.selectedDateHistoryList
        
        ForEach(historyList, id: \.intakeHistoryId) { data in
          let sugarFreeVariant = AMDSugarFreeVariant.from(data.sugarLevel) ?? .none
          let uniqueIdString = String(data.intakeHistoryId)
          let productIdString = String(data.productId)
          
          AMDBeverageListView.medium(
            thumbnailURL: data.imgUrl,
            brandTitle: data.cafeBrand,
            beverageSize: data.beverageSize,
            beverageTitle: data.beverageName,
            glucose: Double(data.sugarG),
            kcal: Double(data.servingKcal),
            sugarFreeVariant: sugarFreeVariant,
            menuAction: {
              viewModel.handleAction(.updateSelectedProductID(
                uniqueIdString,
                productIdString
              ))
            }
          )
          .padding(.horizontal, 20)
          .overlay(
            Group {
              if viewModel.state.selectedIntakeHistoryID == uniqueIdString {
                HStack {
                  Spacer()
                  popupMenuDailylList()
                    .offset(x: -30, y: 0)
                }
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
    if viewModel.isListPopupPresented {
      Color.black.opacity(0.001)
        .ignoresSafeArea()
        .onTapGesture {
          viewModel.handleAction(.clearSelectedBeverage)
        }
        .zIndex(-1)
    }
  }
  
  @ViewBuilder
  private func popupMenuDailylList() -> some View {
    if viewModel.isListPopupPresented {
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
          print("updateSelectedBeverageID")
          viewModel.handleAction(.deleteSelectedBeverage)
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
      .zIndex(1)
    }
  }
  
  private func reloadDataIfNeeded(_ action: HistoryViewModel.Action) {
    if !viewModel.isMonthPickerPresented {
      viewModel.handleAction(action)
    }
  }
}

