//
//  BeverageUseCase.swift
//  BeverageDomain
//
//  Created by 김규철 on 2025/07/02.
//

import Foundation

public protocol BeverageUseCaseProtocol {
    // Add your use case methods here
}

public final class BeverageUseCase: BeverageUseCaseProtocol {
    private let repository: BeverageRepositoryInterface
    
    public init(repository: BeverageRepositoryInterface) {
        self.repository = repository
    }
    
    // Implement your use case methods here
} 
