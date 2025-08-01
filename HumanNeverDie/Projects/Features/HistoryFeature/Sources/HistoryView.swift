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
  @State private var popupPosition: CGPoint? = nil
  
  public init(viewModel: HistoryViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ZStack(alignment: .top) {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 0) {
          AMDCalendarFactory.createMonth(
            currentDate: viewModel.currentDate,
            sugarIntakeRecordData: viewModel.state.sugarIntakeRecordData,
            userSugarTargetValue: 50,
            selectedDate: $viewModel.state.selectedDate,
            onTapTitle: {
              tempDate = viewModel.selectedDate ?? Date()
              isMonthPickerPresented = true
            },onMonthChanged: { newDate in
              viewModel.state.currentDate = newDate
            }
          )
          .onChange(of: viewModel.state.currentDate) { _, newDate in
            viewModel.handleAction(.incrementCounterAsync)
          }
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
                viewModel.state.currentDate = tempDate
                viewModel.state.selectedDate = tempDate
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
      
      popupBackgroundOverlay()
      popupMenu()
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
        ForEach(viewModel.state.frequentBeverageList, id: \.productID) { beverage in
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
          .background(
            GeometryReader { geo in
              Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                  let frame = geo.frame(in: .global)
                  self.popupPosition = CGPoint(x: frame.maxX - 100, y: frame.midY - 60)
                  viewModel.state.selectedBeverageID = beverage.productID
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
  private func popupMenu() -> some View {
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
