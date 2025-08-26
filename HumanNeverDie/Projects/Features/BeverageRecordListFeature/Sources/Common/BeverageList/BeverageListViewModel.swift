//
//  BeverageListViewModel.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/11/25.
//

import Foundation
import Observation

import DesignSystem
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

    var sugarLevelType: BeverageSugarLevelType?
    var isOnlyLiked: Bool = false
    var cursor: String?
    var hasNext: Bool = false

    var filterType: BeverageFilterType = .all
    var filterCount: BeverageFilterCount = .init(total: 0, zero: 0, low: 0, like: 0)

    var beverageProductID: String = ""
    var isBeverageDetailPresented: Bool = false

    var isLoading: Bool = false
    var isFilteringInProgress: Bool = false
  }

  public enum Action {
    case filterinfoViewTapped
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
    case beverageFilterItemTapped(BeverageSugarLevelType?, Bool)
  }

  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase

  @ObservationIgnored
  @Dependency(\.beverageLocalLikeUseCase) private var beverageLocalLikeUseCase
  
  @ObservationIgnored
  @Dependency(\.alertClient) private var alertClient
  
  @ObservationIgnored
  @Dependency(\.globalState) private var globalState

  var delegateAction: ((DelegateAction?) -> Void)?
  public var state: State = .init()
  init() {}

  deinit {
    print("deinit BeverageListViewModel")
  }

  public func handleAction(_ action: Action) {
    switch action {
    case .filterinfoViewTapped:
      let alertProperty = AMDAlertProperty(
        title: "저당/무당 기준이 어떻게 되나요?",
        message: """
                 무당
                 - 0g (제조 과정에서 당류를 첨가하지 않음)
                 - 예: 아메리카노, 에스프레소 
                 
                 저당 
                 - 액체: 100ml당 2.5g 이하
                 - 예: 스타벅스 톨(355ml) × 2.5g = 약 8.9g 이하의 음료 모두 해당
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
      
    case let .beverageFilterChipItemTapped(filterType):
      state.isFilteringInProgress = true
      state.filterType = filterType
      state.cursor = nil
      
      switch state.filterType {
      case .all:
        state.sugarLevelType = nil
        state.isOnlyLiked = false

      case .zero:
        state.sugarLevelType = .zero
        state.isOnlyLiked = false

      case .low:
        state.sugarLevelType = .low
        state.isOnlyLiked = false

      case .like:
        state.sugarLevelType = nil
        state.isOnlyLiked = true
      }

      Task {
        delegateAction?(.beverageFilterItemTapped(state.sugarLevelType, state.isOnlyLiked))
        await MainActor.run {
          state.isFilteringInProgress = false
        }
      }
    case let .loadNextBeverageList(beverageIDList):
      guard !state.isLoading,
            let lastId = beverageIDList.last else { return }
      Task { await getBeverageList(lastId) }

    case let .beverageListFavoriteTapped(index, beverage):
      let originalIsLiked = beverage.isLiked
      let newLikedState = !beverage.isLiked
      
      if state.isOnlyLiked && !newLikedState {
        state.beverageList.remove(at: index)
      } else {
        state.beverageList[index].isLiked = newLikedState
      }
      
      state.filterCount.like = newLikedState ? state.filterCount.like + 1 : state.filterCount.like - 1

      Task {
        await handleBeverageLike(beverage, newIsLiked: newLikedState, originalIsLiked: originalIsLiked)
      }

    case let .beverageListInfoTapped(productID):
      state.beverageProductID = productID
      state.isBeverageDetailPresented = true

    case let .beverageListItemTapped(item):
      delegateAction?(.beverageListItemTapped(item))

    case .addBeverageButtonTapped:
      break

    case .recentSearchListButtonTapped(_):
      break
    }
  }

  private func getBeverageList(_ lastId: String? = nil) async {
    let isInitialLoad = lastId == nil

    do {
      if !isInitialLoad {
        guard
          state.cursor != nil,
          state.hasNext,
          !state.isLoading,
          state.beverageList.contains(where: { $0.id == lastId }),
          lastId == state.beverageList.last?.id else {
          return
        }
      }

      state.isLoading = true

      let cursor = isInitialLoad ? nil : state.cursor
      let beverageList = try await beverageUseCase.getBeverageList(cursor: cursor, sugarLevel: state.sugarLevelType, onlyLiked: state.isOnlyLiked)
      
      await MainActor.run {
        if isInitialLoad {
          state.beverageList = beverageList.items
        } else {
          state.beverageList.append(contentsOf: beverageList.items)
        }

        state.filterCount.like = beverageList.likeCount
        state.cursor = beverageList.items.isEmpty ? nil : beverageList.nextCursor
        state.hasNext = beverageList.items.isEmpty ? false : beverageList.hasNext
        state.isLoading = false
      }
    } catch {
      await MainActor.run {
        state.isLoading = false
      }
    }
  }

  private func handleBeverageLike(_ beverage: Beverage, newIsLiked: Bool, originalIsLiked: Bool) async {
    do {
      if newIsLiked {
        _ = try await beverageUseCase.likeBeverage(productID: beverage.productID)
      } else {
        _ = try await beverageUseCase.unLikeBeverage(productID: beverage.productID)
      }
      
      await MainActor.run {
        globalState.beverageLikeUpdatePublisher.send((productID: beverage.productID, isLiked: newIsLiked))
      }
    } catch {
      saveToLocalStorage(beverage, newIsLiked: newIsLiked, originalIsLiked: originalIsLiked)
    }
  }
  
  private func saveToLocalStorage(_ beverage: Beverage, newIsLiked: Bool, originalIsLiked: Bool) {
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
