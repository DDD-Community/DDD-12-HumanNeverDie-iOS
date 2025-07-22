//
//  UserUseCase.swift
//  UserDomain
//
//  Created by Seulki Lee on 2025/07/20.
//

import Foundation

public protocol UserUseCaseProtocol: Sendable {
    // Add your use case methods here
}

public final class UserUseCase: UserUseCaseProtocol, @unchecked Sendable {
    private let repository: UserRepositoryInterface
    
    public init(repository: UserRepositoryInterface) {
        self.repository = repository
    }
    
    // Implement your use case methods here
} 
