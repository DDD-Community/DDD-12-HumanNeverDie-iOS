//
//  BeverageRepository.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BaseNetwork
import BeverageDomain

import Dependencies

public extension BeverageRepositoryInterface {
  static let live: BeverageRepositoryInterface = .init(
    getBeverageCount: {
      @Dependency(\.networkService) var networkService
      let target = BeverageCountTarget()
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    getBeverageList: { cursor, sugarLevel, onlyLiked in
      @Dependency(\.networkService) var networkService
      let target = BeverageListTarget(cursor: cursor, sugarLevel: sugarLevel, onlyLiked: onlyLiked)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    getBeverageDetail: { productID in
      @Dependency(\.networkService) var networkService
      let target = BeverageDetailTarget(productID: productID)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    getBeverageMonthCalender: { dateInWeek in
      @Dependency(\.networkService) var networkService
      let target = BeverageMonthCalenderTarget(dateInMonth: dateInWeek)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.map { $0.toDomain() }
    },
    getBeverageWeeklyCalender: { dateInWeek in
      @Dependency(\.networkService) var networkService
      let target = BeverageWeeklyCalenderTarget(dateInWeek: dateInWeek)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.map { $0.toDomain() }
    },
    getBeveragDailyCalender: { dailyDate in
      @Dependency(\.networkService) var networkService
      let target = BeverageDailyCalenderTarget(dailyDate: dailyDate)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    likeBeverage: { productID in
      @Dependency(\.networkService) var networkService
      let target = BeverageLikeTarget(productID: productID)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    unLikeBeverage: { productID in
      @Dependency(\.networkService) var networkService
      let target = BeverageUnLikeTarget(productID: productID)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    searchBeverage: { keyword, sugarLevel, onlyLiked in
      @Dependency(\.networkService) var networkService
      let target = BeverageSearchTarget(keyword: keyword, sugarLevel: sugarLevel, onlyLiked: onlyLiked)
      let result = try await networkService.requestDDD(target)
      guard let response = result.data else {
        throw AMDNetworkError.emptyResponse
      }
      return response.toDomain()
    },
    recordBeverage: { productID, recordDate, size in
      @Dependency(\.networkService) var networkService
      let target = BeverageRecordTarget(productID: productID, recordDate: recordDate, size: size)
      let result = try await networkService.requestDDD(target)
      guard let statusCode = result.status else {
        throw AMDNetworkError.emptyResponse
      }
      return statusCode
    },
    deleteBeverage: { productID, intakeTime in
      @Dependency(\.networkService) var networkService
      let target = BeverageDelete(productID: productID, intakeTime: intakeTime)
      let result = try await networkService.requestDDD(target)
      guard let statusCode = result.status else {
        throw AMDNetworkError.emptyResponse
      }
      return statusCode
    }
  )
}
