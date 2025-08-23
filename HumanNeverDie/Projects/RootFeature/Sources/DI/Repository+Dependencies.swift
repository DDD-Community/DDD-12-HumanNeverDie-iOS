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

extension AuthRepositoryInterfaceKey: @retroactive DependencyKey {
  public static let liveValue: AuthRepositoryInterface = AuthRepository()
}

// MARK: - BeverageRepository

extension BeverageRepositoryKey: @retroactive DependencyKey {
  public static let liveValue: BeverageRepositoryInterface = BeverageRepository()
}

// MARK: - BeverageLikeLocalRepository

extension BeverageLikeLocalRepositoryKey: @retroactive DependencyKey {
  public static let liveValue: BeverageLikeLocalRepositoryInterface = BeverageLikeLocalRepository()
}


extension UserRepositoryKey: @retroactive DependencyKey {
  public static let liveValue: UserRepositoryInterface = UserRepository()
}
