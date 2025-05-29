import Foundation

public protocol MainRepository: AnyObject {
  func fetchTodo() async throws -> Todo
}
