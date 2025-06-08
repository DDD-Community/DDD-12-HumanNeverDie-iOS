//
//  NetworkError.swift
//  BaseNetwork
//
//  Created by Seulki Lee on 6/8/25.
//

import Foundation

public enum NetworkError: Error {
    case failed(retryable: Bool, statusCode: Int)
}

