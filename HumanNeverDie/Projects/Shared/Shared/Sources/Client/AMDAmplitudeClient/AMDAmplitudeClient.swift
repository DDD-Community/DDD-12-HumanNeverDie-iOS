//
//  AMDAmplitudeClient.swift
//  Shared
//
//  Created by 김규철 on 9/22/25.
//

import Foundation

@preconcurrency import AmplitudeSwift
import Dependencies

public protocol AMDAmplitudeClientProtocol: Sendable {
  func track(event: AmplitudeEvent, eventProperties: [String: Any]?)
  func setUserId(_ userId: String?)
  func setDeviceId(_ deviceId: String)
}

public struct AMDAmplitudeClient: AMDAmplitudeClientProtocol {
  private let amplitude: Amplitude?
  private let logger = OSLogger()
  
  public init() {
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "AMPLITUDE_API_KEY") as? String else {
      logger.error(message:"⚠️ AMPLITUDE_API_KEY not found in Info.plist, Amplitude tracking disabled")
      self.amplitude = nil
      return
    }
    
    let amplitude = Amplitude(configuration: Configuration(
      apiKey: apiKey,
      autocapture: .all
    ))
    self.amplitude = amplitude
  }
  
  public func track(event: AmplitudeEvent, eventProperties: [String: Any]?) {
    #if DEBUG
    logger.debug(message: "🔍 [DEBUG] Amplitude track - \(event.rawValue)")
    #else
    amplitude?.track(eventType: event.rawValue, eventProperties: eventProperties)
    #endif
  }
  
  public func setUserId(_ userId: String?) {
    #if DEBUG
    logger.debug(message: "🔍 [DEBUG] Amplitude setUserId - \(userId ?? "nil")")
    #else
    amplitude?.setUserId(userId: userId)
    #endif
  }
  
  public func setDeviceId(_ deviceId: String) {
    #if DEBUG
    logger.debug(message: "🔍 [DEBUG] Amplitude setDeviceId - \(deviceId)")
    #else
    amplitude?.setDeviceId(deviceId: deviceId)
    #endif
  }
}

// MARK: - TestDependencyKey

public struct AMDAmplitudeClientKey: TestDependencyKey {
  public static var testValue: AMDAmplitudeClientProtocol {
    fatalError("\(AMDAmplitudeClientProtocol.self) Implementation not available")
  }
}

// MARK: - DependencyValues

public extension DependencyValues {
  var amplitudeClient: AMDAmplitudeClientProtocol {
    get { self[AMDAmplitudeClientKey.self] }
    set { self[AMDAmplitudeClientKey.self] = newValue }
  }
}
