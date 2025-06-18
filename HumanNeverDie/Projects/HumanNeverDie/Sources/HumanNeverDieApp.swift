import SwiftUI

import RootFeature
import DesignSystem

@main
struct HumanNeverDieApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  init() {
    DesignSystemFontFamily.registerAllCustomFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      RootView()
    }
  }
}
