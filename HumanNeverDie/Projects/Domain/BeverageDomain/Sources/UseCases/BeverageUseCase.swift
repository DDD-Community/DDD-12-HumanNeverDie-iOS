import Foundation

import Dependencies

public protocol BeverageUseCaseProtocol: Sendable {
  func getBeverageCount() async throws -> BeverageCount
  func getBeverageList(cursor: String?) async throws -> BeverageList
  func getBeverageDetail(productID: String) async throws -> BeverageDetail
  func getBeverageMonthCalender(dateInWeek: String) async throws -> [BeverageCalendar]
  func getBeverageWeeklyCalender(dateInWeek: String) async throws -> [BeverageCalendar]
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
    let (syncedBeverages, likeCountDiff) = try syncBeverageLike(beverages: beverageList.items)
    
    return BeverageList(
      items: syncedBeverages,
      nextCursor: beverageList.nextCursor,
      hasNext: beverageList.hasNext,
      likeCount: beverageList.likeCount + likeCountDiff
    )
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
    let (syncedBeverages, likeCountDiff) = try syncBeverageLike(beverages: beverageList.items)
    
    return BeverageList(
      items: syncedBeverages,
      nextCursor: beverageList.nextCursor,
      hasNext: beverageList.hasNext,
      likeCount: beverageList.likeCount + likeCountDiff
    )
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
  
  /// 로컬 좋아요 상태를 음료 목록에 동기화하고 카운트 차이를 계산
  public func syncBeverageLike(beverages: [Beverage]) throws -> ([Beverage], Int) {
    // 로컬에 저장된 좋아요 변경사항 조회
    let localLikedBeverages = try beverageLikeLocalRepository.fetchAllBeverageLike()
    
    guard !localLikedBeverages.isEmpty else { return (beverages, 0) }
    
    // 빠른 조회를 위한 Map 생성
    let localLikeMap = Dictionary(uniqueKeysWithValues: localLikedBeverages.map { ($0.productID, $0.isLiked) })
    var likeCountDiff = 0
    
    // 음료 목록에 로컬 좋아요 상태 적용 및 카운트 차이 계산
    let syncedBeverages = beverages.map { beverage in
      guard let localIsLiked = localLikeMap[beverage.productID] else { return beverage }
      
      // 서버 상태와 로컬 상태가 다르면 카운트 차이 계산
      if localIsLiked != beverage.isLiked {
        likeCountDiff += localIsLiked ? 1 : -1
      }
      
      // 로컬 좋아요 상태로 업데이트
      var synced = beverage
      synced.isLiked = localIsLiked
      return synced
    }
    
    return (syncedBeverages, likeCountDiff)
  }
  
  
  public func getBeverageMonthCalender(dateInWeek: String) async throws -> [BeverageCalendar] {
      return try await beverageRepository.getBeverageMonthCalender(dateInWeek: dateInWeek)
  }
  
  public func getBeverageWeeklyCalender(dateInWeek: String) async throws -> [BeverageCalendar] {
      return try await beverageRepository.getBeverageWeeklyCalender(dateInWeek: dateInWeek)
  }
}

