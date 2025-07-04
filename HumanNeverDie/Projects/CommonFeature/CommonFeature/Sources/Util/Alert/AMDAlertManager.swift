//
//  AMDAlertManager.swift
//  CommonFeature
//
//  Created by 김규철 on 7/4/25.
//

import SwiftUI

import DesignSystem

@Observable
@MainActor
final class AMDAlertManager {
  static let shared = AMDAlertManager()
  
  private var alertWindow: UIWindow?
  var isPresented = false
  
  private init() {
    createAlertWindoww()
  }
  
  func showAlert(_ property: AMDAlertProperty) {
    self.showAlertWindow(property)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
      withAnimation(.easeIn(duration: 0.2)) {
        self.isPresented = true
      }
    }
  }
  
  func hideAlert() {
    withAnimation(.easeOut(duration: 0.2)) {
      self.isPresented = false
    } completion: {
      self.hideAlertWindow()
    }
  }
  
  private func createAlertWindoww() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      alertWindow = nil
      return
    }
    
    alertWindow = UIWindow(windowScene: windowScene)
    alertWindow?.windowLevel = UIWindow.Level.alert
    alertWindow?.backgroundColor = UIColor.clear
    alertWindow?.rootViewController = UIHostingController(rootView: EmptyView())
  }
  
  private func showAlertWindow(_ property: AMDAlertProperty) {
    let hostingController = UIHostingController(
      rootView: AMDAlertRootView(property)
        .environment(self)
    )
    
    hostingController.view.backgroundColor = UIColor.clear
    alertWindow?.rootViewController = hostingController
    alertWindow?.isHidden = false
  }
  
  private func hideAlertWindow() {
    alertWindow?.isHidden = true
    alertWindow?.rootViewController = nil
  }
}
