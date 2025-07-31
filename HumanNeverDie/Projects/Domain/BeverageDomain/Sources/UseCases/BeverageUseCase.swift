import Foundation

import Dependencies

public protocol BeverageUseCaseProtocol: Sendable {
  func getBeverageCount() async throws -> BeverageCount
  func getBeverageList(cursor: String?) async throws -> BeverageList
  func getBeverageDetail(productID: String) async throws -> BeverageDetail
  func likeBeverage(productID: String) async throws -> BeverageLike
  func unLikeBeverage(productID: String) async throws -> BeverageLike
  func searchBeverage(keyword: String) async throws -> BeverageList
  func recordBeverage(productID: String) async throws -> Bool
  func syncBeverageLike(beverages: [Beverage]) throws -> ([Beverage], Int)
}

public final class BeverageUseCase: BeverageUseCaseProtocol, @unchecked Sendable {
  @Dependency(\.beverageRepository) private var beverageRepository
  @Dependency(\.beverageLikeLocalRepository) private var beverageLikeLocalRepository
  public init() {}
  
  public func getBeverageCount() async throws -> BeverageCount {
    return try await beverageRepository.getBeverageCount()
  }
  
  public func getBeverageList(cursor: String?) async throws -> BeverageList {
    let beverageList = try await beverageRepository.getBeverageList(cursor: cursor)
    return try syncLocalLikeWithBeverageList(beverageList)
  }
  
  public func getBeverageDetail(productID: String) async throws -> BeverageDetail {
    return try await beverageRepository.getBeverageDetail(productID: productID)
  }
  
  public func likeBeverage(productID: String) async throws -> BeverageLike {
    return try await beverageRepository.likeBeverage(productID: productID)
  }
  
  public func unLikeBeverage(productID: String) async throws -> BeverageLike {
    return try await beverageRepository.unLikeBeverage(productID: productID)
  }
  
  public func searchBeverage(keyword: String) async throws -> BeverageList {
    let beverageList = try await beverageRepository.searchBeverage(keyword: keyword)
    return try syncLocalLikeWithBeverageList(beverageList)
  }
  
  public func recordBeverage(productID: String) async throws -> Bool {
    do {
      let statusCode = try await beverageRepository.recordBeverage(productID: productID)
      
      guard statusCode == 200 else { return false }
      
      return true
    } catch {
      return false
    }
  }
  
  public func syncBeverageLike(beverages: [Beverage]) throws -> ([Beverage], Int) {
    let localLikedBeverages = try beverageLikeLocalRepository.fetchAllBeverageLike()
    
    guard !localLikedBeverages.isEmpty else { return (beverages, 0) }
    
    let localLikeMap = Dictionary(uniqueKeysWithValues: localLikedBeverages.map { ($0.productID, $0.isLiked) })
    var likeCountDiff = 0
    
    let syncedBeverages = beverages.map { beverage in
      guard let localIsLiked = localLikeMap[beverage.productID] else { return beverage }
      
      if localIsLiked != beverage.isLiked {
        likeCountDiff += localIsLiked ? 1 : -1
      }
      
      var synced = beverage
      synced.isLiked = localIsLiked
      return synced
    }
    
    return (syncedBeverages, likeCountDiff)
  }
}

extension BeverageUseCase {
  private func syncLocalLikeWithBeverageList(_ beverageList: BeverageList) throws -> BeverageList {
    let localLikedBeverages = try beverageLikeLocalRepository.fetchAllBeverageLike()
    
    guard !localLikedBeverages.isEmpty else { return beverageList }
    
    let localLikeMap = Dictionary(uniqueKeysWithValues: localLikedBeverages.map { ($0.productID, $0.isLiked) })
    
    return BeverageList(
      items: beverageList.items.compactMap { beverage in
        var updated = beverage
        if let localIsLiked = localLikeMap[beverage.productID] {
          updated.isLiked = localIsLiked
        }
        return updated
      },
      nextCursor: beverageList.nextCursor,
      hasNext: beverageList.hasNext,
      likeCount: beverageList.likeCount + (try beverageLikeLocalRepository.fetchBeverageLikeCount())
    )
  }
}
