//
//  AMDKeychainError.swift
//  Shared
//
//  Created by 김규철 on 8/22/25.
//

import Foundation

public enum AMDKeychainError: Error, LocalizedError {
  case invalidData
  case addFailed(OSStatus)
  case updateFailed(OSStatus)
  case deleteFailed(OSStatus)
  case deleteAllFailed(OSStatus)
  
  public var errorDescription: String? {
    switch self {
    case .invalidData:
      return "키체인에 저장할 수 없는 데이터입니다"
    case .addFailed(let status):
      return "키체인 저장에 실패했습니다: \(status)"
    case .updateFailed(let status):
      return "키체인 업데이트에 실패했습니다: \(status)"
    case .deleteFailed(let status):
      return "키체인 삭제에 실패했습니다: \(status)"
    case .deleteAllFailed(let status):
      return "키체인 전체 삭제에 실패했습니다: \(status)"
    }
  }
}
