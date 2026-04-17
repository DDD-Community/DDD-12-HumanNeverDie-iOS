import Foundation
import Shared

import DependenciesMacros

@DependencyClient
public struct BeverageLocalSearchUseCase: Sendable {
  public var addRecentSearch: @Sendable (_ searchText: String) async -> Void
  public var getRecentSearchList: @Sendable () -> [String] = { [] }
  public var removeRecentSearch: @Sendable (_ searchText: String) async -> Void
}
