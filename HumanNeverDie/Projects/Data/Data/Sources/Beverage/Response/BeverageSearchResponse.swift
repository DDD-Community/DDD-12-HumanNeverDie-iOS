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
    return .init(
      items: beverageSearchResults?.map { $0.toDomain() } ?? [],
      nextCursor: nil,
      hasNext: false,
      likeCount: likeCount ?? 0
    )
  }
}
