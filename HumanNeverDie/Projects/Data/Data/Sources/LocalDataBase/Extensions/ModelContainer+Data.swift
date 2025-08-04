import Foundation
import SwiftData

public extension ModelContainer {
  static var aMatdangLocalDataBase: ModelContainer {
    let schema = Schema([BeverageLikeLocalModel.self])
    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false
    )
    
    do {
      let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
      return container
    } catch {
      fatalError("Failed to create Data ModelContainer: \(error)")
    }
  }
}
