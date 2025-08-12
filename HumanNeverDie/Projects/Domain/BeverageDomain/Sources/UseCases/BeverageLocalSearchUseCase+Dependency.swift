import Dependencies

// MARK: - TestDependencyKey

public struct BeverageLocalSearchUseCaseKey: TestDependencyKey {
  public static let testValue: BeverageLocalSearchUseCaseProtocol = MockBeverageLocalSearchUseCase()
}

// MARK: - DependencyValues

public extension DependencyValues {
  var beverageLocalSearchUseCase: BeverageLocalSearchUseCaseProtocol {
    get { self[BeverageLocalSearchUseCaseKey.self] }
    set { self[BeverageLocalSearchUseCaseKey.self] = newValue }
  }
}

// MARK: - MockBeverageLocalSearchUseCase

private struct MockBeverageLocalSearchUseCase: BeverageLocalSearchUseCaseProtocol {
  func addRecentSearch(_ searchText: String) async {}
  func getRecentSearchList() -> [String] { return [] }
  func removeRecentSearch(_ searchText: String) async {}
}