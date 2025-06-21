import Foundation

import BaseNetwork
import MainDomain

import Dependencies

public final class MainRepository: MainRepositoryInterface {
  @Dependency(\.networkService) private var networkService
  public init() {}
  
  public func fetchTodo(id: Int) async throws -> Todo {
    return try await networkService.request(MainTarget.getTodo(id: id), as: TodoResponse.self)
      .toDomain()
  }
  
  public func postTodo(todo: Todo) async throws -> Todo {
    return try await networkService.request(MainTarget.postTodo(todo: todo), as: TodoResponse.self)
      .toDomain()
  }
  
  public func putTodo(todo: Todo) async throws -> Todo {
    return try await networkService.request(MainTarget.putTodo(todo: todo), as: TodoResponse.self)
      .toDomain()
  }
  
  public func patchTodo(todo: Todo) async throws -> Todo {
    let request = todo.toDTO()
    return try await networkService.request(MainTarget.patchTodo(editing: request), as: TodoResponse.self)
      .toDomain()
  }
  
  public func deleteTodo(id: Int) async throws {
    return try await networkService.request(MainTarget.deleteTodo(id: id))
  }
}
