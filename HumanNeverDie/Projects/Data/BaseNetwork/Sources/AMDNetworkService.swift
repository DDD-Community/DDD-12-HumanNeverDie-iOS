//
//  AMDNetworkService.swift
//  BaseNetwork
//
//  Created by Seulki Lee on 6/8/25.
//

import Foundation

import Alamofire
import Shared
import Dependencies

public protocol AMDNetworkServiceProtocol: Sendable {
  func requestDDD<R: AMDAPIRequestable>(_ target: R) async throws(AMDNetworkError) -> R.Response
}

public final class AMDNetworkService: AMDNetworkServiceProtocol, @unchecked Sendable {
  private let session: Session
  private let decoder: JSONDecoder = JSONDecoder()
  
  public init(timeout: TimeInterval = 5, withAuth: Bool = false) {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = timeout
    let logger = AMDNetworkLogger()
    
    @Dependency(\.keychainClient) var keychainClient
    let interceptor = withAuth ? AMDNetworkService.createAuthInterceptor(keychainClient) : nil
    
    self.session = Session(
      configuration: configuration,
      interceptor: interceptor,
      eventMonitors: [logger]
    )
  }
    
  public func requestDDD<R: AMDAPIRequestable>(_ target: R) async throws(AMDNetworkError) -> R.Response {
    let dataTask = session.request(try target.asURLRequest())
      .validate()
      .serializingData()
    
    let response = await dataTask.response
    
    switch response.result {
    case .success(let data):
      do {
        let result = try decoder.decode(R.Response.self, from: data)
        return result
      } catch {
        throw handleAMDNetworkError(error)
      }
      
    case .failure(let error):
      if let serverError = parseServerError(from: response.data) {
        print(serverError)
        throw AMDNetworkError.api(serverError)
      }
            
      throw handleAMDNetworkError(error)
    }
  }
}

private extension AMDNetworkService {
  func parseServerError(from data: Data?) -> AMDAPIError? {
    guard let data = data,
          let apiError = try? decoder.decode(AMDAPIError.self, from: data) else {
      return nil
    }
    return apiError
  }
}
 
private extension AMDNetworkService {
  func handleAMDNetworkError(_ error: Error) -> AMDNetworkError {
    guard let afError = error.asAFError else {
      return .unknown(error)
    }
    
    switch afError {
    case .parameterEncodingFailed(let reason):
      switch reason {
      case .missingURL:
        return .parameterEncodingError(afError)
        
      case .jsonEncodingFailed(error: let parameterError), .customEncodingFailed(error: let parameterError):
        return .parameterEncodingError(parameterError)
      }
      
    case .responseValidationFailed(let reason):
      switch reason {
      case .unacceptableStatusCode(let code):
        return .responseValidationFailed(statusCode: code)
        
      default:
        return .unknown(afError)
      }
      
    case .responseSerializationFailed(let reason):
      switch reason {
      case .decodingFailed(let decodeError):
        return .decodingFailed(decodeError)
      default:
        return .decodingFailed(afError)
      }
      
    case .sessionTaskFailed(let error):
      guard let urlError = error as? URLError else {
        return .unknown(afError)
      }
      
      switch urlError.code {
      case .timedOut:
        return .timeout
        
      case .notConnectedToInternet, .networkConnectionLost:
        return .notConnectedNetwork
        
      default:
        return .unknown(error)
      }
      
    default:
      return .unknown(error)
    }
  }
}

// MARK: - Private Methods

private extension AMDNetworkService {
  static func createAuthInterceptor(_ keychainClient: AMDKeychainClientProtocol) -> AuthenticationInterceptor<AMDAuthenticator> {
    let authenticator = AMDAuthenticator()
    
    guard let accessToken = keychainClient.getValue(forKey: AMDKeychainKey.accessToken),
          let refreshToken = keychainClient.getValue(forKey: AMDKeychainKey.refreshToken),
          let expiresInString = keychainClient.getValue(forKey: AMDKeychainKey.expiresIn),
          let expiresInTimeInterval = Double(expiresInString) else {
      return AuthenticationInterceptor(authenticator: authenticator)
    }
    
    let initialCredential = AppleAuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      idToken: "",
      expiresIn: Date(timeIntervalSince1970: expiresInTimeInterval)
    )
    
    return AuthenticationInterceptor(authenticator: authenticator, credential: initialCredential)
  }
}

// MARK: - TestDependencyKey

public struct AMDNetworkServiceKey: TestDependencyKey {
  public static var testValue: AMDNetworkServiceProtocol {
    fatalError("\(AMDNetworkServiceProtocol.self) Implementation not available")
  }
}

// MARK: - DependencyValues

public extension DependencyValues {
  var networkService: AMDNetworkServiceProtocol {
    get { self[AMDNetworkServiceKey.self] }
    set { self[AMDNetworkServiceKey.self] = newValue }
  }
}
