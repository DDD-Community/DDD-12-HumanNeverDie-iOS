import SwiftUI

import UserDomain
import SplashFeature
import OnboardingFeature
import CommonFeature
import BeverageRecordListFeature
import SettingFeature

public struct RootView: View {
  @State private var router = Router()
  @State private var settingViewModel = SettingViewModel()
  
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
          
        case .Setting:
          SettingViewFactory.create()
          
        case .SettingAccountInfo:
          let userInfo = settingViewModel.getUserInfoForAccountSetting()
          AccountInfoFactory.create(userInfo: userInfo)
          
        case .SettingGoalSetting:
          let userInfo = settingViewModel.getUserInfoForAccountSetting()
          GoalSettingFactory.create(userInfo: userInfo)
          
        case .SettingNotificationSetting:
          NotificationSettingView(viewModel: settingViewModel)
          
        case .SettingTerms:
          TermsView(viewModel: settingViewModel)
        }
      }
    }
    .environment(router)
  }
}
