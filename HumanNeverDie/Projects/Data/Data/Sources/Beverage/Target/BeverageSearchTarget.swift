//
//  BeverageSearchTarget.swift
//  Data
//
//  Created by 김규철 on 7/25/25.
//

import Foundation

import BaseNetwork

struct BeverageSearchTarget: AMDAPIRequestable {
  private let keyword: String
  
  init(keyword: String) {
    self.keyword = keyword
  }
  
  typealias Response = AMDAPIResponse<BeverageListResponse>
  
  var path: String {
    return "/cafe-beverages/search"
  }
  
  var method: AMDHTTPMethod {
    return .GET
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var queryParameters: [String : String]? {
    var parameters: [String : String] = [:]
    
    parameters.updateValue(keyword, forKey: "keyword")
    return parameters
  }
  
  var body: Encodable? {
    return nil
  }
}
