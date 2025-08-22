import SwiftUI

import UserDomain
import CommonFeature
import SplashFeature
import AuthFeature
import OnboardingFeature
import BeverageRecordListFeature
import SettingFeature

public struct RootView: View {
  @State private var router = Router()
  
  public init() {}
  
  public var body: some View {
    NavigationStack(path: $router.path) {
      ZStack {
        switch router.rootRoute {
        case .splash:
          SplashViewFactory.create()
          
        case .login:
          LoginViewFactory.create()
          
        case .onboarding:
          OnboardingViewFactory.create()
          
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
          
        case .SettingAccountInfo(userInfo: let userInfo):
          AccountInfoFactory.create(userInfo: userInfo)
          
        case .SettingGoalSetting(userInfo: let userInfo):
          GoalSettingFactory.create(userInfo: userInfo)
          
        case .SettingNotificationSetting(userID: let userID):
          NotificationSettingFactory.create(userID: userID)
        case .SettingTerms:
          TermsFactory.create()
        }
      }
    }
    .environment(router)
  }
}
