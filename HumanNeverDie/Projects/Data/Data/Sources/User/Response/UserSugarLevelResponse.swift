//
//  UserSugarLevelResponse.swift
//  Data
//
//  Created by Seulki Lee on 10/20/25.
//

import Foundation
import UserDomain

struct UserSugarLevelResponse: Decodable {
  let message: String
  let status: Int
  let data: SugarDataResponse
}

struct SugarDataResponse: Decodable {
  let easy: SugarLevelResponse
  let normal: SugarLevelResponse
  let hard: SugarLevelResponse
}

struct SugarLevelResponse: Decodable {
  let sugarMaxG: Int
  let sugarIdealG: Int
}

extension UserSugarLevelResponse {
  func toDomain() -> UserSugarLevel {
    return UserSugarLevel(
      message: message,
      status: status,
      data: data.toDomain()
    )
  }
}

extension SugarDataResponse {
  func toDomain() -> SugarData {
    return SugarData(
      easy: easy.toDomain(),
      normal: normal.toDomain(),
      hard: hard.toDomain()
    )
  }
}

extension SugarLevelResponse {
  func toDomain() -> SugarLevel {
    return SugarLevel(
      sugarMaxG: sugarMaxG,
      sugarIdealG: sugarIdealG
    )
  }
}
