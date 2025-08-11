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
    var searchType: BeverageSearchType = .search
    var beverageRecordDate: Date
    
    var recentSearchList: [String] = ["에스프레소", "블렌디드"]
    
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
    case recentSearchListButtonTapped(String)
    case addBeverageButtonTapped
    case delegateAction(BeverageListViewModel.DelegateAction?)
    case clearRoute
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  @Dependency(\.beverageLocalLikeUseCase) private var beverageLocalLikeUseCase
  
  @ObservationIgnored
  var listViewModel: BeverageListViewModel = .init()
  
  public var state: State
  public init(beverageRecordDate: Date) {
    self.state = .init(beverageRecordDate: beverageRecordDate)
    delegate()
  }
  
  deinit {
    print("deinit BeverageSearchViewModel")
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      Task { await syncBeverageLike() }
      
    case let .searchTextChanged(searchText):
      state.searchType = searchText.isEmpty ? .search : .list
      state.searchText = searchText
      
    case let .debounceSearchTextChanged(searchText):
      guard lastSearchedText != searchText else {
        return
      }
      
      lastSearchedText = searchText
      Task { await searchBeverage(searchText) }
      
    case let .recentSearchListButtonTapped(recentText):
      state.recentSearchList.removeAll { $0 == recentText }
      
    case .addBeverageButtonTapped:
      break
      
    case let .delegateAction(action):
      switch action {
      case let .beverageListItemTapped(beverage):
        state.route = .beverageRecord(productID: beverage.productID, isLiked: beverage.isLiked, recordDate: state.beverageRecordDate)
        
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
  
  private func searchBeverage(_ keyword: String) async {
    do {
      let beverageList = try await beverageUseCase.searchBeverage(keyword: keyword)
      
      await MainActor.run {
        listViewModel.state.beverageList = beverageList.items
        listViewModel.state.cursor = beverageList.nextCursor
        listViewModel.state.hasNext = beverageList.hasNext
        listViewModel.state.filterCount.like = beverageList.likeCount
      }
    } catch {
      print(error)
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
