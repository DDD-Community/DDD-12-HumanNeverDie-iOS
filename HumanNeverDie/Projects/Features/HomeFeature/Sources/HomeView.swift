//
// HomeView.swift
// Home
//
// Created by 김규철 on 2025.
//

import SwiftUI

import CommonFeature
import DesignSystem

import Dependencies

public struct HomeView: View {
  @State private var viewModel: HomeViewModel
  @Environment(Router.self) private var router
  @Dependency(\.globalState) private var globalState
  
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
      .onViewDidLoad {
        viewModel.handleAction(.onViewDidLoad)
      }
      .onAppear {
        Task {
          for await event in globalState.eventStream {
            switch event {
            case .homeRefresh:
              viewModel.handleAction(.homeRefresh)
            }
          }
        }
      }
  }
  
  private var contentView: some View {
    VStack(spacing: 0) {
      weeklyCalendarView
      Spacer()
      cardView
      Spacer()
      Spacer()
      beverageRecordButton
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
  
  private var cardView: some View {
    ZStack {
      emptyView
        .opacity(viewModel.isSelectedDateEmpty ? 1.0 : 0.0)
        .scaleEffect(viewModel.isSelectedDateEmpty ? 1.0 : 0.8)
      
      sugarStatusCard
        .opacity(viewModel.isSelectedDateEmpty ? 0.0 : 1.0)
        .scaleEffect(viewModel.isSelectedDateEmpty ? 0.8 : 1.0)
    }
    .animation(.easeInOut(duration: 0.3), value: viewModel.isSelectedDateEmpty)
  }
    
  private var sugarStatusCard: some View {
    AMDCard(
      totalSugar: viewModel.selectedDateCalendar?.totalSugarGrams ?? 0,
      baseSugar: viewModel.baseSugar,
      variant: viewModel.sugarStatus.statusVariant
    )
    .amdFlipCard(
      backView: HomeCardBeverageListView(beverageCalendar: viewModel.selectedDateCalendar),
      resetTrigger: viewModel.state.selectedDate
    )
    .padding(.horizontal, 40)
  }
  
  private var emptyView: some View {
    HomeCardEmptyView()
  }
  
  private var beverageRecordButton: some View {
    AMDFloatingButton(
      title: "음료 기록하기",
      action: { router.push(to: .beverageRecordList(recordDate: viewModel.selectedDate ?? Date())) }
    )
    .padding(.bottom, 20)
    .opacity(viewModel.state.isTodayOrPastSelectedDate ? 1 : 0)
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
