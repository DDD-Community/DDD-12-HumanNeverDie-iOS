//
//  UserNotificationsTarget.swift
//  Data
//
//  Created by Seulki Lee on 8/15/25.
//

import Foundation

import BaseNetwork
import UserDomain

struct UserNotificationsTarget: AMDAPIRequestable {
    typealias Response = AMDAPIResponse<UserNotificationsResponse>
    
    private let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    
    var path: String {
        return "/members/\(userID)/notification-settings"
    }
    
    var method: AMDHTTPMethod {
        return .GET
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var queryParameters: [String: String]? {
        return nil
    }
    
    var body: Encodable? {
        return nil
    }
}


