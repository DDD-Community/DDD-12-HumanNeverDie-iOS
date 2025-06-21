//
//  TodoEditRequest.swift
//  Data
//
//  Created by 김규철 on 6/17/25.
//

import Foundation

import MainDomain

public struct TodoEditRequest: Encodable {
  public let id: Int
  public let title: String
  
  public init(
    id: Int,
    title: String,
  ) {
    self.id = id
    self.title = title
  }
}

public extension Todo {
  func toDTO() -> TodoEditRequest {
    return .init(
      id: id,
      title: title
    )
  }
}
