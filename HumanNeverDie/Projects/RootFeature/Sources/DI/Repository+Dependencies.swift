//
//  Repository+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 6/17/25.
//

import Data
import BeverageDomain

import Dependencies

// MARK: - BeverageRepository

extension BeverageRepositoryKey: @retroactive DependencyKey {
  public static let liveValue: BeverageRepositoryInterface = BeverageRepository()
}

// MARK: - BeverageLikeLocalRepository

extension BeverageLikeLocalRepositoryKey: @retroactive DependencyKey {
  public static let liveValue: BeverageLikeLocalRepositoryInterface = BeverageLikeLocalRepository()
}
