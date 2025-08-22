//
//  AMDKeychainClient.swift
//  Shared
//
//  Created by 김규철 on 8/21/25.
//

import Foundation
import Security

import Dependencies

public protocol AMDKeychainClientProtocol: Sendable {
  func getValue(forKey key: String) async -> String?
  func setValue(_ value: String, forKey key: String) async throws
  func removeValue(forKey key: String) async throws
  func removeAll() async throws
}

public actor AMDKeychainClient: AMDKeychainClientProtocol {
  private let serviceName: String
  
  public init(serviceName: String = "com.ahMatdang.ddd") {
    self.serviceName = serviceName
  }
  
  public func getValue(forKey key: String) async -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceName,
      kSecAttrAccount as String: key,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    guard status == errSecSuccess,
          let data = result as? Data,
          let value = String(data: data, encoding: .utf8) else {
      return nil
    }
    
    return value
  }
  
  public func setValue(_ value: String, forKey key: String) async throws {
    guard let data = value.data(using: .utf8) else {
      throw AMDKeychainError.invalidData
    }
    
    if await getValue(forKey: key) != nil {
      try await updateValue(data, forKey: key)
    } else {
      try await addValue(data, forKey: key)
    }
  }
  
  public func removeValue(forKey key: String) async throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceName,
      kSecAttrAccount as String: key
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw AMDKeychainError.deleteFailed(status)
    }
  }
  
  public func removeAll() async throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceName
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw AMDKeychainError.deleteAllFailed(status)
    }
  }
}

// MARK: - Private Methods

private extension AMDKeychainClient {
  func addValue(_ data: Data, forKey key: String) async throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceName,
      kSecAttrAccount as String: key,
      kSecValueData as String: data,
      kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    ]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    
    guard status == errSecSuccess else {
      throw AMDKeychainError.addFailed(status)
    }
  }
  
  func updateValue(_ data: Data, forKey key: String) async throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceName,
      kSecAttrAccount as String: key
    ]
    
    let attributesToUpdate: [String: Any] = [
      kSecValueData as String: data
    ]
    
    let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
    
    guard status == errSecSuccess else {
      throw AMDKeychainError.updateFailed(status)
    }
  }
}

// MARK: - TestDependencyKey

public struct AMDKeychainClientKey: TestDependencyKey {
  public static var testValue: AMDKeychainClientProtocol {
    fatalError("\(AMDKeychainClientProtocol.self) Implementation not available")
  }
}

// MARK: - DependencyValues

public extension DependencyValues {
  var keychainClient: AMDKeychainClientProtocol {
    get { self[AMDKeychainClientKey.self] }
    set { self[AMDKeychainClientKey.self] = newValue }
  }
}
