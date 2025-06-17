import Foundation

public protocol MainUseCase {
  func fetchTodo(id: Int) async throws -> Todo
  func postTodo(todo: Todo) async throws -> Todo
  func putTodo(todo: Todo) async throws -> Todo
  func patchTodo(todoEditing: TodoEditing) async throws -> Todo
  func deleteTodo(id: Int) async throws
}

public final class DefaultMainUseCase: MainUseCase {
  private let repository: MainRepository
  
  public init(repository: MainRepository) {
    self.repository = repository
  }
public final class MainUseCase: MainUseCaseProtocol {
  @Dependency(\.mainRepository) private var mainRepository
  public init() {}
  
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
  
  public func deleteTodo(id: Int) async throws {
    return try await repository.deleteTodo(id: id)
// MARK: - TestDependencyKey

public struct MainUseCaseKey: TestDependencyKey {
  public static let testValue: MainUseCaseProtocol = MockUseCase()
}

// MARK: - DependencyValues

public extension DependencyValues {
  var mainUseCase: MainUseCaseProtocol {
    get { self[MainUseCaseKey.self] }
    set { self[MainUseCaseKey.self] = newValue }
  }
}

// MARK: - MockMainUseCase

private struct MockUseCase: MainUseCaseProtocol {
  func fetchTodo(id: Int) async throws -> Todo {
    return Todo.mock()
  }
  
  func postTodo(todo: Todo) async throws -> Todo {
    return Todo.mock()
  }
  
  func putTodo(todo: Todo) async throws -> Todo {
    return Todo.mock()
  }
  
  func patchTodo(todo: Todo) async throws -> Todo {
    return Todo.mock()
  }
  
  func deleteTodo(id: Int) async throws {
  }
}
