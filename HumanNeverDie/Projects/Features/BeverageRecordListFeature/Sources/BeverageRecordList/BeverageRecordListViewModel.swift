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
    
    var sugarLevelType: BeverageSugarLevelType?
    var isOnlyLiked: Bool = false
    
    var route: Route?
  }

  public enum Action {
    case onAppear
    case delegateAction(BeverageListViewModel.DelegateAction?)
    case clearRoute
  }

  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase

  @ObservationIgnored
  var listViewModel: BeverageListViewModel = .init()

  public var state: State
  public init(beverageRecordDate: Date) {
    self.state = .init(beverageRecordDate: beverageRecordDate)
    delegate()
    Task { await self.getBeverage() }
  }

  deinit {
    print("deinit BeverageRecordListViewModel")
  }

  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      Task { await syncBeverageLike() }

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
    }
  }

  private func syncBeverageLike() async {
    do {
      let (syncedBeverages, localLikeCount) = try beverageUseCase.syncBeverageLike(beverages: listViewModel.state.beverageList)

      await MainActor.run {
        listViewModel.state.beverageList = syncedBeverages
        listViewModel.state.filterCount.like += localLikeCount
      }
    } catch {
      print("로컬 좋아요 동기화 실패: \(error)")
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
