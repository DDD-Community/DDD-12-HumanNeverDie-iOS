//
//  BeverageUseCaseTest.swift
//  BeverageDomainTest
//
//  Created by 김규철 on 2025/07/02.
//

import Foundation
import Testing

import Dependencies

@testable import BeverageDomain

@Suite("BeverageUseCase.live")
struct BeverageUseCaseTests {

  @Test("getBeverageCount: repository 의 결과를 그대로 반환한다")
  func getBeverageCount() async throws {
    let expected = BeverageCount(totalCount: 10, zeroCount: 3, lowCount: 2)
    var repo = BeverageRepositoryInterface()
    repo.getBeverageCount = { expected }

    let result = try await withDependencies {
      $0.beverageRepository = repo
    } operation: {
      try await BeverageUseCase.live.getBeverageCount()
    }

    #expect(result == expected)
  }

  @Test(
    "recordBeverage: statusCode 200 이면 true, 그 외엔 false",
    arguments: [
      (statusCode: 200, expected: true),
      (statusCode: 400, expected: false),
      (statusCode: 500, expected: false)
    ]
  )
  func recordBeverage_statusCode(statusCode: Int, expected: Bool) async throws {
    var repo = BeverageRepositoryInterface()
    repo.recordBeverage = { _, _, _ in statusCode }

    let result = try await withDependencies {
      $0.beverageRepository = repo
    } operation: {
      try await BeverageUseCase.live.recordBeverage("product-1", Date(), "TALL")
    }

    #expect(result == expected)
  }

  @Test("recordBeverage: repository 가 throw 하면 false 를 반환한다")
  func recordBeverage_throws_returnsFalse() async throws {
    struct DummyError: Error {}
    var repo = BeverageRepositoryInterface()
    repo.recordBeverage = { _, _, _ in throw DummyError() }

    let result = try await withDependencies {
      $0.beverageRepository = repo
    } operation: {
      try await BeverageUseCase.live.recordBeverage("product-1", Date(), "TALL")
    }

    #expect(result == false)
  }

  @Test("getBeverageLikeUpdate: isLiked 가 바뀌면 index 와 likeCountChange 를 반환한다")
  func getBeverageLikeUpdate_changed() async throws {
    let beverages = Beverage.mockData
    let target = beverages[1] // isLiked: false

    let result = BeverageUseCase.live.getBeverageLikeUpdate(
      beverages,
      target.productID,
      true
    )

    #expect(result?.beverageIndex == 1)
    #expect(result?.likeCountChange == 1)
  }

  @Test("getBeverageLikeUpdate: isLiked 가 동일하거나 productID 가 없으면 nil 을 반환한다")
  func getBeverageLikeUpdate_noChange() async throws {
    let beverages = Beverage.mockData

    let sameStatus = BeverageUseCase.live.getBeverageLikeUpdate(
      beverages,
      beverages[0].productID,
      beverages[0].isLiked
    )
    let notFound = BeverageUseCase.live.getBeverageLikeUpdate(
      beverages,
      "non-existent-id",
      true
    )

    #expect(sameStatus == nil)
    #expect(notFound == nil)
  }
}
