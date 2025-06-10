//
//  APIError.swift
//  BaseNetwork
//
//  Created by Seulki Lee on 6/8/25.
//

import Foundation

public struct APIError: Decodable, Error {
  public let code: String
  public let status: Int
  public let message: String
  public let path: String?
  public let timestamp: String?
  
  public var codeType: APIErrorCode {
    return APIErrorCode(rawStatus: status)
  }
}

public enum AppError: Error {
  case network(retryable: Bool, statusCode: Int)
  case api(APIError)
  case unknown(Error)
  
  public var userMessage: String {
    switch self {
    case .api(let apiError):
      return apiError.codeType.userMessage
    case .network(_, let code):
      return "네트워크 오류가 발생했습니다 (\(code)). 잠시 후 다시 시도해주세요."
    case .unknown:
      return "알 수 없는 오류가 발생했어요."
    }
  }
  
  public var statusCode: Int? {
    switch self {
    case .api(let apiError): return apiError.status
    case .network(_, let code): return code
    default: return nil
    }
  }
  
  public var isRetryable: Bool {
    switch self {
    case .network(let retryable, _): return retryable
    default: return false
    }
  }
}

public enum APIErrorCode: Int {
  case badRequest = 400
  case unauthorized = 401
  case forbidden = 403
  case notFound = 404
  case internalServerError = 500
  case custom = 600
  case unknown
  
  public init(rawStatus: Int) {
    switch rawStatus {
    case 400: self = .badRequest
    case 401: self = .unauthorized
    case 403: self = .forbidden
    case 404: self = .notFound
    case 500: self = .internalServerError
    case 600...900: self = .custom
    default: self = .unknown
    }
  }
  
  public var userMessage: String {
    switch self {
    case .badRequest: return "요청이 올바르지 않아요."
    case .unauthorized: return "로그인이 필요해요."
    case .forbidden: return "권한이 없어요."
    case .notFound: return "요청한 자원이 없어요."
    case .internalServerError: return "서버에 문제가 있어요."
    case .custom: return "처리 중 오류가 발생했어요."
    case .unknown: return "알 수 없는 에러예요."
    }
  }
}
