import SwiftUI

import RootFeature

@main
struct HumanNeverDieApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  init() {}
  
  var body: some Scene {
    WindowGroup {
      RootView()
    }
  }
}
