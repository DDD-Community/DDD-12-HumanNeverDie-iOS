//
//  BeverageUseCase+Live.swift
//  BeverageDomain
//

import Foundation

import Dependencies

public extension BeverageUseCase {
  static let live: BeverageUseCase = .init(
    getBeverageCount: {
      @Dependency(\.beverageRepository) var beverageRepository
      return try await beverageRepository.getBeverageCount()
    },
    getBeverageList: { cursor, sugarLevel, onlyLiked in
      @Dependency(\.beverageRepository) var beverageRepository
      return try await beverageRepository.getBeverageList(
        cursor: cursor,
        sugarLevel: sugarLevel?.rawValue,
        onlyLiked: onlyLiked
      )
    },
    getBeverageDetail: { productID in
      @Dependency(\.beverageRepository) var beverageRepository
      return try await beverageRepository.getBeverageDetail(productID: productID)
    },
    getBeverageMonthCalender: { dateInWeek in
      @Dependency(\.beverageRepository) var beverageRepository
      return try await beverageRepository.getBeverageMonthCalender(dateInWeek: dateInWeek)
    },
    getBeverageWeeklyCalender: { dateInWeek in
      @Dependency(\.beverageRepository) var beverageRepository
      return try await beverageRepository.getBeverageWeeklyCalender(dateInWeek: dateInWeek)
    },
    getBeveragDailyCalender: { dailyDate in
      @Dependency(\.beverageRepository) var beverageRepository
      return try await beverageRepository.getBeveragDailyCalender(dailyDate: dailyDate)
    },
    likeBeverage: { productID in
      @Dependency(\.beverageRepository) var beverageRepository
      return try await beverageRepository.likeBeverage(productID: productID)
    },
    unLikeBeverage: { productID in
      @Dependency(\.beverageRepository) var beverageRepository
      return try await beverageRepository.unLikeBeverage(productID: productID)
    },
    searchBeverage: { keyword, sugarLevel, onlyLiked in
      @Dependency(\.beverageRepository) var beverageRepository
      return try await beverageRepository.searchBeverage(
        keyword: keyword,
        sugarLevel: sugarLevel?.rawValue,
        onlyLiked: onlyLiked
      )
    },
    recordBeverage: { productID, recordDate, size in
      @Dependency(\.beverageRepository) var beverageRepository
      do {
        let statusCode = try await beverageRepository.recordBeverage(
          productID: productID,
          recordDate: recordDate,
          size: size
        )
        guard statusCode == 200 else { return false }
        return true
      } catch {
        return false
      }
    },
    deleteBeverage: { productID, intakeTime in
      @Dependency(\.beverageRepository) var beverageRepository
      do {
        let statusCode = try await beverageRepository.deleteBeverage(
          productID: productID,
          intakeTime: intakeTime
        )
        guard statusCode == 200 else { return false }
        return true
      } catch {
        return false
      }
    },
    getBeverageLikeUpdate: { beverages, productID, newLikeStatus in
      guard let beverageIndex = beverages.firstIndex(where: { $0.productID == productID }) else {
        return nil
      }
      let currentLikeStatus = beverages[beverageIndex].isLiked
      guard currentLikeStatus != newLikeStatus else { return nil }
      let likeCountChange = newLikeStatus ? 1 : -1
      return (beverageIndex: beverageIndex, likeCountChange: likeCountChange)
    }
  )
}
