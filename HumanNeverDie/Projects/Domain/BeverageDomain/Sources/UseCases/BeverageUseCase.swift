import Foundation

import Dependencies

public protocol BeverageUseCaseProtocol {
  func getBeverageCount() async throws -> BeverageCount
}

public final class BeverageUseCase: BeverageUseCaseProtocol {
  @Dependency(\.beverageRepository) private var beverageRepository
  public init() {}
  
  public func getBeverageCount() async throws -> BeverageCount {
    return try await beverageRepository.getBeverageCount()
  }
}
