//
//  AMDWebURL.swift
//  CommonFeature
//
//  Created by 김규철 on 8/28/25.
//

import Foundation

public enum AMDWebURL: String, CaseIterable {
  case addBeverageForm = "https://forms.gle/9sVcZGZRATALoCRZ6"
  
  public var url: URL? {
    return URL(string: self.rawValue)
  }
}
