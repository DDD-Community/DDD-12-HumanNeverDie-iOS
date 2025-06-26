//
//  DesignSystemType.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 6/18/25.
//

import Foundation

enum DesignSystemType: String, CaseIterable {
  case color
  case font
  case amdGlucoseValueLabel
  case amdCard
  case amdProgress
  case amdChip
  case AMDBeverageList
  case amdPicker
  
  var title: String {
    self.rawValue.uppercased()
  }
}
