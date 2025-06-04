//
//  TodoResponse.swift
//  Data
//
//  Created by 김규철 on 5/25/25.
//

import Foundation

import MainDomain

public struct TodoResponse: Decodable {
  public let id: Int
  public var userId: Int
  public let title: String
  public let completed: Bool
  
  // 전체 이니셜라이저
  public init(id: Int, userId: Int, title: String, completed: Bool) {
    self.id = id
    self.userId = userId
    self.title = title
    self.completed = completed
  }
}

public extension TodoResponse {
  func toDomain() -> Todo {
    return Todo(id: id, userId: userId, title: "타이틀은 \(title)")
  }
}
