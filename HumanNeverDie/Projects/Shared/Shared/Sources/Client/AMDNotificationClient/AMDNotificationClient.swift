//
//  AMDNotificationClient.swift
//  Shared
//
//  Created by Claude on 2025.
//

import UIKit
import UserNotifications

import Dependencies

public protocol AMDNotificationClientProtocol: Sendable {
  func isNotDetermined() async -> Bool
  @MainActor func requestAuthorization() async throws -> Bool
  func registerForRemoteNotifications() async
}

public struct AMDNotificationClient: AMDNotificationClientProtocol {
  public init() {}

  public func isNotDetermined() async -> Bool {
    let settings = await UNUserNotificationCenter.current().notificationSettings()
    return settings.authorizationStatus == .notDetermined
  }

  @MainActor
  public func requestAuthorization() async throws -> Bool {
    try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
  }

  public func registerForRemoteNotifications() async {
    await MainActor.run {
      UIApplication.shared.registerForRemoteNotifications()
    }
  }
}

// MARK: - TestDependencyKey

public struct AMDNotificationClientKey: TestDependencyKey {
  public static var testValue: AMDNotificationClientProtocol {
    fatalError("\(AMDNotificationClientProtocol.self)")
  }
}

// MARK: - DependencyValues

public extension DependencyValues {
  var notificationClient: AMDNotificationClientProtocol {
    get { self[AMDNotificationClientKey.self] }
    set { self[AMDNotificationClientKey.self] = newValue }
  }
}
