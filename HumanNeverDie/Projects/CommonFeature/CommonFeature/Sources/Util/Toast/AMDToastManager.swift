//
//  AMDToastManager.swift
//  CommonFeature
//
//  Created by 김규철 on 7/4/25.
//

import SwiftUI

import DesignSystem

@MainActor
public final class AMDToastManager {
  public static let shared = AMDToastManager()
  
  var currentProperty: AMDToastProperty?
  private var toastWindow: UIWindow?
  private var hideTask: Task<Void, Never>?
  private var duration: CGFloat = 2.0
  
  private init() {
    createToastWindow()
  }
  
  public func showToast(_ property: AMDToastProperty) {
    hideTask?.cancel()
    
    showToastWindow(property)
    
    self.hideTask = Task {
      try? await Task.sleep(for: .seconds(duration))
      
      if !Task.isCancelled {
        await MainActor.run {
          self.hideToast()
        }
      }
    }
  }
  
  private func hideToast() {
    toastWindow?.isHidden = true
  }
  
  private func createToastWindow() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return
    }
    
    toastWindow = UIWindow(windowScene: windowScene)
    toastWindow?.windowLevel = UIWindow.Level.alert + 1
    toastWindow?.backgroundColor = UIColor.clear
    toastWindow?.isUserInteractionEnabled = false
    toastWindow?.rootViewController = UIHostingController(rootView: EmptyView())
  }
  
  private func showToastWindow(_ property: AMDToastProperty) {
    let hosting = UIHostingController(
      rootView: AMDToastRootView(property)
    )
    hosting.view.backgroundColor = .clear
    toastWindow?.rootViewController = hosting
    toastWindow?.isHidden = false
  }
}

