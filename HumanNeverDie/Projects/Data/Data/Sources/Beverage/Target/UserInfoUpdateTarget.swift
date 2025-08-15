//
//  UserInfoUpdateTarget.swift
//  Data
//
//  Created by Seulki Lee on 8/15/25.
//

import Foundation

import BaseNetwork
import UserDomain
import Shared

struct UserInfoUpdateTarget: AMDAPIRequestable {
  typealias Response = AMDAPIResponse<UserInfoUpdateResponse>
  
  private let userID: String
  private var userInfo: UserInfo
  
  init(userID: String, userInfo: UserInfo) {
    self.userID = userID
    self.userInfo = userInfo
    
  }
  
  var path: String {
    return "/members/\(userID)"
  }
  
  var method: AMDHTTPMethod {
    return .PATCH
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var queryParameters: [String: String]? {
    return nil
  }
  
  var body: Encodable? {
    let request = UserRecordRequest(nickname: userInfo.nickname, birthDay: userInfo.birthDate, gender: userInfo.selectedGender.rawValue, heightCm: userInfo.height, weightKg: userInfo.weight, activityRange: userInfo.selectedActivity.rawValue, sugarIntakeLevel: userInfo.selectedDailySugarGoal.rawValue)
    
    return request
  }
}


