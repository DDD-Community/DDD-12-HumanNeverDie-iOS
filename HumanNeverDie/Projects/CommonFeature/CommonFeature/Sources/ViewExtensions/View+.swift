//
//  View+.swift
//  CommonFeature
//
//  Created by 김규철 on 8/25/25.
//

import SwiftUI

public extension View {  
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
