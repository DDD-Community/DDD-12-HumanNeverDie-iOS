//
//  FCMTokenTarget.swift
//  Data
//
//  Created by Claude on 2025.
//

import Foundation

import BaseNetwork

struct FCMTokenTarget: AMDAPIRequestable {
  typealias Response = AMDEmptyResponse

  private let userID: String
  private let fcmToken: String

  init(userID: String, fcmToken: String) {
    self.userID = userID
    self.fcmToken = fcmToken
  }

  var path: String {
    return "/members/\(userID)/fcm-token"
  }

  var method: AMDHTTPMethod {
    return .PATCH
  }

  var headers: [String : String]? {
    return nil
  }

  var queryParameters: [String: String]? {
    return nil
  }

  var body: Encodable? {
    return FCMTokenRequest(fcmToken: fcmToken)
  }
}
