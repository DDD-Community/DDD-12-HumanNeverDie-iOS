import Foundation

import Dependencies

public protocol GlobalStateProtocol: Sendable {
  var homeEventStream: AsyncStream<Void> { get }
  var historyEventStream: AsyncStream<Void> { get }
  func sendEvent(_ event: GlobalEvent) async
}

public actor GlobalState: GlobalStateProtocol  {
  public static let shared = GlobalState()
  
  private let homeContinuation: AsyncStream<Void>.Continuation
  private let historyContinuation: AsyncStream<Void>.Continuation
  public let homeEventStream: AsyncStream<Void>
  public let historyEventStream: AsyncStream<Void>
  
  public init() {
    let (homeStream, homeCont) = AsyncStream<Void>.makeStream()
    let (historyStream, historyCont) = AsyncStream<Void>.makeStream()
    
    self.homeEventStream = homeStream
    self.historyEventStream = historyStream
    self.homeContinuation = homeCont
    self.historyContinuation = historyCont
  }
  
  public func sendEvent(_ event: GlobalEvent) async {
    switch event {
    case .homeRefresh:
      homeContinuation.yield()
    case .historyRefresh:
      historyContinuation.yield()
    }
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
