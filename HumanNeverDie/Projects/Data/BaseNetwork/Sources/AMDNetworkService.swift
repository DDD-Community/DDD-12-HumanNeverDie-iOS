//
//  AMDNetworkService.swift
//  BaseNetwork
//
//  Created by Seulki Lee on 6/8/25.
//

import Foundation
import Alamofire

public protocol AMDNetworkService {
  func request<Response: Decodable>(_ target: AMDAPIRequestable, as type: Response.Type) async throws -> Response
  func requestDDD<Response: Decodable>(_ target: AMDAPIRequestable, as type: Response.Type) async throws -> Response
  func request(_ target: AMDAPIRequestable) async throws
}

public final class DefaultNetworkService: AMDNetworkService {
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
    let statusCode = response.response?.statusCode ?? -1
    
    switch response.result {
    case .success(let data):
      do {
        return try decoder.decode(Response.self, from: data)
      } catch {
        throw AppError.network(statusCode: statusCode)
      }
      
    case .failure(let error):
      if let urlError = error.underlyingError as? URLError,
         urlError.code == .timedOut {
        throw AppError.network(statusCode: NetworkStatusCode.timeout)
      } else {
        throw AppError.network(statusCode: statusCode)
      }
    }
  }
  
  public func request(_ target: AMDAPIRequestable) async throws {
    let dataTask = session.request(try target.asURLRequest())
      .validate()
      .serializingData()
    
    let response = await dataTask.response
    let statusCode = response.response?.statusCode ?? -1
    
    switch response.result {
    case .success:
      return
      
    case .failure(let error):
      if let urlError = error.underlyingError as? URLError,
         urlError.code == .timedOut {
        throw AppError.network(statusCode: NetworkStatusCode.timeout)
      } else {
        throw AppError.network(statusCode: statusCode)
      }
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
    let statusCode = response.response?.statusCode ?? -1
    
    switch response.result {
    case .success(let data):
      do {
        let decoded = try decoder.decode(AMDAPIResponse<Response>.self, from: data)
        
        if let result = decoded.data {
          return result
        } else {
          throw AppError.network(statusCode: NetworkStatusCode.emptyResponse)
        }
        
      } catch {
        if let apiError = try? decoder.decode(AMDAPIError.self, from: data) {
          throw apiError
        } else {
          throw AppError.network(statusCode: statusCode)
        }
      }
      
    case .failure(let error):
      if let urlError = error.underlyingError as? URLError,
         urlError.code == .timedOut {
        throw AppError.network(statusCode: NetworkStatusCode.timeout)
      } else {
        throw AppError.network(statusCode: statusCode)
      }
    }
  }
}

