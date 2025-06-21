import SwiftUI

import MainFeature
import SplashFeature
import CommonFeature


public struct RootView: View {
  @State private var router = Router()
  
  public init() {}
  
  public var body: some View {
    NavigationStack(path: $router.path) {
      ZStack {
        switch router.rootRoute {
        case .splash:
          SplashViewFactory.create()
          
        case .main:
          MainViewFactory.create()
        }
      }
      .id(router.rootViewId)
      .navigationBarBackButtonHidden(true)
      .navigationDestination(for: Route.self) { route in
        switch route {
        case .map:
          Color.blue
        }
      }
    }
    .environment(router)
  }
}
