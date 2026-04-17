//
//  AMDKeychainClient+Stub.swift
//  Shared
//

import Foundation
import Synchronization

/// In-memory 기반 AMDKeychainClient stub.
/// 테스트 및 SwiftUI Preview 에서 실제 키체인을 건드리지 않기 위해 사용.
/// 에러 시나리오는 init 파라미터로 주입.
public final class StubKeychainClient: AMDKeychainClientProtocol, Sendable {
  private let storage = Mutex<[String: String]>([:])
  private let setError: (any Error)?
  private let removeAllError: (any Error)?

  public init(
    setError: (any Error)? = nil,
    removeAllError: (any Error)? = nil
  ) {
    self.setError = setError
    self.removeAllError = removeAllError
  }

  public func getValue(forKey key: String) -> String? {
    storage.withLock { $0[key] }
  }

  public func setValue(_ value: String, forKey key: String) async throws {
    if let setError { throw setError }
    storage.withLock { $0[key] = value }
  }

  public func removeValue(forKey key: String) async throws {
    storage.withLock { _ = $0.removeValue(forKey: key) }
  }

  public func removeAll() async throws {
    if let removeAllError { throw removeAllError }
    storage.withLock { $0.removeAll() }
  }
}
