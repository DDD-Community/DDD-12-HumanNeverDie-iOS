//
//  AMDLottieAsset.swift
//  DesignSystem
//
//  Created by 김규철 on 7/19/25.
//

import Foundation

public enum AMDLottieAsset: String, CaseIterable {
  case honeyEffect = "HoneyEffect"
  case splash = "LoadingSpinner"
  case loadingSpinner = "Splash"
  
  var fileName: String {
    return rawValue + ".json"
  }
}
