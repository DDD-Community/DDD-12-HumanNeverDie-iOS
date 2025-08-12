//
//  BeverageDeleteTarget.swift
//  Data
//
//  Created by Seulki Lee on 8/12/25.
//

import Foundation

import BaseNetwork
import BeverageDomain

struct BeverageDelete: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<String>
  
  private let productID: String
  private let intakeTime: String
  
  init(
    productID: String = "",
    intakeTime: String = ""
  ) {
    self.productID = productID
    self.intakeTime = intakeTime
  }
  
  var path: String {
    return "/intake-histories/\(productID)"
  }
  
  var method: AMDHTTPMethod {
    return .DELETE
  }
  
  var headers: [String : String]? {
    nil
  }
  
  var queryParameters: [String : String]? {
    return nil
  }
  
  var body: Encodable? {
    let request = BeverageDeleteRequest(intakeTime: intakeTime)
    
    return request
  }
}
