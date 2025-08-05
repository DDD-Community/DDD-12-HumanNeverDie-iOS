import Dependencies

// MARK: - TestDependencyKey

public struct BeverageLocalLikeUseCaseKey: TestDependencyKey {
  public static let testValue: BeverageLocalLikeUseCaseProtocol = MockBeverageLocalLikeUseCase()
}

// MARK: - DependencyValues

public extension DependencyValues {
  var beverageLocalLikeUseCase: BeverageLocalLikeUseCaseProtocol {
    get { self[BeverageLocalLikeUseCaseKey.self] }
    set { self[BeverageLocalLikeUseCaseKey.self] = newValue }
  }
}

// MARK: - MockBeverageLocalLikeUseCase

private struct MockBeverageLocalLikeUseCase: BeverageLocalLikeUseCaseProtocol {
  func fetchAllBeverageLike() throws -> [BeverageLike] { return [] }
  func fetchBeverageLikeCount() throws -> Int { return 0 }
  func handleBeverageLike(beverage: Beverage, originalIsLiked: Bool) throws {}
  func removeBeverageLike(productID: String) throws {}
}
