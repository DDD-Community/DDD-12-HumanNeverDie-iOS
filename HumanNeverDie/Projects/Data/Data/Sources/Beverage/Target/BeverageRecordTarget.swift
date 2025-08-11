//
//  BeverageRecordTarget.swift
//  Data
//
//  Created by 김규철 on 7/28/25.
//

import Foundation

import BaseNetwork

struct BeverageRecordTarget: AMDAPIRequestable {
  private let productID: String
  private let recordDate: Date
  
  init(productID: String, recordDate: Date) {
    self.productID = productID
    self.recordDate = recordDate
  }
  
  typealias Response = AMDAPIResponse<AMDEmptyResponse>
  
  var path: String {
    return "/intake-histories"
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
    let request = BeverageRecordRequest(productId: productID, intakeTime: recordDate.ISO8601Format())
    
    return request
  }
}
