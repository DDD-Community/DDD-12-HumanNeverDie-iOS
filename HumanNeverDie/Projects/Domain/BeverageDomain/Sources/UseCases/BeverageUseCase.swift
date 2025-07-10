import Foundation

import Dependencies

public protocol BeverageUseCaseProtocol {
  func getBeverageCount() async throws -> BeverageCount
  func getBeverageList(cursor: String?) async throws -> BeverageList
  func getBeverageDetail(productID: String) async throws -> BeverageDetail
  func likeBeverage(productID: String) async throws -> BeverageLike
}

public final class BeverageUseCase: BeverageUseCaseProtocol {
  @Dependency(\.beverageRepository) private var beverageRepository
  public init() {}
  
  public func getBeverageCount() async throws -> BeverageCount {
    return try await beverageRepository.getBeverageCount()
  }
  
  public func getBeverageList(cursor: String?) async throws -> BeverageList {
    return try await beverageRepository.getBeverageList(cursor: cursor)
  }
  
  public func getBeverageDetail(productID: String) async throws -> BeverageDetail {
    return try await beverageRepository.getBeverageDetail(productID: productID)
  }
  
  public func likeBeverage(productID: String) async throws -> BeverageLike {
    return try await beverageRepository.likeBeverage(productID: productID)
  }
}
