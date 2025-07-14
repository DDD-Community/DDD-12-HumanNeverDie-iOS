//
//  BeverageDetailTarget.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BaseNetwork

struct BeverageDetailTarget: AMDAPIRequestable {
  private let productID: String
  
  init(productID: String) {
    self.productID = productID
  }
  
  typealias Response = AMDAPIResponse<BeverageDetailResponse>
  
  var path: String {
    return "/cafe-beverages/\(productID)"
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
