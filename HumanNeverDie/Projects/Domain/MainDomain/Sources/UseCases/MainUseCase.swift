import Foundation

public protocol MainUseCase {
  func fetchTodo(id: Int) async throws -> Todo
  func postTodo(todo: Todo) async throws -> Todo
  func putTodo(todo: Todo) async throws -> Todo
  func patchTodo(todoEditing: TodoEditing) async throws -> Todo
  func deleteTodo(id: Int) async throws -> Todo
}

public final class DefaultMainUseCase: MainUseCase {
  private let repository: MainRepository
  
  public init(repository: MainRepository) {
    self.repository = repository
  }
  
  public func fetchTodo(id: Int) async throws -> Todo {
    return try await repository.fetchTodo(id: id)
  }
  
  public func postTodo(todo: Todo) async throws -> Todo {
    return try await repository.postTodo(todo: todo)
  }
  
  public func putTodo(todo: Todo) async throws -> Todo {
    return try await repository.putTodo(todo: todo)
  }
  
  public func patchTodo(todoEditing: TodoEditing) async throws -> Todo {
    return try await repository.patchTodo(todoEditing: todoEditing)
  }
  
  public func deleteTodo(id: Int) async throws -> Todo {
    return try await repository.deleteTodo(id: id)
  }
}
