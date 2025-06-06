import Foundation

import BaseNetwork
import MainDomain

public final class DefaultMainRepository: MainRepository {
  private let networkService: NetworkService
  
  public init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  public func fetchTodo(id : Int) async throws -> Todo {
    let endpoint = APIEndpoint(
      baseURL: Config.baseURL,
      path: "/todos/\(id)",
      method: .GET
    )
    return try await networkService.request(endpoint: endpoint, responseType: TodoResponse.self)
      .toDomain()
  }
  
  public func postTodo(todo toDo: Todo) async throws -> Todo {
    let endpoint = APIEndpoint(
      baseURL: Config.baseURL,
      path: "/todos",
      method: .POST,
      body: toDo
    )
    return try await networkService.request(endpoint: endpoint, responseType: TodoResponse.self)
      .toDomain()
  }
  
  public func putTodo(todo toDo: Todo) async throws -> Todo {
    let endpoint = APIEndpoint(
      baseURL: Config.baseURL,
      path: "/todos/\(toDo.id)",
      method: .PUT,
      body: toDo
    )
    return try await networkService.request(endpoint: endpoint, responseType: TodoResponse.self)
      .toDomain()
  }
  
  public func patchTodo(todoEditing: TodoEditing) async throws -> Todo {
    let endpoint = APIEndpoint(
      baseURL: Config.baseURL,
      path: "/todos/\(todoEditing.id)",
      method: .PATCH,
      body: todoEditing
    )
    return try await networkService.request(endpoint: endpoint, responseType: TodoResponse.self).toDomain()
  }
  
  public func deleteTodo(id: Int) async throws -> Todo {
    let endpoint = APIEndpoint(
      baseURL: Config.baseURL,
      path: "/todos/\(id)",
      method: .DELETE
    )
    return try await networkService.request(endpoint: endpoint, responseType: TodoResponse.self).toDomain()
  }
  
}
