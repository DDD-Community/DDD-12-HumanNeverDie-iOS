//
//  BeverageSearchViewModel.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/10/25.
//

import Foundation
import Observation

import CommonFeature
import BeverageDomain
import Shared

import Dependencies

@Observable
@MainActor
public final class BeverageSearchViewModel: ViewModelable {
  public enum BeverageSearchType {
    case search
    case list
  }

  public struct State: Equatable {
    var searchText: String = ""
    var sugarLevelType: BeverageSugarLevelType?
    var isOnlyLiked: Bool = false
    
    var searchType: BeverageSearchType = .search
    var beverageRecordDate: Date

    var recentSearchList: [String] = []
    
    var baseSugar: Int = 0
    var totalSugar: Int = 0

    var route: Route?
  }

  @ObservationIgnored
  private var lastSearchedText: String = ""

  var isBeverageListEmpty: Bool {
    listViewModel.beverageList.isEmpty
  }

  public enum Action {
    case onAppear
    case searchTextChanged(String)
    case debounceSearchTextChanged(String)
    case recentSearchListItemTapped(String)
    case recentSearchListItemDeleteButtonTapped(String)
    case addBeverageButtonTapped
    case delegateAction(BeverageListViewModel.DelegateAction?)
    case clearRoute
    case beverageLikeStatusChanged(productID: String, isLiked: Bool)
  }

  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase

  @ObservationIgnored
  @Dependency(\.beverageLocalLikeUseCase) private var beverageLocalLikeUseCase

  @ObservationIgnored
  @Dependency(\.beverageLocalSearchUseCase) private var beverageLocalSearchUseCase

  @ObservationIgnored
  @Dependency(\.userDefaultClient) private var userDefaultClient

  @ObservationIgnored
  var listViewModel: BeverageListViewModel = .init()

  public var state: State
  public init(beverageRecordDate: Date) {
    self.state = .init(beverageRecordDate: beverageRecordDate)
    delegate()
    
    Task {
      await getUserSugar()
    }
  }

  deinit {
    print("deinit BeverageSearchViewModel")
  }

  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      state.recentSearchList = beverageLocalSearchUseCase.getRecentSearchList()

    case let .searchTextChanged(searchText):
      state.searchType = searchText.isEmpty ? .search : .list
      state.searchText = searchText
      state.sugarLevelType = nil
      state.isOnlyLiked = false

    case let .debounceSearchTextChanged(searchText):
      guard searchText != lastSearchedText,
            !searchText.isEmpty else {
        return
      }

      lastSearchedText = searchText

      Task {
        await searchBeverage(searchText)
        await saveRecentSearch(searchText)
      }

    case let .recentSearchListItemTapped(recentText):
      lastSearchedText = recentText
      state.searchText = recentText
      state.sugarLevelType = nil
      state.isOnlyLiked = false
      state.searchType = .list

      Task {
        await searchBeverage(recentText)
        await saveRecentSearch(recentText)
      }

    case let .recentSearchListItemDeleteButtonTapped(recentText):
      Task { await removeRecentSearch(recentText) }

    case .addBeverageButtonTapped:
      break

    case let .delegateAction(action):
      switch action {
      case let .beverageListItemTapped(beverage):
        state.route = .beverageRecord(productID: beverage.productID, isLiked: beverage.isLiked, recordDate: state.beverageRecordDate)
        
      case let .beverageFilterItemTapped(sugarLevelType, isOnlyLiked):
        state.sugarLevelType = sugarLevelType
        state.isOnlyLiked = isOnlyLiked
        
        Task { await searchBeverage(state.searchText) }

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

  private func searchBeverage(_ keyword: String) async {
    do {
      let beverageList = try await beverageUseCase.searchBeverage(keyword: keyword, sugarLevel: state.sugarLevelType, onlyLiked: state.isOnlyLiked)

      await MainActor.run {
        listViewModel.state.beverageList = beverageList.items
        listViewModel.state.cursor = beverageList.nextCursor
        listViewModel.state.hasNext = beverageList.hasNext
        listViewModel.state.filterCount.total = beverageList.totalCount
        listViewModel.state.filterCount.zero = beverageList.zeroSugarCount
        listViewModel.state.filterCount.low = beverageList.lowSugarCount
        listViewModel.state.filterCount.like = beverageList.likeCount
      }
    } catch {
      print(error)
    }
  }

  private func saveRecentSearch(_ keyword: String) async {
    await beverageLocalSearchUseCase.addRecentSearch(keyword)
    await MainActor.run {
      state.recentSearchList = beverageLocalSearchUseCase.getRecentSearchList()
    }
  }

  private func removeRecentSearch(_ keyword: String) async {
    await beverageLocalSearchUseCase.removeRecentSearch(keyword)
    await MainActor.run {
      state.recentSearchList = beverageLocalSearchUseCase.getRecentSearchList()
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
}

private extension BeverageSearchViewModel {
  func delegate() {
    listViewModel.delegateAction = { [weak self] action in
      self?.handleAction(.delegateAction(action))
    }
  }
}
