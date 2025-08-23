//
//  AMDAuthenticatorError.swift
//  BaseNetwork
//
//  Created by 김규철 on 8/22/25.
//

import Foundation

public enum AMDAuthenticatorError: Error {
  case tokenRefreshNotSupported
  
  public var localizedDescription: String {
    switch self {
    case .tokenRefreshNotSupported:
      return "Token refresh is not supported"
    }
  }
}
