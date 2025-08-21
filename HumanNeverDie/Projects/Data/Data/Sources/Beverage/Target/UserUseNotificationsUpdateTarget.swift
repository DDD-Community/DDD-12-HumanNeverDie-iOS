//
//  UserUseNotificationsUpdateTarget.swift
//  Data
//
//  Created by Seulki Lee on 8/22/25.
//

import Foundation

import BaseNetwork
import UserDomain

struct NotificationUpdateTarget: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<UserNotificationsResponse>
  
  private let userID: String
  private let isEnabled: Bool
  
  init(userID: String, isEnabled: Bool) {
    self.userID = userID
    self.isEnabled = isEnabled
  }
  
  var path: String {
    return "/members/\(userID)/notification-settings"
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
    let request = NotificationsRequest(
      isEnabled: isEnabled)
    
    return request
  }
}


