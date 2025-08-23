//
//  BeverageDailyCalenderTarget.swift
//  Data
//
//  Created by Seulki Lee on 8/22/25.
//

import Foundation

import BaseNetwork
import BeverageDomain

struct BeverageDailyCalenderTarget: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<BeverageCalendarResponse>
  
  private let dailyDate: String?
  
  init(
    dailyDate: String? = nil
  ) {
    self.dailyDate = dailyDate
  }
  
  var path: String {
    return "/intake-histories/daily"
  }
  
  var method: AMDHTTPMethod {
    return .GET
  }
  
  var headers: [String : String]? {
    nil
  }
  
  var queryParameters: [String : String]? {
    guard let dailyDate else { return [:] }
    return ["intakeTime": dailyDate]
  }
  
  var body: Encodable? {
    return nil
  }
}
