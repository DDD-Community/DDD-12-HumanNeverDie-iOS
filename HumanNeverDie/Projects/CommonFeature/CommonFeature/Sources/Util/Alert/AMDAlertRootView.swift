//
//  AMDAlertRootView.swift
//  CommonFeature
//
//  Created by 김규철 on 7/4/25.
//

import SwiftUI

import DesignSystem

struct AMDAlertRootView: View {
  @Environment(AMDAlertManager.self) private var alertManager
  private let property: AMDAlertProperty
  
  init(_ property: AMDAlertProperty) {
    self.property = property
  }
  
  var body: some View {
    ZStack(alignment: .center) {
      if alertManager.isPresented {
        Color.black
          .opacity(0.5)
          .ignoresSafeArea(.all)
          .onTapGesture {
            alertManager.hideAlert()
          }
        
        AMDAlert(property) { alertManager.hideAlert() }
          .padding(.horizontal, 30)
      }
    }
  }
}
