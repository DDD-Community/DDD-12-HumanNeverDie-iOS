import Foundation

public struct Todo: Hashable {
  public let userId: Int
  public let id: Int
  public let title: String
  
  public init(
    userId: Int,
    id: Int,
    title: String
  ) {
    self.userId = userId
    self.id = id
    self.title = title
  }
}
