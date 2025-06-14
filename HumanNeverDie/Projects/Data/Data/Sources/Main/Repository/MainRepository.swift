import Foundation

import BaseNetwork
import MainDomain

public final class DefaultMainRepository: MainRepository {
  private let networkService: AMDNetworkService
  
  public init(networkService: AMDNetworkService) {
    self.networkService = networkService
  }
  
  public func fetchTodo(id: Int) async throws -> Todo {
    return try await networkService.request(MainTarget.getTodo(id: id), as: TodoResponse.self).toDomain()
  }
  
  public func postTodo(todo: Todo) async throws -> Todo {
    return try await networkService.request(MainTarget.postTodo(todo: todo), as: TodoResponse.self).toDomain()
  }
  
  public func putTodo(todo: Todo) async throws -> Todo {
    return try await networkService.request(MainTarget.putTodo(todo: todo), as: TodoResponse.self).toDomain()
  }
  
  public func patchTodo(todoEditing: TodoEditing) async throws -> Todo {
    return try await networkService.request(MainTarget.patchTodo(editing: todoEditing), as: TodoResponse.self).toDomain()
  }
  
  public func deleteTodo(id: Int) async throws {
    return try await networkService.request(MainTarget.deleteTodo(id: id))
  }
}

