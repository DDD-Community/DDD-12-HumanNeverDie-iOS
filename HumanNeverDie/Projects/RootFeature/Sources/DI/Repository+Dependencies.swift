//
//  Repository+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 6/17/25.
//

import Data
import AuthDomain
import BeverageDomain
import UserDomain

import Dependencies

// MARK: - AuthRepository

extension AuthRepositoryInterface: @retroactive DependencyKey {
  public static var liveValue: AuthRepositoryInterface { .live }
}

// MARK: - BeverageRepository

extension BeverageRepositoryInterface: @retroactive DependencyKey {
  public static var liveValue: BeverageRepositoryInterface { .live }
}

// MARK: - BeverageLikeLocalRepository

extension BeverageLikeLocalRepositoryInterface: @retroactive DependencyKey {
  public static var liveValue: BeverageLikeLocalRepositoryInterface { .live }
}

// MARK: - UserRepository

extension UserRepositoryInterface: @retroactive DependencyKey {
  public static var liveValue: UserRepositoryInterface { .live }
}
