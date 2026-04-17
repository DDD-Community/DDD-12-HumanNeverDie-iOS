//
//  BeverageLocalSearchUseCase+Live.swift
//  BeverageDomain
//

import Foundation

import Shared

import Dependencies

public extension BeverageLocalSearchUseCase {
  static let live: BeverageLocalSearchUseCase = .init(
    addRecentSearch: { searchText in
      guard !searchText.isEmpty else { return }
      @Dependency(\.userDefaultClient) var userDefaultClient

      let current: [String] = userDefaultClient.getValue(forKey: AMDUserDefaultKey.recentSearchList) ?? []
      let newList = [searchText] + current
        .filter { $0 != searchText }
        .prefix(19)
      await userDefaultClient.setValue(Array(newList), forKey: AMDUserDefaultKey.recentSearchList)
    },
    getRecentSearchList: {
      @Dependency(\.userDefaultClient) var userDefaultClient
      return userDefaultClient.getValue(forKey: AMDUserDefaultKey.recentSearchList) ?? []
    },
    removeRecentSearch: { searchText in
      @Dependency(\.userDefaultClient) var userDefaultClient
      let current: [String] = userDefaultClient.getValue(forKey: AMDUserDefaultKey.recentSearchList) ?? []
      let updatedList = current.filter { $0 != searchText }
      await userDefaultClient.setValue(updatedList, forKey: AMDUserDefaultKey.recentSearchList)
    }
  )
}
