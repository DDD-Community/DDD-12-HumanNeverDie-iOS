//
//  View+.swift
//  Shared
//
//  Created by Seulki Lee on 8/24/25.
//

import SwiftUI

extension View {
  public func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
