import Foundation

public struct Todo: Codable, Hashable {
  public let id: Int
  public let userId: Int
  public let title: String
  public var completed: Bool
  
  public init(
    id: Int,
    userId: Int,
    title: String,
    completed: Bool = false
  ) {
    self.id = id
    self.userId = userId
    self.title = title
    self.completed = completed
  }
}

public extension Todo {
  static func mock() -> Todo {
    return .init(
      id: 0,
      userId: 0,
      title: "",
      completed: false
    )
  }
}
