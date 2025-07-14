//
//  BeverageListTarget.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BaseNetwork

struct BeverageListTarget: AMDAPIRequestable {
  private let cursor: String?
  private let size: Int
  
  init(
    cursor: String? = nil,
    size: Int = 15
  ) {
    self.cursor = cursor
    self.size = size
  }
  
  typealias Response = AMDAPIResponse<BeverageListResponse>
  
  var path: String {
    return "/cafe-beverages"
  }
  
  var method: AMDHTTPMethod {
    return .GET
  }
  
  var headers: [String : String]? {
    nil
  }
  
  var queryParameters: [String : String]? {
    var parameters: [String : String] = [:]
    
    if let cursor {
      parameters.updateValue(cursor, forKey: "cursor")
    }
    
    parameters.updateValue("\(size)", forKey: "size")
    return parameters
  }
  
  var body: Encodable? {
    return nil
  }
}
