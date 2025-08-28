import Foundation

import Dependencies

public protocol BeverageUseCaseProtocol: Sendable {
  func getBeverageCount() async throws -> BeverageCount
  func getBeverageList(cursor: String?, sugarLevel: BeverageSugarLevelType?, onlyLiked: Bool) async throws -> BeverageList
  func getBeverageDetail(productID: String) async throws -> BeverageDetail
  func getBeverageMonthCalender(dateInWeek: String) async throws -> [BeverageCalendar]
  func getBeverageWeeklyCalender(dateInWeek: String) async throws -> [BeverageCalendar]
  func getBeveragDailyCalender(dailyDate: String) async throws -> BeverageCalendar
  func likeBeverage(productID: String) async throws -> BeverageLike
  func unLikeBeverage(productID: String) async throws -> BeverageLike
  func searchBeverage(keyword: String, sugarLevel: BeverageSugarLevelType?, onlyLiked: Bool) async throws -> BeverageList
  func recordBeverage(productID: String, recordDate: Date, size: String) async throws -> Bool
  func deleteBeverage(productID: String, intakeTime: String) async throws -> Bool
  func getBeverageLikeUpdate(from beverages: [Beverage], productID: String, newLikeStatus: Bool) -> (beverageIndex: Int, likeCountChange: Int)?
}

public final class BeverageUseCase: BeverageUseCaseProtocol, @unchecked Sendable {
  @Dependency(\.beverageRepository) private var beverageRepository
  public init() {}
  
  public func getBeverageCount() async throws -> BeverageCount {
    return try await beverageRepository.getBeverageCount()
  }
  
  public func getBeverageList(cursor: String?, sugarLevel: BeverageSugarLevelType?, onlyLiked: Bool) async throws -> BeverageList {
    return try await beverageRepository.getBeverageList(cursor: cursor, sugarLevel: sugarLevel?.rawValue, onlyLiked: onlyLiked)
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
  
  public func searchBeverage(keyword: String, sugarLevel: BeverageSugarLevelType?, onlyLiked: Bool) async throws -> BeverageList {
    return try await beverageRepository.searchBeverage(keyword: keyword, sugarLevel: sugarLevel?.rawValue, onlyLiked: onlyLiked)
  }
  
  public func recordBeverage(productID: String, recordDate: Date, size: String) async throws -> Bool {
    do {
      let statusCode = try await beverageRepository.recordBeverage(productID: productID, recordDate: recordDate, size: size)
      
      guard statusCode == 200 else { return false }
      
      return true
    } catch {
      return false
    }
  }
  
  public func getBeverageMonthCalender(dateInWeek: String) async throws -> [BeverageCalendar] {
    return try await beverageRepository.getBeverageMonthCalender(dateInWeek: dateInWeek)
  }
  
  public func getBeverageWeeklyCalender(dateInWeek: String) async throws -> [BeverageCalendar] {
    return try await beverageRepository.getBeverageWeeklyCalender(dateInWeek: dateInWeek)
  }
  
  public func getBeveragDailyCalender(dailyDate: String) async throws -> BeverageCalendar {
    return try await beverageRepository.getBeveragDailyCalender(dailyDate: dailyDate)
  }
  
  public func deleteBeverage(productID: String, intakeTime: String) async throws -> Bool {
    do {
      let statusCode = try await beverageRepository.deleteBeverage(productID: productID, intakeTime: intakeTime)
      
      guard statusCode == 200 else { return false }
      
      return true
    } catch {
      return false
    }
  }
  
  public func getBeverageLikeUpdate(from beverages: [Beverage], productID: String, newLikeStatus: Bool) -> (beverageIndex: Int, likeCountChange: Int)? {
    guard let beverageIndex = beverages.firstIndex(where: { $0.productID == productID }) else {
      return nil
    }
    
    let currentLikeStatus = beverages[beverageIndex].isLiked
    guard currentLikeStatus != newLikeStatus else { return nil }
    
    let likeCountChange = newLikeStatus ? 1 : -1
    return (beverageIndex: beverageIndex, likeCountChange: likeCountChange)
  }
}

