//
//  BeverageLocalLikeUseCaseTest.swift
//  BeverageDomainTest
//

import Foundation
import Synchronization
import Testing

import Dependencies

@testable import BeverageDomain

@Suite("BeverageLocalLikeUseCase.live")
struct BeverageLocalLikeUseCaseTests {

  @Test("fetchBeverageLikeCount: repository 의 결과를 그대로 반환한다")
  func fetchBeverageLikeCount() throws {
    var repo = BeverageLikeLocalRepositoryInterface()
    repo.fetchBeverageLikeCount = { 7 }

    let result = try withDependencies {
      $0.beverageLikeLocalRepository = repo
    } operation: {
      try BeverageLocalLikeUseCase.live.fetchBeverageLikeCount()
    }

    #expect(result == 7)
  }

  @Test("handleBeverageLike: 저장된 like 가 없고 isLiked 가 originalIsLiked 와 다르면 saveBeverageLike 를 호출한다")
  func handleBeverageLike_newLike_saves() throws {
    let beverage = Beverage.mockData[1] // isLiked: false
    let saved = Mutex<(String, Bool)?>(nil)

    var repo = BeverageLikeLocalRepositoryInterface()
    repo.fetchBeverageLike = { _ in nil }
    repo.saveBeverageLike = { beverage, originalIsLiked in
      saved.withLock { $0 = (beverage.productID, originalIsLiked) }
    }

    try withDependencies {
      $0.beverageLikeLocalRepository = repo
    } operation: {
      // beverage.isLiked = false, originalIsLiked = true → 바뀌었으므로 저장
      try BeverageLocalLikeUseCase.live.handleBeverageLike(beverage, true)
    }

    let captured = saved.withLock { $0 }
    #expect(captured?.0 == beverage.productID)
    #expect(captured?.1 == true)
  }

  @Test("handleBeverageLike: 저장된 like 가 있고 isLiked 가 바뀌지 않았으면 removeBeverageLike 를 호출한다")
  func handleBeverageLike_existingLike_sameStatus_removes() throws {
    let beverage = Beverage.mockData[0] // isLiked: true
    let existingLike = BeverageLike(productID: beverage.productID, isLiked: true, likeCount: 1)
    let removedID = Mutex<String?>(nil)

    var repo = BeverageLikeLocalRepositoryInterface()
    repo.fetchBeverageLike = { _ in existingLike }
    repo.removeBeverageLike = { productID in
      removedID.withLock { $0 = productID }
    }

    try withDependencies {
      $0.beverageLikeLocalRepository = repo
    } operation: {
      try BeverageLocalLikeUseCase.live.handleBeverageLike(beverage, false)
    }

    #expect(removedID.withLock { $0 } == beverage.productID)
  }
}
