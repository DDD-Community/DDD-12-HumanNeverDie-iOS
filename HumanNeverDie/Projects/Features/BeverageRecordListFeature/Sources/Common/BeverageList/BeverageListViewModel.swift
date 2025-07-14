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
import SwiftUI

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
    
    // 서버에 동기화되지 않은 좋아요 변경사항 (productID: isFavorite)
    var pendingLikeChanges: [String: Bool] = [:]
    
    var beverageProductID: String = ""
    var isBevarageDetailPresented: Bool = false
    
    var isLoading: Bool = false
    
    var delegateAction: DelegateAction?
  }
  
  public enum Action {
    case onDisappear
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
  
  public var state: State = .init()
  init() {
  }
  
  deinit {
    print("deinit BeverageListViewModel")
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onDisappear:
      Task { await handleBeverageLike() }
      
    case let .beverageFilterChipItemTapped(filterType):
      state.filterType = filterType
      
    case let .loadNextBeverageList(beverageIDList):
      if let lastId = beverageIDList.last {
        Task { await getBeverageList(lastId) }
      }
      
    case let .beverageListFavoriteTapped(index, beverage):
      // 추후 검색 API -> 검색에 따른 검색 결과 리스트마다 아래 값 업데이트 해줘야 한다.
      state.beverageList[index].isLiked = !beverage.isLiked
      state.filterCount.like = !beverage.isLiked ? state.filterCount.like + 1 : state.filterCount.like - 1
      
      // 변경사항을 pendingChanges에 추가
      state.pendingLikeChanges[beverage.productID] = !beverage.isLiked
      
    case let .beverageListInfoTapped(productID):
      state.beverageProductID = productID
      state.isBevarageDetailPresented = true
      
    case let .beverageListItemTapped(item):
      state.delegateAction = .beverageListItemTapped(item)
      
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
  
  private func handleBeverageLike() async {
    guard !state.pendingLikeChanges.isEmpty else {
      return
    }
    
    await withTaskGroup(of: (String?).self) { group in
      for (productID, isFavorite) in state.pendingLikeChanges {
        group.addTask {
          do {
            if isFavorite {
              let likeBeverage = try await self.beverageUseCase.likeBeverage(productID: productID)
              return likeBeverage.productID
            } else {
              let unLikeBeverage = try await self.beverageUseCase.unLikeBeverage(productID: productID)
              return unLikeBeverage.productID
            }
          } catch {
            return nil
          }
        }
      }
      
      for await productID in group {
        if let productID {
          state.pendingLikeChanges.removeValue(forKey: productID)
        }
      }
    }
  }
}
