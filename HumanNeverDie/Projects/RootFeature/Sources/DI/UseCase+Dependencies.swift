//
//  UseCase+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 6/17/25.
//

import BeverageDomain

import Dependencies

// MARK: - BeverageUseCase

extension BeverageUseCaseKey: @retroactive DependencyKey {
  public static let liveValue: BeverageUseCaseProtocol = BeverageUseCase()
}

// MARK: - BeverageLocalLikeUseCase

extension BeverageLocalLikeUseCaseKey: @retroactive DependencyKey {
  public static let liveValue: BeverageLocalLikeUseCaseProtocol = BeverageLocalLikeUseCase()
}

// MARK: - BeverageLocalSearchUseCase

extension BeverageLocalSearchUseCaseKey: @retroactive DependencyKey {
  public static let liveValue: BeverageLocalSearchUseCaseProtocol = BeverageLocalSearchUseCase()
}
