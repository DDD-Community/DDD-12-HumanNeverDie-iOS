//
//  AMDUserDefaultClient+Stub.swift
//  Shared
//

import Foundation
import Synchronization

/// In-memory 기반 AMDUserDefaultClient stub.
/// 테스트 및 SwiftUI Preview 에서 실제 UserDefaults 를 건드리지 않기 위해 사용.
public final class StubUserDefaultClient: AMDUserDefaultClientProtocol, Sendable {
  private let storage = Mutex<[String: any Sendable]>([:])

  public init() {}

  public func getValue<T>(forKey key: String) -> T? {
    storage.withLock { $0[key] as? T }
  }

  public func setValue<T: Sendable>(_ value: T?, forKey key: String) async {
    storage.withLock { dict in
      if let value {
        dict[key] = value
      } else {
        dict.removeValue(forKey: key)
      }
    }
  }

  public func removeValue(forKey key: String) async {
    storage.withLock { _ = $0.removeValue(forKey: key) }
  }
}
