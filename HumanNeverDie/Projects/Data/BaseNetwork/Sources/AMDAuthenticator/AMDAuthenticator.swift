//
//  AMDAuthenticator.swift
//  BaseNetwork
//
//  Created by 김규철 on 8/22/25.
//

import Foundation

import Shared

import Alamofire
import Dependencies

public final class AMDAuthenticator: Authenticator, @unchecked Sendable {
  public typealias Credential = AppleAuthToken
  
  @Dependency(\.appleLoginManager) private var appleLoginManager
  @Dependency(\.keychainClient) private var keychainClient
  
  public init() {}
  
  public func apply(_ credential: AppleAuthToken, to urlRequest: inout URLRequest) {
    urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
  }
  
  public func refresh(_ credential: AppleAuthToken,
                      for session: Session,
                      completion: @escaping @Sendable (Result<AppleAuthToken, Error>) -> Void) {
    Task {
      do {
        let newCredential = try await appleLoginManager.refreshCredentials()
        
        try await keychainClient.setValue(newCredential.accessToken, forKey: AMDKeychainKey.accessToken)
        if let newRefreshToken = newCredential.refreshToken {
          try await keychainClient.setValue(newRefreshToken, forKey: AMDKeychainKey.refreshToken)
        }
        
        try await keychainClient.setValue(String(newCredential.expiresIn.timeIntervalSince1970), forKey: AMDKeychainKey.expiresIn)
        
        completion(.success(newCredential))
      } catch {
        try? await keychainClient.removeAll()
        
        NotificationCenter.default.post(name: .tokenRefreshFailed, object: nil)
        
        completion(.failure(error))
      }
    }
  }
  
  public func didRequest(_ urlRequest: URLRequest,
                         with response: HTTPURLResponse,
                         failDueToAuthenticationError error: Error) -> Bool {
    return response.statusCode == 401
  }
  
  public func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: AppleAuthToken) -> Bool {
    let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
    return urlRequest.headers["Authorization"] == bearerToken
  }
}

