import Dependencies

extension BeverageLocalSearchUseCase: TestDependencyKey {
  public static let testValue = BeverageLocalSearchUseCase()
}

public extension DependencyValues {
  var beverageLocalSearchUseCase: BeverageLocalSearchUseCase {
    get { self[BeverageLocalSearchUseCase.self] }
    set { self[BeverageLocalSearchUseCase.self] = newValue }
  }
}
