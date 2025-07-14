//
//  BeverageCountTarget.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BaseNetwork

struct BeverageCountTarget: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<BeverageCountResponse>
  
  var path: String {
    return "/cafe-beverages/count"
  }
  
  var method: AMDHTTPMethod {
    return .GET
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var queryParameters: [String : String]? {
    return nil
  }
  
  var body: Encodable? {
    return nil
  }
}
