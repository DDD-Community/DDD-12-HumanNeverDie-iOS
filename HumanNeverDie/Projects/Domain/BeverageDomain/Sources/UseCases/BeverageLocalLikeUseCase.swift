import Foundation

import Dependencies

public protocol BeverageLocalLikeUseCaseProtocol: Sendable {
  func fetchBeverageLikeCount() throws -> Int
  func fetchAllBeverageLike() throws -> [BeverageLike]
  func handleBeverageLike(beverage: Beverage, originalIsLiked: Bool) throws
  func removeBeverageLike(productID: String) throws
}

public final class BeverageLocalLikeUseCase: BeverageLocalLikeUseCaseProtocol, @unchecked Sendable {
  @Dependency(\.beverageLikeLocalRepository) private var beverageLikeLocalRepository
  public init() {}
  
  public func fetchBeverageLikeCount() throws -> Int {
    return try beverageLikeLocalRepository.fetchBeverageLikeCount()
  }
  
  public func fetchAllBeverageLike() throws -> [BeverageLike] {
    return try beverageLikeLocalRepository.fetchAllBeverageLike()
  }
  
  public func handleBeverageLike(beverage: Beverage, originalIsLiked: Bool) throws {
    if let existingLike = try beverageLikeLocalRepository.fetchBeverageLike(productID: beverage.productID) {
      try handleExistingLike(beverage: beverage, storedOriginalValue: existingLike.isLiked)
    } else {
      try handleNewLike(beverage: beverage, originalIsLiked: originalIsLiked)
    }
  }
  
  public func removeBeverageLike(productID: String) throws {
    try beverageLikeLocalRepository.removeBeverageLike(productID: productID)
  }
}

extension BeverageLocalLikeUseCase {
  private func handleExistingLike(beverage: Beverage, storedOriginalValue: Bool) throws {
    if beverage.isLiked != storedOriginalValue {
      try beverageLikeLocalRepository.saveBeverageLike(beverage: beverage, originalIsLiked: storedOriginalValue)
    } else {
      try beverageLikeLocalRepository.removeBeverageLike(productID: beverage.productID)
    }
  }
  
  private func handleNewLike(beverage: Beverage, originalIsLiked: Bool) throws {
    if beverage.isLiked != originalIsLiked {
      try beverageLikeLocalRepository.saveBeverageLike(beverage: beverage, originalIsLiked: originalIsLiked)
    }
  }
}
