//
//  BeverageSearchResponse.swift
//  Data
//
//  Created by 김규철 on 7/27/25.
//

import Foundation

import BeverageDomain

struct BeverageSearchResponse: Decodable {
  let beverageSearchResults: [BeverageResponse]?
  let likeCount: Int?
}

extension BeverageSearchResponse {
  public func toDomain() -> BeverageList {
    let items = beverageSearchResults?.map { $0.toDomain() } ?? []
    return .init(
      items: items,
      nextCursor: nil,
      hasNext: false,
      likeCount: likeCount ?? 0
    )
  }
}
