//
//  APIRequestable.swift
//  BaseNetwork
//
//  Created by Seulki Lee on 6/8/25.
//

import Foundation

public protocol APIRequestable {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var queryParameters: [String: String]? { get }
  var body: Encodable? { get }
  
  func asURLRequest() throws -> URLRequest
}

public extension APIRequestable {
  func asURLRequest() throws -> URLRequest {
    var urlComponents = URLComponents(string: baseURL + path)
    if let queryParameters = queryParameters {
      urlComponents?.queryItems = queryParameters.map {
        URLQueryItem(name: $0.key, value: $0.value)
      }
    }
    
    guard let url = urlComponents?.url else {
      throw AppError.network(statusCode: NetworkStatusCode.urlError)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    headers?.forEach {
      request.setValue($0.value, forHTTPHeaderField: $0.key)
    }
    
    if let body = body {
      request.httpBody = try JSONEncoder().encode(body)
    }
    
    return request
  }
}

