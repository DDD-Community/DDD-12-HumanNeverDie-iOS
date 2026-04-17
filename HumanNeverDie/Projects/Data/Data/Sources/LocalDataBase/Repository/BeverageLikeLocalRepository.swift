//
//  BeverageLikeLocalRepository.swift
//  Data
//
//  Created by 김규철 on 7/31/25.
//

import Foundation

import LocalDataBase
import BeverageDomain

import Dependencies

public extension BeverageLikeLocalRepositoryInterface {
  static let live: BeverageLikeLocalRepositoryInterface = .init(
    fetchAllBeverageLike: {
      @Dependency(\.localDataBaseService) var localDataBaseService
      let beverageLikeModel: [BeverageLikeLocalModel] = try localDataBaseService.fetchAll(BeverageLikeLocalModel.self)
      return beverageLikeModel.map { $0.toDomain() }
    },
    fetchBeverageLikeCount: {
      @Dependency(\.localDataBaseService) var localDataBaseService
      let beverageLikeModel: [BeverageLikeLocalModel] = try localDataBaseService.fetch(
        BeverageLikeLocalModel.self,
        predicate: #Predicate { $0.isLiked == true },
        sortBy: nil
      )
      return beverageLikeModel.count
    },
    fetchBeverageLike: { productID in
      @Dependency(\.localDataBaseService) var localDataBaseService
      let beverageLikeModels: [BeverageLikeLocalModel] = try localDataBaseService.fetch(
        BeverageLikeLocalModel.self,
        predicate: #Predicate { $0.productID == productID },
        sortBy: nil
      )
      return beverageLikeModels.first?.toDomain()
    },
    saveBeverageLike: { beverage, originalIsLiked in
      @Dependency(\.localDataBaseService) var localDataBaseService
      let productID = beverage.productID
      let predicate = #Predicate<BeverageLikeLocalModel> { $0.productID == productID }
      try localDataBaseService.delete(predicate)

      let beverageLikeModel = BeverageLikeLocalModel(
        productID: beverage.productID,
        isLiked: beverage.isLiked,
        originalIsLiked: originalIsLiked
      )
      try localDataBaseService.insert(beverageLikeModel)
    },
    removeBeverageLike: { productID in
      @Dependency(\.localDataBaseService) var localDataBaseService
      let predicate = #Predicate<BeverageLikeLocalModel> { $0.productID == productID }
      try localDataBaseService.delete(predicate)
    }
  )
}
