//
//  BeverageWeeklyCalenderTarget.swift
//  Data
//
//  Created by 김규철 on 8/11/25.
//

import Foundation

import BaseNetwork
import BeverageDomain

struct BeverageWeeklyCalenderTarget: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<[BeverageCalendarResponse]>
  
  private let dateInWeek: String?
  
  init(
    dateInWeek: String? = nil
  ) {
    self.dateInWeek = dateInWeek
  }
  
  var path: String {
    return "/intake-histories/weekly"
  }
  
  var method: AMDHTTPMethod {
    return .GET
  }
  
  var headers: [String : String]? {
    nil
  }
  
  var queryParameters: [String : String]? {
    guard let dateInWeek else { return [:] }
    return ["dateInWeek": dateInWeek]
  }
  
  var body: Encodable? {
    return nil
  }
}
