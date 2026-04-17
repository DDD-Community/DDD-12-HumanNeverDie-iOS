import Dependencies

extension BeverageLocalLikeUseCase: TestDependencyKey {
  public static let testValue = BeverageLocalLikeUseCase(
    fetchBeverageLikeCount: { unimplemented("BeverageLocalLikeUseCase.fetchBeverageLikeCount", placeholder: 0) },
    fetchAllBeverageLike: { unimplemented("BeverageLocalLikeUseCase.fetchAllBeverageLike", placeholder: []) },
    handleBeverageLike: { _, _ in reportIssue("BeverageLocalLikeUseCase.handleBeverageLike is unimplemented") },
    removeBeverageLike: { _ in reportIssue("BeverageLocalLikeUseCase.removeBeverageLike is unimplemented") }
  )
}

public extension DependencyValues {
  var beverageLocalLikeUseCase: BeverageLocalLikeUseCase {
    get { self[BeverageLocalLikeUseCase.self] }
    set { self[BeverageLocalLikeUseCase.self] = newValue }
  }
}
