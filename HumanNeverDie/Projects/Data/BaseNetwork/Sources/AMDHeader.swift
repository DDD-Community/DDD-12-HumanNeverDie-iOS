//
//  AMDHeader.swift
//  BaseNetwork
//
//  Created by 김규철 on 8/22/25.
//

import Foundation

import Shared

import Dependencies

public enum AMDHeader {
  public static func authorization() -> [String: String] {
    @Dependency(\.keychainClient) var keychainClient
    
    guard let accessToken = keychainClient.getValue(forKey: AMDKeychainKey.accessToken) else {
      return [:]
    }
    
    return ["Authorization": "Bearer \(accessToken)"]
  }
}
