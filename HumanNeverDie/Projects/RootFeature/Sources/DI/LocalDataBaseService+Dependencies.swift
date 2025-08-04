//
//  LocalDataBaseService+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 7/31/25.
//

import SwiftData

import Data
import LocalDataBase

import Dependencies

// MARK: - AMDLocalDataBaseService

extension AMDLocalDataBaseServiceKey: @retroactive DependencyKey {
  public static let liveValue: AMDLocalDataBaseServiceProtocol = AMDLocalDataBaseService(container: ModelContainer.aMatdangLocalDataBase)
}
