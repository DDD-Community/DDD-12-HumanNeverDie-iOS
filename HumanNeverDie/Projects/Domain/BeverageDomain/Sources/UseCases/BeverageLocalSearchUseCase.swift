import Foundation
import Shared

import Dependencies

public protocol BeverageLocalSearchUseCaseProtocol: Sendable {
  func addRecentSearch(_ searchText: String) async
  func getRecentSearchList() -> [String]
  func removeRecentSearch(_ searchText: String) async
}

public final class BeverageLocalSearchUseCase: BeverageLocalSearchUseCaseProtocol, @unchecked Sendable {
  @Dependency(\.userDefaultClient) private var userDefaultClient
  
  public init() {}
  
  public func addRecentSearch(_ searchText: String) async {
    guard !searchText.isEmpty else { return }
    
    let newList = [searchText] + getRecentSearchList()
      .filter { $0 != searchText }
      .prefix(19)
    
    await userDefaultClient.setValue(Array(newList), forKey: AMDUserDefaultKey.recentSearchList)
  }
  
  public func getRecentSearchList() -> [String] {
    return userDefaultClient.getValue(forKey: AMDUserDefaultKey.recentSearchList) ?? []
  }
  
  public func removeRecentSearch(_ searchText: String) async {
    let updatedList = getRecentSearchList().filter { $0 != searchText }
    await userDefaultClient.setValue(updatedList, forKey: AMDUserDefaultKey.recentSearchList)
  }
}
