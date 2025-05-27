import SwiftUI

import SplashFeature
import MainFeature
import CommonFeature
import MainDomain
import BaseNetwork
import Data

public struct RootView: View {
  @State private var router = Router()
  
  public init() {}
  
  public var body: some View {
    NavigationStack(path: $router.path) {
      ZStack {
        switch router.rootRoute {
        case .splash:
          let splashViewModel = SplashViewModel()
          SplashView(viewModel: splashViewModel)
          
        case .main:
          let networkService = DefaultNetworkService()
          let mainRepository = DefaultMainRepository(networkService: networkService)
          let mainUseCase = DefaultMainUseCase(repository: mainRepository)
          let mainViewModel = MainViewModel(mainUseCase: mainUseCase)
          
          MainView(viewModel: mainViewModel)
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
