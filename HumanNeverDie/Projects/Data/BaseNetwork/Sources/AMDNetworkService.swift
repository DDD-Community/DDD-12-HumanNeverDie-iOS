//
//  AMDNetworkService.swift
//  BaseNetwork
//
//  Created by Seulki Lee on 6/8/25.
//

import Foundation

import Alamofire
import Dependencies

public protocol AMDNetworkServiceProtocol {
  func request<Response: Decodable>(_ target: AMDAPIRequestable, as type: Response.Type) async throws -> Response
  func requestDDD<Response: Decodable>(_ target: AMDAPIRequestable, as type: Response.Type) async throws -> Response
  func request(_ target: AMDAPIRequestable) async throws
}

public final class AMDNetworkService: AMDNetworkServiceProtocol {
  private let session: Session
  private let decoder: JSONDecoder = JSONDecoder()
  
  public init(timeout: TimeInterval = 5) {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = timeout
    self.session = Session(configuration: configuration)
  }
  
  // 테스트용 / 외부 API 용도
  public func request<Response: Decodable>(
    _ target: AMDAPIRequestable,
    as type: Response.Type
  ) async throws -> Response {
    let dataTask = session.request(try target.asURLRequest())
      .validate()
      .serializingData()
    
    let response = await dataTask.response
    
    switch response.result {
    case .success(let data):
      do {
        return try decoder.decode(Response.self, from: data)
      } catch {
        throw handleAMDNetworkError(error)
      }
      
    case .failure(let error):
      throw handleAMDNetworkError(error)
    }
  }
  
  public func request(_ target: AMDAPIRequestable) async throws {
    let dataTask = session.request(try target.asURLRequest())
      .validate()
      .serializingData()
    
    let response = await dataTask.response
    
    switch response.result {
    case .success:
      return
      
    case .failure(let error):
      if let serverError = parseServerError(from: response.data) {
        throw AMDNetworkError.api(serverError)
      }
      
      throw handleAMDNetworkError(error)
    }
  }
  
  // ✅ 실사용용 (서버 공통 응답 포맷 사용)
  public func requestDDD<Response: Decodable>(
    _ target: AMDAPIRequestable,
    as type: Response.Type
  ) async throws -> Response {
    let dataTask = session.request(try target.asURLRequest())
      .validate()
      .serializingData()
    
    let response = await dataTask.response
    
    switch response.result {
    case .success(let data):
      do {
        let decoded = try decoder.decode(AMDAPIResponse<Response>.self, from: data)
        
        guard let result = decoded.data else {
          throw AMDNetworkError.emptyResponse
        }
        
        return result
      } catch {
        throw handleAMDNetworkError(error)
      }
      
    case .failure(let error):
      if let serverError = parseServerError(from: response.data) {
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
