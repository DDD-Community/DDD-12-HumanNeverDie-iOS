//
//  AMDSugarFreeVariant.swift
//  DesignSystem
//
//  Created by 김규철 on 6/25/25.
//

import Foundation

public enum AMDSugarFreeVariant: String {
  case zero = "무당"
  case low = "저당"
  
  public static func from(_ rawString: String) -> AMDSugarFreeVariant? {
    switch rawString.uppercased() {
    case "ZERO": return .zero
    case "LOW": return .low
    default: return nil
    }
  }
}
