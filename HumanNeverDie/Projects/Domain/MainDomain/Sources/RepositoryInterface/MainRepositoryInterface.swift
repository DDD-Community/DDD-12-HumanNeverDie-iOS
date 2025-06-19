import Foundation

import Dependencies

public protocol MainRepositoryInterface {
  func fetchTodo(id: Int) async throws -> Todo
  func postTodo(todo: Todo) async throws -> Todo
  func putTodo(todo: Todo) async throws -> Todo
  func patchTodo(todo: Todo) async throws -> Todo
  func deleteTodo(id: Int) async throws
  
}

// MARK: - TestDependencyKey

public struct MainRepositoryKey: TestDependencyKey {
  public static let testValue: MainRepositoryInterface = MockMainRepository()
}

// MARK: - DependencyValues

public extension DependencyValues {
  var mainRepository: MainRepositoryInterface {
    get { self[MainRepositoryKey.self] }
    set { self[MainRepositoryKey.self] = newValue }
  }
}

// MARK: - MockMainRepository

private struct MockMainRepository: MainRepositoryInterface {
  func fetchTodo(id: Int) async throws -> Todo { Todo.mock() }
  func postTodo(todo: MainDomain.Todo) async throws -> Todo { Todo.mock() }
  func putTodo(todo: MainDomain.Todo) async throws -> Todo { Todo.mock() }
  func patchTodo(todo: Todo) async throws -> Todo { Todo.mock() }
  func deleteTodo(id: Int) async throws {}
}
