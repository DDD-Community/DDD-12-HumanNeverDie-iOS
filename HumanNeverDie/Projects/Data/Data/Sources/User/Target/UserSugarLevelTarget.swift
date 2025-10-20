//
//  UserSugarLevelTarget.swift
//  Data
//
//  Created by Seulki Lee on 10/20/25.
//

import Foundation

import BaseNetwork
import UserDomain

struct UserSugarLevelTarget: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<UserSugarLevelResponse>
  
  private let userID: String
  
  init(userID: String) {
    self.userID = userID
  }
  
  var path: String {
    return "/members/\(userID)/sugar"
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



