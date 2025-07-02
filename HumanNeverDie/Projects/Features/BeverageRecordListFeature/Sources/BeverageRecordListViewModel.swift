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

@Observable
@MainActor
public final class BeverageRecordListViewModel: ViewModelable {
  public struct State: Equatable {
    var searchText: String = ""
    
    var listType: BeverageListType = .list
    var filterType: BeverageFilterType = .all
    
    var beverageList: [Beverage] = Beverage.mockData
    var frequentBeverageList: [Beverage] = Beverage.frequentMockData
    var recentSearchList: [String] = ["에스프레소", "블렌디드"]
  }
  
  public enum Action {
    case onAppear
    case searchBarFocusChanged(Bool)
    case searchTextChanged(String)
    case beverageFilterChipItemTapped(BeverageFilterType)
    case beverageListFavoriteTapped(Bool, String)
    case beverageListInfoTapped(String)
    case addBeverageButtonTapped
    case recentSearchListButtonTapped(String)
  }
  
  public var state: State = .init()
  public init() {}
  
  deinit {
    print("deinit BeverageRecordListViewModel")
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case let .searchBarFocusChanged(isFocused):
      state.listType = isFocused ? .search : .list
      
    case let .searchTextChanged(searchText):
      state.searchText = searchText
      
    case let .beverageFilterChipItemTapped(filterType):
      state.filterType = filterType
      
    case .beverageListFavoriteTapped(_, _):
      break
      
    case .beverageListInfoTapped(_):
      break
      
    case .addBeverageButtonTapped:
      break
      
    case .recentSearchListButtonTapped(_):
      break
    }
  }
}
