import Foundation

public protocol MainUseCase {
  func fetchTodo() async throws -> Todo
}

public final class DefaultMainUseCase: MainUseCase {
  private let repository: MainRepository
  
  public init(repository: MainRepository) {
    self.repository = repository
  }
  
  public func fetchTodo() async throws -> Todo {
    return try await repository.fetchTodo()
  }
}
