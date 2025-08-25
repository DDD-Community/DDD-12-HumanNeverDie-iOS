//
//  UserNotificationsUpdateTarget.swift
//  Data
//
//  Created by Seulki Lee on 8/16/25.
//

import Foundation

import BaseNetwork
import UserDomain

struct UserNotificationsUpdateTarget: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<UserNotificationsResponse>
  
  private let userID: String
  private let userNotifications : UserNotifications
  
  init(userID: String, userNotifications: UserNotifications) {
    self.userID = userID
    self.userNotifications = userNotifications
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
    let request = UserNotificationsRequest(
      isEnabled: userNotifications.isEnabled,
      remindersEnabled: userNotifications.remindersEnabled,
      reminderTime: userNotifications.reminderTime,
      riskWarningsEnabled: userNotifications.riskWarningsEnabled,
      newsUpdatesEnabled: userNotifications.newsUpdatesEnabled)
    
    return request
  }
}


