//
//  MainTarget.swift
//  Data
//
//  Created by Seulki Lee on 6/8/25.
//

import Foundation
import BaseNetwork
import MainDomain

public enum MainTarget {
  case getTodo(id: Int)
  case postTodo(todo: Todo)
  case patchTodo(editing: TodoEditRequest)
  case putTodo(todo: Todo)
  case deleteTodo(id: Int)
}

extension MainTarget: AMDAPIRequestable {
  public var baseURL: String {
    return Config.baseURL
  }
  
  public var path: String {
    switch self {
    case .getTodo(let id): return "/todos/\(id)"
    case .postTodo: return "/todos"
    case .patchTodo(let editing): return "/todos/\(editing.id)"
    case .putTodo(let todo): return "/todos/\(todo.id)"
    case .deleteTodo(let id): return "/todos/\(id)"
    }
  }
  
  public var method: AMDHTTPMethod {
    switch self {
    case .getTodo: return .GET
    case .postTodo: return .POST
    case .patchTodo: return .PATCH
    case .putTodo: return .PUT
    case .deleteTodo: return .DELETE
    }
  }
  
  public var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
  
  public var queryParameters: [String : String]? {
    return nil
  }
  
  public var body: Encodable? {
    switch self {
    case .postTodo(let todo): return todo
    case .patchTodo(let editing): return editing
    case .putTodo(let todo): return todo
    default: return nil
    }
  }
}

