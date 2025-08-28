import SwiftUI

import HomeFeature
import HistoryFeature
import CommonFeature
import DesignSystem
import SettingFeature

public enum AMDTabBarType: String, CaseIterable {
  case home = "홈"
  case history = "히스토리"
  case myPage = "마이페이지"
  
  var icon: Image {
    switch self {
    case .home: return AMDImage.homeOff24.swiftUIImage
    case .history: return AMDImage.calendarOff24.swiftUIImage
    case .myPage: return AMDImage.mypageOff24.swiftUIImage
    }
  }
  
  var selectedIcon: Image {
    switch self {
    case .home: return AMDImage.home24.swiftUIImage
    case .history: return AMDImage.calendar24.swiftUIImage
    case .myPage: return AMDImage.mypage24.swiftUIImage
    }
  }
}

public struct MainView: View {
  @State private var viewModel: MainViewModel
  
  public init(viewModel: MainViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ZStack(alignment: .bottom) {
      contentView
      tabBar
    }
    .toolbarVisibility(.hidden, for: .tabBar)
    .ignoresSafeArea(edges: .bottom)
    .overlay {
      if viewModel.isOnboardingPresented {
        AMDOnboardingView(
          onDismiss: { viewModel.handleAction(.onboardingDismissButtonTapped) }
        )
      }
    }
    .animation(.default, value: viewModel.isOnboardingPresented)
    .onViewDidLoad {
      viewModel.handleAction(.onViewDidLoad)
    }
  }
  
  @ViewBuilder
  private var contentView: some View {
    Group {
      switch viewModel.selectedTab {
      case .home:
        homeView
        
      case .history:
        historyView
        
      case .myPage:
        myPageView
      }
    }
    .padding(.bottom, 82)
  }
  
  private var homeView: some View {
    HomeView(viewModel: viewModel.homeViewModel)
  }
  
  private var historyView: some View {
    HistoryView(viewModel: viewModel.historyViewModel)
  }
  
  private var myPageView: some View {
    SettingView(viewModel: viewModel.settingViewModel)
  }
  
  private var tabBar: some View {
    VStack(spacing: 0) {
      AMDDevider()
      
      HStack(spacing: 0) {
        ForEach(AMDTabBarType.allCases, id: \.self) { tab in
          tabBarButton(for: tab)
        }
      }
      .padding(.vertical, 5)
    }
    .frame(minHeight: 82, maxHeight: 82, alignment: .top)
    .background(.white)
    .amdShadow(.tabbar)
  }
  
  private func tabBarButton(for tab: AMDTabBarType) -> some View {
    Button {
      viewModel.handleAction(.tabBarItemTapped(tab))
    } label: {
      Group {
        if viewModel.selectedTab == tab {
          tab.selectedIcon
        } else {
          tab.icon
        }
      }
      .padding(16)
    }
    .frame(maxWidth: .infinity)
  }
}
