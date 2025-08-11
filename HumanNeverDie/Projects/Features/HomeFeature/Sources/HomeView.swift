//
// HomeView.swift
// Home
//
// Created by 김규철 on 2025.
//

import SwiftUI

import CommonFeature
import DesignSystem

public struct HomeView: View {
  @State private var viewModel: HomeViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: HomeViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    contentView
      .background(.white)
      .amdBottomSheet(
        isPresented: $viewModel.state.isMonthPickerPresented,
        detents: [.height(310)]
      ) {
        datePickerBottomSheet
      }
      .onAppear {
        viewModel.handleAction(.onAppear)
      }
  }
  
  private var contentView: some View {
    VStack(spacing: 0) {
      weeklyCalendarView
      Spacer()
      sugarStatusCard
      Spacer()
      beverageRecordButton
      Spacer(minLength: 35)
    }
  }
  
  private var weeklyCalendarView: some View {
    AMDCalendarFactory.createWeekly(
      currentDate: viewModel.currentDate,
      sugarIntakeRecordData: viewModel.sugarIntakeRecords,
      userSugarTargetValue: 50,
      selectedDate: $viewModel.state.selectedDate,
      onTapTitle: { viewModel.handleAction(.calendarChangeDateButtonTapped) },
      onWeekChanged: { viewModel.handleAction(.weekSlideGesture($0)) }
    )
    .onChange(of: viewModel.state.selectedDate) { _, selectedDate in
      viewModel.handleAction(.updateSelectedDate(selectedDate))
    }
  }
  
  private var sugarStatusCard: some View {
    AMDCard(
      totalSugar: viewModel.selectedDateCalendar?.totalSugarGrams ?? 0,
      baseSugar: viewModel.baseSugar,
      variant: viewModel.sugarStatus.statusVariant
    )
    .amdFlipCard(backView: Spacer())
    .padding(.horizontal, 40)
  }
  
  private var beverageRecordButton: some View {
    AMDFloatingButton(
      title: "음료 기록하기",
      action: { router.push(to: .beverageRecordList(recordDate: viewModel.selectedDate ?? Date())) }
    )
  }
  
  private var datePickerBottomSheet: some View {
    AMDDatePickerView(
      isResetButtonHidden: false,
      type: .yearMonthDay
    ) {
      viewModel.handleAction(.datePickerConfirmed($0))
    }
  }
}
