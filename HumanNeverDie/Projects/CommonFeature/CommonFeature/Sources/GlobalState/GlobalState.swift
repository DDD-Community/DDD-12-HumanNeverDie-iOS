import Foundation

import Dependencies

public protocol GlobalStateProtocol: Sendable {
  var eventStream: AsyncStream<GlobalEvent> { get }
  func sendEvent(_ event: GlobalEvent) async
}

public actor GlobalState: GlobalStateProtocol  {
  public static let shared = GlobalState()
  
  private let eventContinuation: AsyncStream<GlobalEvent>.Continuation
  public let eventStream: AsyncStream<GlobalEvent>
  
  public init() {
    let (stream, continuation) = AsyncStream<GlobalEvent>.makeStream()
    self.eventStream = stream
    self.eventContinuation = continuation
  }
  
  public func sendEvent(_ event: GlobalEvent) async {
    eventContinuation.yield(event)
  }
}

// MARK: - TestDependencyKey

public struct GlobalStateKey: TestDependencyKey {
  public static let testValue: GlobalStateProtocol = {
    fatalError("\(Self.self) is unimplemented. Please provide a mock.")
  }()
}

// MARK: - DependencyValues

public extension DependencyValues {
  var globalState: GlobalStateProtocol {
    get { self[GlobalStateKey.self] }
    set { self[GlobalStateKey.self] = newValue }
  }
}
