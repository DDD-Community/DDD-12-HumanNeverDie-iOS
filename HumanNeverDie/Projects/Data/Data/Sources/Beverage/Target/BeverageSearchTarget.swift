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
  private let sugarLevel: String?
  private let onlyLiked: Bool
  
  init(
    keyword: String,
    sugarLevel: String? = nil,
    onlyLiked: Bool = false
  ) {
    self.keyword = keyword
    self.sugarLevel = sugarLevel
    self.onlyLiked = onlyLiked
  }
  
  typealias Response = AMDAPIResponse<BeverageSearchResponse>
  
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
    
    if let sugarLevel {
      parameters.updateValue(sugarLevel, forKey: "sugarLevel")
    }
    
    if onlyLiked {
      parameters.updateValue("true", forKey: "onlyLiked")
    }
    
    return parameters
  }
  
  var body: Encodable? {
    return nil
  }
}
