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
    var searchType: BeverageSearchType = .search
    
    var recentSearchList: [String] = ["에스프레소", "블렌디드"]
  }
  
  var isBeverageListEmpty: Bool {
    listViewModel.beverageList.isEmpty
  }
  
  public enum Action {
    case searchTextChanged(String)
    case recentSearchListButtonTapped(String)
    case addBeverageButtonTapped
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
    print("deinit BeverageSearchViewModel")
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case let .searchTextChanged(searchText):
      state.searchType = searchText.isEmpty ? .search : .list
      state.searchText = searchText
      
    case let .recentSearchListButtonTapped(recentText):
      state.recentSearchList.removeAll { $0 == recentText }
      
    case .addBeverageButtonTapped:
      break
      
    case let .delegateAction(action):
      switch action {
      case let .beverageListItemTapped(beverage):
        print(beverage)
        
      case nil:
        break
      }
    }
  }
}

private extension BeverageSearchViewModel {
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
