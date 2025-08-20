import SwiftUI
import SwiftData

import RootFeature
import DesignSystem
import Data

@main
struct AMatDangApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  init() {
    DesignSystemFontFamily.registerAllCustomFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      RootView()
    }
    .modelContainer(.aMatdangLocalDataBase)
  }
}
