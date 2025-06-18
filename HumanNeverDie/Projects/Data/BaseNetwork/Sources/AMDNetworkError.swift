//
//  AMDNetworkError.swift
//  BaseNetwork
//
//  Created by 김규철 on 6/17/25.
//

import Foundation

public enum AMDNetworkError: Error, LocalizedError {
  case invaildURL
  case emptyResponse
  case parameterEncodingError(Error)
  case responseValidationFailed(statusCode: Int)
  case decodingFailed(Error)
  case notConnectedNetwork
  case timeout
  case api(AMDAPIError)
  case unknown(Error)
  
  public var userMessage: String {
    switch self {
    case .invaildURL:
      return "유효하지 않은 URL 입니다."
      
    case .emptyResponse:
      return "서버로부터 유효한 응답을 받지 못했어요."
      
    case .parameterEncodingError(let parameterError):
      return "파라미터 인코딩에 실패했어요. \n\(parameterError)"
                  
    case .responseValidationFailed(statusCode: let statusCode):
      return "네트워크 요청 오류가 발생했습니다. \n\(statusCode)."
      
    case .decodingFailed(let decodeError):
      return "디코딩 실패 오류가 발생했습니다. \n\(decodeError)."
      
    case .notConnectedNetwork:
      return "네트워크 연결을 확인해주세요."
      
    case .timeout:
      return "요청 시간이 초과됐어요."
      
    case .api(let apiError):
      return apiError.codeType.userMessage
      
    case .unknown(let error):
      return "알 수 없는 오류가 발생했어요. \(error.localizedDescription)"
    }
  }
}


