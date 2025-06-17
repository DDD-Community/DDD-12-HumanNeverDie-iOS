import Foundation

import Dependencies

public protocol MainUseCaseProtocol {
  func fetchTodo(id: Int) async throws -> Todo
  func postTodo(todo: Todo) async throws -> Todo
  func putTodo(todo: Todo) async throws -> Todo
  func patchTodo(todo: Todo) async throws -> Todo
  func deleteTodo(id: Int) async throws
}

public final class MainUseCase: MainUseCaseProtocol {
  @Dependency(\.mainRepository) private var mainRepository
  public init() {}
  
  public func fetchTodo(id: Int) async throws -> Todo {
    return try await mainRepository.fetchTodo(id: id)
  }
  
  public func postTodo(todo: Todo) async throws -> Todo {
    return try await mainRepository.postTodo(todo: todo)
  }
  
  public func putTodo(todo: Todo) async throws -> Todo {
    return try await mainRepository.putTodo(todo: todo)
  }
  
  public func patchTodo(todo: Todo) async throws -> Todo {
    return try await mainRepository.patchTodo(todo: todo)
  }
  
  public func deleteTodo(id: Int) async throws {
    return try await mainRepository.deleteTodo(id: id)
  }
}

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
