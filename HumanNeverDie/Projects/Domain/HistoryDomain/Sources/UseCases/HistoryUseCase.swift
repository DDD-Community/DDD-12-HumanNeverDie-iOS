//
//  HistoryUseCase.swift
//  HistoryDomain
//
//  Created by Seulki Lee on 2025/07/30.
//

import Foundation

public protocol HistoryUseCaseProtocol: Sendable {
    // Add your use case methods here
}

public final class HistoryUseCase: HistoryUseCaseProtocol, @unchecked Sendable {
    private let repository: HistoryRepositoryInterface
    
    public init(repository: HistoryRepositoryInterface) {
        self.repository = repository
    }
    
    // Implement your use case methods here
} 
