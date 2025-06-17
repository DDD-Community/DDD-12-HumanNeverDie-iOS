//
//  AMDNetworkError.swift
//  BaseNetwork
//
//  Created by 김규철 on 6/17/25.
//

import Foundation

public enum AMDNetworkError: Error {
  case network(statusCode: Int)
  case api(AMDAPIError)
  case unknown(Error)
  
  public var userMessage: String {
    switch self {
    case .api(let apiError):
      return apiError.codeType.userMessage
      
    case .network(let code):
      switch code {
      case AMDNetworkStatusCode.emptyResponse:
        return "서버로부터 유효한 응답을 받지 못했어요."
      case AMDNetworkStatusCode.urlError:
        return "URL을 확인해주세요."
      case AMDNetworkStatusCode.timeout:
        return "요청 시간이 초과됐어요."
      default:
        return "네트워크 오류가 발생했습니다 (\(code)). 잠시 후 다시 시도해주세요."
      }
      
    case .unknown:
      return "알 수 없는 오류가 발생했어요."
    }
  }
  
  public var statusCode: Int? {
    switch self {
    case .api(let apiError): return apiError.status
    case .network(let code): return code
    default: return nil
    }
  }
}

enum AMDNetworkStatusCode {
  static let timeout = -1001
  static let urlError = -1
  static let emptyResponse = -2
}
