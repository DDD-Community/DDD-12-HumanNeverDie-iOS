//
//  AMDSwipeBackModifier.swift
//  CommonFeature
//
//  Created by 김규철 on 7/2/25.
//

import SwiftUI

private struct SwipeBackViewController: UIViewControllerRepresentable {
  private let enabled: Bool
  
  init(enabled: Bool) {
    self.enabled = enabled
  }
  
  func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    DispatchQueue.main.async {
      guard let navigationController = uiViewController.navigationController else { return }
      navigationController.interactivePopGestureRecognizer?.isEnabled = enabled
      navigationController.interactivePopGestureRecognizer?.delegate = enabled ? context.coordinator : nil
    }
  }
  
  func makeCoordinator() -> CleanCoordinator {
    CleanCoordinator(enabled: enabled)
  }
}

extension SwipeBackViewController {
  final class CleanCoordinator: NSObject, UIGestureRecognizerDelegate {
    private let enabled: Bool
    
    init(enabled: Bool) {
      self.enabled = enabled
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      guard enabled else { return false }
      guard let navigationController = gestureRecognizer.view?.next as? UINavigationController else { return false }
      return navigationController.viewControllers.count > 1
    }
  }
}

private struct AMDSwipeBackModifier: ViewModifier {
  private let enabled: Bool
  
  init(enabled: Bool = true) {
    self.enabled = enabled
  }
  
  func body(content: Content) -> some View {
    content
      .background(SwipeBackViewController(enabled: enabled))
  }
}

public extension View {
  func amdSwipeBackEnabled(enabled: Bool = true) -> some View {
    modifier(AMDSwipeBackModifier(enabled: enabled))
  }
}
