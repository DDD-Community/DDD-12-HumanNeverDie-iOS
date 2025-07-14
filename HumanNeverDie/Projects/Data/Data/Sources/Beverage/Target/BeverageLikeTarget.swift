//
//  BeverageLikeTarget.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BaseNetwork

struct BeverageLikeTarget: AMDAPIRequestable {
  private let productID: String
  
  init(productID: String) {
    self.productID = productID
  }
  
  typealias Response = AMDAPIResponse<BeverageLikeResponse>
  
  var path: String {
    return "/cafe-beverages/\(productID)/like"
  }
  
  var method: AMDHTTPMethod {
    return .POST
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
