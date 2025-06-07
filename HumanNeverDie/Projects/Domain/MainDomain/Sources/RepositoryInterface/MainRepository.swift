import Foundation

public protocol MainRepository: AnyObject {
  func fetchTodo(id: Int) async throws -> Todo
  func postTodo(todo: Todo) async throws -> Todo
  func putTodo(todo: Todo) async throws -> Todo
  func patchTodo(todoEditing: TodoEditing) async throws -> Todo
  func deleteTodo(id: Int) async throws -> Todo
  
}
