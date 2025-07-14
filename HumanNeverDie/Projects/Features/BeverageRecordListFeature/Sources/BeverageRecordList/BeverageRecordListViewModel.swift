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
  }
  
  public enum Action {
    case onViewDidLoad
    case beverageListItemTapped(Beverage)
    case delegateAction(BeverageListViewModel.DelegateAction?)
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  var listViewModel: BeverageListViewModel = .init()
  
  public var state: State = .init()
  public init() {
    delegateTracking()
  }
  
  deinit {
    print("deinit BeverageRecordListViewModel")
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onViewDidLoad:
      Task { await self.getBeverage() }
      
    case let .beverageListItemTapped(beverage):
      print(beverage)
      
    case let .delegateAction(action):
      switch action {
      case let .beverageListItemTapped(beverage):
        print(beverage)
        
      case nil:
        break
      }
    }
  }
  
  
  private func getBeverage() async {
    do {
      async let beverageListResponse = try beverageUseCase.getBeverageList(cursor: nil)
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
  func delegateTracking() {
    Task { @MainActor [weak self] in
      await self?.withObservationTracking(
        tracking: { [weak self] in
          _ = self?.listViewModel.delegateAction
        },
        didChange: { [weak self] in
          let action = self?.listViewModel.delegateAction
          self?.handleAction(.delegateAction(action))
        }
      )
    }
  }
}
