//
//  TodoResponse.swift
//  Data
//
//  Created by 김규철 on 5/25/25.
//

import Foundation

import MainDomain

public struct TodoResponse: Decodable {
    public let userId: Int
    public let id: Int
    public let title: String
    public let completed: Bool
    
    public init(userId: Int, id: Int, title: String, completed: Bool) {
        self.userId = userId
        self.id = id
        self.title = title
        self.completed = completed
    }
}

public extension TodoResponse {
  func toDomain() -> Todo {
    return Todo(userId: userId, id: id, title: "타이틀은 \(title)")
  }
}
