//
//  BeverageMonthCalenderTarget.swift
//  Data
//
//  Created by Seulki Lee on 8/1/25.
//

import Foundation

import BaseNetwork
import BeverageDomain

struct BeverageMonthCalenderTarget: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<[BeverageCalendarResponse]>
  
  private let dateInMonth: String?
  
  init(
    dateInMonth: String? = nil,
  ) {
    self.dateInMonth = dateInMonth
  }

  
  var path: String {
    return "/intake-histories/monthly?"
  }
  
  var method: AMDHTTPMethod {
    return .GET
  }
  
  var headers: [String : String]? {
    nil
  }
  
  var queryParameters: [String : String]? {
    guard let dateInMonth else { return [:] }
    return ["dateInMonth": dateInMonth]
  }
  
  var body: Encodable? {
    return nil
  }
}

