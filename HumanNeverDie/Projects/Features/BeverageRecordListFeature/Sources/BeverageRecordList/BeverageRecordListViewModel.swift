//
// BeverageRecordListViewModel.swift
// BeverageRecordList
//
// Created by 김규철 on 2025.
//

import Foundation
import Observation

import CommonFeature
import BeverageDomain
import DesignSystem
import Shared

import Dependencies

@Observable
@MainActor
public final class BeverageRecordListViewModel: ViewModelable {
  public struct State: Equatable {
    var beverageRecordDate: Date
    
    var baseSugar: Int = 0
    var totalSugar: Int = 0
    
    var sugarLevelType: BeverageSugarLevelType?
    var isOnlyLiked: Bool = false
    
    var route: Route?
  }
  
  public enum Action {
    case onAppear
    case delegateAction(BeverageListViewModel.DelegateAction?)
    case clearRoute
    case beverageLikeStatusChanged(productID: String, isLiked: Bool)
    case filterinfoViewTapped
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  @Dependency(\.userDefaultClient) private var userDefaultClient
  
  @ObservationIgnored
  @Dependency(\.alertClient) private var alertClient
  
  @ObservationIgnored
  var listViewModel: BeverageListViewModel = .init()
  
  public var state: State
  public init(beverageRecordDate: Date) {
    self.state = .init(beverageRecordDate: beverageRecordDate)
    delegate()
    
    Task {
      await getBeverage()
      await getUserSugar()
      await checkFirstBeverageList()
    }
  }
  
  deinit {
    print("deinit BeverageRecordListViewModel")
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case let .delegateAction(action):
      switch action {
      case let .beverageListItemTapped(beverage):
        state.route = .beverageRecord(productID: beverage.productID, isLiked: beverage.isLiked, recordDate: state.beverageRecordDate)
        
      case let .beverageFilterItemTapped(sugarLevelType, isOnlyLiked):
        state.sugarLevelType = sugarLevelType
        state.isOnlyLiked = isOnlyLiked
        
        Task { await getBeverage() }
        
      case nil:
        break
      }
      
    case .clearRoute:
      state.route = nil
      
    case let .beverageLikeStatusChanged(productID, isLiked):
      updateBeverageLikeStatus(productID: productID, isLiked: isLiked)
      
    case .filterinfoViewTapped:
      Task { await showFilterInfoAlert() }
    }
  }
  
  private func getUserSugar() async {
    guard let baseSugar: Int = userDefaultClient.getValue(forKey: AMDUserDefaultKey.baseSugar),
          let totalSugar: Int = userDefaultClient.getValue(forKey: AMDUserDefaultKey.totalSugar) else {
      return
    }
    
    await MainActor.run {
      state.baseSugar = baseSugar
      state.totalSugar = totalSugar
    }
  }
  
  private func checkFirstBeverageList() async {
    guard let isFirstBeverageList: Bool = userDefaultClient.getValue(forKey: AMDUserDefaultKey.isFirstBeverageList),
          isFirstBeverageList else {
      return
    }
    
    await showFilterInfoAlert()
    await userDefaultClient.setValue(false, forKey: AMDUserDefaultKey.isFirstBeverageList)
  }
  
  private func getBeverage() async {
    do {
      let sugarLevelType = state.sugarLevelType
      let isOnlyLiked = state.isOnlyLiked
      async let beverageListResponse = try beverageUseCase.getBeverageList(cursor: nil, sugarLevel: sugarLevelType, onlyLiked: isOnlyLiked)
      async let beverageCountResponse = try beverageUseCase.getBeverageCount()
      
      let (beverageList, beverageCount) = try await (beverageListResponse, beverageCountResponse)
      
      await MainActor.run {
        listViewModel.state.beverageList = beverageList.items
        listViewModel.state.cursor = beverageList.nextCursor
        listViewModel.state.hasNext = beverageList.hasNext
        
        listViewModel.state.filterCount = .init(
          total: beverageCount.totalCount,
          zero: beverageCount.zeroCount,
          low: beverageCount.lowCount,
          like: beverageList.likeCount
        )
      }
    } catch {
      print(error)
    }
  }
  
  private func updateBeverageLikeStatus(productID: String, isLiked: Bool) {
    guard let update = beverageUseCase.getBeverageLikeUpdate(
      from: listViewModel.state.beverageList,
      productID: productID,
      newLikeStatus: isLiked
    ) else { return }
    
    listViewModel.state.beverageList[update.beverageIndex].isLiked = isLiked
    listViewModel.state.filterCount.like += update.likeCountChange
  }
}

private extension BeverageRecordListViewModel {
  func delegate() {
    listViewModel.delegateAction = { [weak self] action in
      self?.handleAction(.delegateAction(action))
    }
  }
}

private extension BeverageRecordListViewModel {
  private func showFilterInfoAlert() async {
    let alertProperty = AMDAlertProperty(
      title: "저당/무당 기준이 궁금하다면?",
      message: """
               저당 
               - 액체: 100ml당 2.5g 이하
               - 예: 스타벅스 톨(355ml) × 2.5g = 약 8.9g 이하의 음료 모두 해당
               
               무당 
               - 0g (제조 과정에서 당류를 첨가하지 않음)
               - 예: 아메리카노, 에스프레소 
               """,
      subMessage: "아맞당은 한국 식품의약품안전처 공식 당류 표기 기준\n(식품 등의 표시·광고에 관한 법률)을 준수하고 있어요.",
      primaryButton: .init(
        title: "닫기",
        type: .secondary,
        action: {}
      )
    )
    
    Task { @MainActor in
      await alertClient.showAlert(alertProperty)
    }
  }
}
