//
//  BeverageListViewModel.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/11/25.
//

import Foundation
import Observation

import CommonFeature
import BeverageDomain

import Dependencies

@Observable
@MainActor
public final class BeverageListViewModel: ViewModelable {
  struct BeverageFilterCount: Equatable {
    var total: Int
    var zero: Int
    var low: Int
    var like: Int
    
    func toValue(_ type: BeverageFilterType) -> Int {
      switch type {
      case .all:
        return total
      case .zero:
        return zero
      case .low:
        return low
      case .like:
        return like
      }
    }
  }
  
  public struct State: Equatable {
    var beverageList: [Beverage] = []
    var cursor: String?
    var hasNext: Bool = false
    
    var filterType: BeverageFilterType = .all
    var filterCount: BeverageFilterCount = .init(total: 0, zero: 0, low: 0, like: 0)

    var beverageProductID: String = ""
    var isBevarageDetailPresented: Bool = false
    
    var isLoading: Bool = false
  }
  
  public enum Action {
    case beverageFilterChipItemTapped(BeverageFilterType)
    case loadNextBeverageList([Beverage.ID])
    case beverageListFavoriteTapped(Int, Beverage)
    case beverageListInfoTapped(String)
    case beverageListItemTapped(Beverage)
    case addBeverageButtonTapped
    case recentSearchListButtonTapped(String)
  }
  
  public enum DelegateAction: Equatable {
    case beverageListItemTapped(Beverage)
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  @Dependency(\.beverageLocalLikeUseCase) private var beverageLocalLikeUseCase
  
  var delegateAction: ((DelegateAction?) -> Void)?
  public var state: State = .init()
  init() {
  }
  
  deinit {
    print("deinit BeverageListViewModel")
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case let .beverageFilterChipItemTapped(filterType):
      state.filterType = filterType
      
    case let .loadNextBeverageList(beverageIDList):
      if let lastId = beverageIDList.last {
        Task { await getBeverageList(lastId) }
      }
      
    case let .beverageListFavoriteTapped(index, beverage):
      let originalIsLiked = beverage.isLiked
      let newLikedState = !beverage.isLiked
      state.beverageList[index].isLiked = newLikedState
      state.filterCount.like = newLikedState ? state.filterCount.like + 1 : state.filterCount.like - 1
      
      handleBeverageLike(beverage, newIsLiked: newLikedState, originalIsLiked: originalIsLiked)
      
    case let .beverageListInfoTapped(productID):
      state.beverageProductID = productID
      state.isBevarageDetailPresented = true
      
    case let .beverageListItemTapped(item):
      delegateAction?(.beverageListItemTapped(item))
      
    case .addBeverageButtonTapped:
      break
      
    case .recentSearchListButtonTapped(_):
      break
    }
  }
  
  private func getBeverageList(_ lastId: String) async {
    do {
      guard
        let cursor = state.cursor,
        state.hasNext,
        !state.isLoading,
        state.beverageList.contains(where: { $0.id == lastId }),
        lastId == state.beverageList.last?.id else {
        return
      }
      
      state.isLoading = true
      
      let beverageList = try await beverageUseCase.getBeverageList(cursor: cursor)
      
      await MainActor.run {
        state.beverageList.append(contentsOf: beverageList.items)
        state.cursor = beverageList.nextCursor
        state.hasNext = beverageList.hasNext
        state.isLoading = false
      }
    } catch {
      print(error)
      state.isLoading = false
    }
  }
  
  private func handleBeverageLike(_ beverage: Beverage, newIsLiked: Bool, originalIsLiked: Bool) {
    do {
      var updatedBeverage = beverage
      updatedBeverage.isLiked = newIsLiked
      
      try beverageLocalLikeUseCase.handleBeverageLike(
        beverage: updatedBeverage,
        originalIsLiked: originalIsLiked
      )
    } catch {
      print("로컬 좋아요 저장 실패: \(error)")
    }
  }
}
