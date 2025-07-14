import SwiftUI

import SplashFeature
import OnboardingFeature
import CommonFeature
import BeverageRecordListFeature

public struct RootView: View {
  @State private var router = Router()
  
  public init() {}
  
  public var body: some View {
    NavigationStack(path: $router.path) {
      ZStack {
        switch router.rootRoute {
        case .onboarding:
          OnboardingViewFactory.create()
          
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
        case .beverageRecordList:
          BeverageRecordListViewFactory.create()
          
        case .BeverageSearch:
          BeverageSearchViewFactory.create()
          
        case .onboardingProfile:
          OnboardingProfileFactory.create()
        }
      }
    }
    .environment(router)
  }
}
