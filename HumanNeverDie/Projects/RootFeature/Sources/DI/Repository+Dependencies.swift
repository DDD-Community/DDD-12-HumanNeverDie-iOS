//
//  Repository+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 6/17/25.
//

import Data
import MainDomain

import Dependencies

// MARK: - MainRepository

extension MainRepositoryKey: @retroactive DependencyKey {
  public static let liveValue: MainRepositoryInterface = MainRepository()
}
