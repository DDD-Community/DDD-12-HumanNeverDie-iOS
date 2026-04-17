//
//  UseCase+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 6/17/25.
//

import AuthDomain
import BeverageDomain
import UserDomain

import Dependencies

// MARK: - AuthUseCase

extension AuthUseCase: @retroactive DependencyKey {
  public static var liveValue: AuthUseCase { .live }
}

// MARK: - BeverageUseCase

extension BeverageUseCase: @retroactive DependencyKey {
  public static var liveValue: BeverageUseCase { .live }
}

// MARK: - BeverageLocalLikeUseCase

extension BeverageLocalLikeUseCase: @retroactive DependencyKey {
  public static var liveValue: BeverageLocalLikeUseCase { .live }
}

// MARK: - BeverageLocalSearchUseCase

extension BeverageLocalSearchUseCase: @retroactive DependencyKey {
  public static var liveValue: BeverageLocalSearchUseCase { .live }
}

// MARK: - UserUseCase

extension UserUseCase: @retroactive DependencyKey {
  public static var liveValue: UserUseCase { .live }
}
