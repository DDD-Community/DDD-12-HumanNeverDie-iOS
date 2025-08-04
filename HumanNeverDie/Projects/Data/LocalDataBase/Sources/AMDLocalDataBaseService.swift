import Foundation
import SwiftData

public protocol AMDLocalDataBaseServiceProtocol: Sendable {
  func insert<T: PersistentModel>(_ model: T) throws
  func fetch<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>?, sortBy: [SortDescriptor<T>]?) throws -> [T]
  func fetchAll<T: PersistentModel>(_ type: T.Type) throws -> [T]
  func update<T: PersistentModel>(_ model: T) throws
  func delete<T: PersistentModel>(_ predicate: Predicate<T>) throws
  func deleteAll<T: PersistentModel>(_ type: T.Type) throws
}

public final class AMDLocalDataBaseService: AMDLocalDataBaseServiceProtocol, @unchecked Sendable {
  private let container: ModelContainer
  
  public init(container: ModelContainer) {
    self.container = container
  }
  
  public func insert<T: PersistentModel>(_ model: T) throws {
    let context = ModelContext(container)
    context.insert(model)
    try context.save()
  }
  
  public func fetch<T: PersistentModel>(
    _ type: T.Type,
    predicate: Predicate<T>? = nil,
    sortBy: [SortDescriptor<T>]? = nil
  ) throws -> [T] {
    let context = ModelContext(container)
    let descriptor = FetchDescriptor<T>(
      predicate: predicate,
      sortBy: sortBy ?? []
    )
    return try context.fetch(descriptor)
  }
  
  public func fetchAll<T: PersistentModel>(_ type: T.Type) throws -> [T] {
    return try fetch(type)
  }
  
  public func update<T: PersistentModel>(_ model: T) throws {
    let context = ModelContext(container)
    try context.save()
  }
  
  public func delete<T: PersistentModel>(_ predicate: Predicate<T>) throws {
    let context = ModelContext(container)
    let descriptor = FetchDescriptor<T>(predicate: predicate)
    let data = try context.fetch(descriptor).first
    if let data { context.delete(data) }
    try context.save()
  }
  
  public func deleteAll<T: PersistentModel>(_ type: T.Type) throws {
    let context = ModelContext(container)
    let models = try fetchAll(type)
    for model in models {
      context.delete(model)
    }
    try context.save()
  }
}
