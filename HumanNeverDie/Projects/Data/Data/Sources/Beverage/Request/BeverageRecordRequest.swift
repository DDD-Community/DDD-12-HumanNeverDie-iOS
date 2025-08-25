//
//  BeverageRecordRequest.swift
//  Data
//
//  Created by 김규철 on 7/28/25.
//

import Foundation

struct BeverageRecordRequest: Encodable {
  let productId: String
  let intakeTime: String
  let size: String
}

struct BeverageDeleteRequest: Encodable {
  let intakeTime: String
}
