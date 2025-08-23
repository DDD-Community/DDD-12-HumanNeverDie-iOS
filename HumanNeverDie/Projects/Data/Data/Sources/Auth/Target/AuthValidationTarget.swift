//
//  AuthValidationTarget.swift
//  Data
//
//  Created by Claude on 8/21/25.
//

import Foundation

import BaseNetwork

struct AuthValidationTarget: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<AuthValidationResponse>
  
  var path: String {
    return "/auth/me"
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
