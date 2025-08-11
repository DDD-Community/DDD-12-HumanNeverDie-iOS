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
        case let .beverageRecordList(date):
          BeverageRecordListViewFactory.create(recordDate: date)
          
        case let .beverageSearch(date):
          BeverageSearchViewFactory.create(recordDate: date)
          
        case let .beverageRecord(productID, isLiked, date):
          BeverageRecordViewFactory.create(productID: productID, isLiked: isLiked, recordDate: date)
          
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
          let userInfo = settingViewModel.getUserInfoForAccountSetting()
          NotificationSettingFactory.create(userInfo: userInfo)
          
        case .SettingTerms:
          TermsFactory.create()
        }
      }
    }
    .environment(router)
  }
}
