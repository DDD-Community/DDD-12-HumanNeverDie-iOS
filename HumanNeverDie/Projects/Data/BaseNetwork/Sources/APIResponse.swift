//
//  APIResponse.swift
//  BaseNetwork
//
//  Created by Seulki Lee on 6/11/25.
//

import Foundation

public struct APIResponse<T: Decodable>: Decodable {
    public let code: String
    public let status: Int
    public let data: T?
}
