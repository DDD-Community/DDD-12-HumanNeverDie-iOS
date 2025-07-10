//
//  BeverageResponse.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BeverageDomain

struct BeverageListResponse: Decodable {
  let items: [BeverageResponse]
  let nextCursor: String?
  let hasNext: Bool?
  let likeCount: Int?
  
  init(
    items: [BeverageResponse],
    nextCursor: String?,
    hasNext: Bool?,
    likeCount: Int?
  ) {
    self.items = items
    self.nextCursor = nextCursor
    self.hasNext = hasNext
    self.likeCount = likeCount
  }
}

extension BeverageListResponse {
  public func toDomain() -> BeverageList {
    return .init(
      items: items.map { $0.toDomain() },
      nextCursor: nextCursor,
      hasNext: hasNext ?? false,
      likeCount: likeCount ?? 0
    )
  }
}

struct BeverageResponse: Decodable {
  let productId: String?
  let name: String?
  let imgUrl: String?
  let beverageType: String?
  let cafeStoreDto: CafeStoreResponse?
  let isLiked: Bool?
  
  init(
    productId: String?,
    name: String?,
    imgUrl: String?,
    beverageType: String?,
    cafeStoreDto: CafeStoreResponse?,
    isLiked: Bool?
  ) {
    self.productId = productId
    self.name = name
    self.imgUrl = imgUrl
    self.beverageType = beverageType
    self.cafeStoreDto = cafeStoreDto
    self.isLiked = isLiked
  }
}

struct CafeStoreResponse: Decodable {
  let cafeBrand: String?
  
  init(cafeBrand: String?) {
    self.cafeBrand = cafeBrand
  }
}

extension BeverageResponse {
  public func toDomain() -> Beverage {
    return .init(
      name: name ?? "",
      productID: productId ?? "",
      thumbnailURL: imgUrl ?? "",
      kcal: 0, // 서버 리스폰스 값 추가 예정
      sugar: 0, // 서버 리스폰스 값 추가 예정
      brandName: cafeStoreDto?.cafeBrand ?? "",
      sugarFreeType: BeverageSugarFreeType(sugar: 0), // 서버 리스폰스 값 추가 반영 예정
      isFavorite: isLiked ?? false
    )
  }
}
