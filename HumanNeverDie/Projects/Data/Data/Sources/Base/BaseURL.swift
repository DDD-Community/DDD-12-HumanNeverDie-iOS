//
//  BaseURL.swift
//  Data
//
//  Created by 김규철 on 5/25/25.
//

import Foundation

public enum Config {
  static var baseURL: String {
    return Bundle.main.infoDictionary?["BASE_URL"] as? String ?? ""
  }
}


