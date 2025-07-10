//
//  BeverageRepositoryInterface.swift
//  BeverageDomain
//
//  Created by 김규철 on 2025/07/02.
//

import Foundation

public protocol BeverageRepositoryInterface {
  func getBeverageCount() async throws -> BeverageCount
}
