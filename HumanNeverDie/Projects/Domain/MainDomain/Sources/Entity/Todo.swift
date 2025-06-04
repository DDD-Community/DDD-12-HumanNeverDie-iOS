import Foundation

public struct Todo: Codable, Hashable {
  public let id: Int
  public let userId: Int
  public let title: String
  public var completed: Bool = false
  
  public init(
    id: Int,
    userId: Int,
    title: String
  ) {
    self.id = id
    self.userId = userId
    self.title = title
  }
}

public struct TodoEditing: Codable, Hashable {
  public let id: Int
  public let userId: Int?
  public let title: String?
  public var completed: Bool = false
  
  public init(id: Int, userId: Int) {
    self.id = id
    self.userId = userId
    self.title = nil
    }
  
  public init(id: Int, title: String) {
    self.id = id
    self.userId = nil
    self.title = title
  }
  
  public init(id: Int, userId: Int, title: String) {
    self.id = id
    self.userId = userId
    self.title = title
  }
}
