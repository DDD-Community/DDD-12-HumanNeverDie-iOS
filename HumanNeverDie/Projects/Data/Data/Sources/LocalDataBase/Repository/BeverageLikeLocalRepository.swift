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

public final class BeverageLikeLocalRepository: BeverageLikeLocalRepositoryInterface, @unchecked Sendable {
  @Dependency(\.localDataBaseService) private var localDataBaseService
  public init() {}
  
  public func fetchAllBeverageLike() throws -> [BeverageLike] {
    let beverageLikeModel: [BeverageLikeLocalModel] = try localDataBaseService.fetchAll(BeverageLikeLocalModel.self)
    return beverageLikeModel.map { $0.toDomain() }
  }
  
  public func fetchBeverageLikeCount() throws -> Int {
    let beverageLikeModel: [BeverageLikeLocalModel] = try localDataBaseService.fetch(BeverageLikeLocalModel.self, predicate: #Predicate { $0.isLiked == true }, sortBy: nil)
    return beverageLikeModel.count
  }
  
  public func fetchBeverageLike(productID: String) throws -> BeverageLike? {
    let beverageLikeModels: [BeverageLikeLocalModel] = try localDataBaseService.fetch(
      BeverageLikeLocalModel.self, 
      predicate: #Predicate { $0.productID == productID }, 
      sortBy: nil
    )
    return beverageLikeModels.first?.toDomain()
  }
  
  public func saveBeverageLike(beverage: Beverage, originalIsLiked: Bool) throws {
    let productID = beverage.productID
    let predicate = #Predicate<BeverageLikeLocalModel> { $0.productID == productID }
    try localDataBaseService.delete(predicate)
    
    let beverageLikeModel = BeverageLikeLocalModel(
      productID: beverage.productID,
      isLiked: beverage.isLiked,
      originalIsLiked: originalIsLiked
    )
    try localDataBaseService.insert(beverageLikeModel)
  }
  
  public func removeBeverageLike(productID: String) throws {
    let predicate = #Predicate<BeverageLikeLocalModel> { $0.productID == productID }
    try localDataBaseService.delete(predicate)
  }
}
