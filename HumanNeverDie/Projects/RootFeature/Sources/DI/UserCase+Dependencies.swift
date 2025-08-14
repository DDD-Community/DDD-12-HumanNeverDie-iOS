//
//  UserCase+Dependencies.swift
//  RootFeature
//
//  Created by Seulki Lee on 8/14/25.
//

import Foundation
import Dependencies
import UserDomain

// MARK: - UserUseCase
extension UserUseCaseKey: @retroactive DependencyKey {
    public static let liveValue: UserUseCaseProtocol = UserUseCase()
}
