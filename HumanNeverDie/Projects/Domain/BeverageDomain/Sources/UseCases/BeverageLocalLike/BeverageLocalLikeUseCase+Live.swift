//
//  BeverageLocalLikeUseCase+Live.swift
//  BeverageDomain
//

import Foundation

import Dependencies

public extension BeverageLocalLikeUseCase {
  static let live: BeverageLocalLikeUseCase = .init(
    fetchBeverageLikeCount: {
      @Dependency(\.beverageLikeLocalRepository) var repo
      return try repo.fetchBeverageLikeCount()
    },
    fetchAllBeverageLike: {
      @Dependency(\.beverageLikeLocalRepository) var repo
      return try repo.fetchAllBeverageLike()
    },
    handleBeverageLike: { beverage, originalIsLiked in
      @Dependency(\.beverageLikeLocalRepository) var repo
      if let existingLike = try repo.fetchBeverageLike(productID: beverage.productID) {
        try handleExistingLike(
          beverage: beverage,
          storedOriginalValue: existingLike.isLiked,
          repo: repo
        )
      } else {
        try handleNewLike(
          beverage: beverage,
          originalIsLiked: originalIsLiked,
          repo: repo
        )
      }
    },
    removeBeverageLike: { productID in
      @Dependency(\.beverageLikeLocalRepository) var repo
      try repo.removeBeverageLike(productID: productID)
    }
  )
}

private func handleExistingLike(
  beverage: Beverage,
  storedOriginalValue: Bool,
  repo: BeverageLikeLocalRepositoryInterface
) throws {
  if beverage.isLiked != storedOriginalValue {
    try repo.saveBeverageLike(beverage: beverage, originalIsLiked: storedOriginalValue)
  } else {
    try repo.removeBeverageLike(productID: beverage.productID)
  }
}

private func handleNewLike(
  beverage: Beverage,
  originalIsLiked: Bool,
  repo: BeverageLikeLocalRepositoryInterface
) throws {
  if beverage.isLiked != originalIsLiked {
    try repo.saveBeverageLike(beverage: beverage, originalIsLiked: originalIsLiked)
  }
}
