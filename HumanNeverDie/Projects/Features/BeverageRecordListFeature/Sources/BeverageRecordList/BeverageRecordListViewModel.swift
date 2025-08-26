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
  }

  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  @Dependency(\.userDefaultClient) private var userDefaultClient
  
  @ObservationIgnored
  var listViewModel: BeverageListViewModel = .init()

  public var state: State
  public init(beverageRecordDate: Date) {
    self.state = .init(beverageRecordDate: beverageRecordDate)
    delegate()
    
    Task {
      await getBeverage()
      await getUserSugar()
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
      syncBeverageLikeStatusFromGlobalEvent(productID: productID, isLiked: isLiked)
    }
  }


  private func syncBeverageLikeStatusFromGlobalEvent(productID: String, isLiked: Bool) {
    guard let update = beverageUseCase.getBeverageLikeUpdate(
      from: listViewModel.state.beverageList,
      productID: productID,
      newLikeStatus: isLiked
    ) else { return }
    
    listViewModel.state.beverageList[update.beverageIndex].isLiked = isLiked
    listViewModel.state.filterCount.like += update.likeCountChange
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
}

private extension BeverageRecordListViewModel {
  func delegate() {
    listViewModel.delegateAction = { [weak self] action in
      self?.handleAction(.delegateAction(action))
    }
  }
}
