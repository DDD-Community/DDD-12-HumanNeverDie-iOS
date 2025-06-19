//
//  UseCase+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 6/17/25.
//

import MainDomain

import Dependencies

// MARK: - MainUseCaseKey

extension MainUseCaseKey: @retroactive DependencyKey {
  public static let liveValue: MainUseCaseProtocol = MainUseCase()
}
