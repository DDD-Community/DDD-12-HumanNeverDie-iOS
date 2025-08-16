//
//  AMDUserDefaultClient.swift
//  Shared
//
//  Created by 김규철 on 8/11/25.
//

import Foundation

import Dependencies

public protocol AMDUserDefaultClientProtocol: Sendable {
  func getValue<T>(forKey key: String) -> T?
  func setValue<T: Sendable>(_ value: T?, forKey key: String) async
  func removeValue(forKey key: String) async
}

public actor AMDUserDefaultClient: AMDUserDefaultClientProtocol {
  public init() {}
  
  nonisolated public func getValue<T>(forKey key: String) -> T? {
    return UserDefaults.standard.object(forKey: key) as? T
  }
  
  public func setValue<T>(_ value: T?, forKey key: String) async {
    if let value = value {
      UserDefaults.standard.set(value, forKey: key)
    }
  }
  
  public func removeValue(forKey key: String) async {
    UserDefaults.standard.removeObject(forKey: key)
  }
}

// MARK: - TestDependencyKey

public struct AMDUserDefaultClientKey: TestDependencyKey {
  public static var testValue: AMDUserDefaultClientProtocol {
    fatalError("\(AMDUserDefaultClientProtocol.self) Implementation not available")
  }
}

// MARK: - DependencyValues

public extension DependencyValues {
  var userDefaultClient: AMDUserDefaultClientProtocol {
    get { self[AMDUserDefaultClientKey.self] }
    set { self[AMDUserDefaultClientKey.self] = newValue }
  }
}
