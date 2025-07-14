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

public final class BeverageRepository: BeverageRepositoryInterface, @unchecked Sendable {
  @Dependency(\.networkService) private var networkService
  public init() {}
  
  public func getBeverageCount() async throws -> BeverageCount {
    let target = BeverageCountTarget()
    let result = try await networkService.requestDDD(target)
    
    guard let response = result.data else {
      throw AMDNetworkError.emptyResponse
    }
    
    return response.toDomain()
  }
  
  public func getBeverageList(cursor: String?) async throws -> BeverageList {
    let target = BeverageListTarget(cursor: cursor)
    let result = try await networkService.requestDDD(target)
    
    guard let response = result.data else {
      throw AMDNetworkError.emptyResponse
    }
    
    return response.toDomain()
  }
  
  public func getBeverageDetail(productID: String) async throws -> BeverageDetail {
    let target = BeverageDetailTarget(productID: productID)
    let result = try await networkService.requestDDD(target)
    
    guard let response = result.data else {
      throw AMDNetworkError.emptyResponse
    }
    
    return response.toDomain()
  }
  
  public func likeBeverage(productID: String) async throws -> BeverageLike {
    let target = BeverageLikeTarget(productID: productID)
    let result = try await networkService.requestDDD(target)
    
    guard let response = result.data else {
      throw AMDNetworkError.emptyResponse
    }
    
    return response.toDomain()
  }
  
  public func unLikeBeverage(productID: String) async throws -> BeverageLike {
    let target = BeverageUnLikeTarget(productID: productID)
    let result = try await networkService.requestDDD(target)
    
    guard let response = result.data else {
      throw AMDNetworkError.emptyResponse
    }
    
    return response.toDomain()
  }
}
