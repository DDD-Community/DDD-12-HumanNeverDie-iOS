//
//  UserInfoTarget.swift
//  Data
//
//  Created by Seulki Lee on 8/12/25.
//

import Foundation

import BaseNetwork
import UserDomain

struct UserInfoTarget: AMDAPIRequestable {
    typealias Response = AMDAPIResponse<UserInfoResponse>
    
    private let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    
    var path: String {
        return "/members/\(userID)"
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


