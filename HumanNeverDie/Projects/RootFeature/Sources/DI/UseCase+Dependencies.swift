//
//  UseCase+Dependencies.swift
//  RootFeature
//
//  Created by 김규철 on 6/17/25.
//

import MainDomain

import Dependencies

// MARK: - MainRepository

extension MainUseCaseKey: @retroactive DependencyKey {
  public static var liveValue: MainUseCaseProtocol = MainUseCase()
}
