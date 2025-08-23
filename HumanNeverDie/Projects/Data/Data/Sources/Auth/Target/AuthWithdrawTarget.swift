//
//  AuthWithdrawTarget.swift
//  Data
//
//  Created by Claude on 8/22/25.
//

import Foundation

import BaseNetwork

struct AuthWithdrawTarget: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<AuthWithdrawResponse>
  
  var path: String {
    return "/auth/withdraw"
  }
  
  var method: AMDHTTPMethod {
    return .GET
  }
  
  var headers: [String : String]? {
    return AMDHeader.authorization()
  }
  
  var queryParameters: [String : String]? {
    return nil
  }
  
  var body: Encodable? {
    return nil
  }
}
