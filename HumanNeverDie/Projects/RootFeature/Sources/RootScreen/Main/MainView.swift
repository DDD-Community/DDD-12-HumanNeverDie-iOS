import SwiftUI

import HomeFeature
import HistoryFeature
import CommonFeature
import DesignSystem

public enum AMDTabBarType: String, CaseIterable {
  case home = "홈"
  case history = "히스토리"
  
  var icon: Image {
    switch self {
    case .home: return AMDImage.homeOff24.swiftUIImage
    case .history: return AMDImage.calendarOff24.swiftUIImage
    }
  }
  
  var selectedIcon: Image {
    switch self {
    case .home: return AMDImage.home24.swiftUIImage
    case .history: return AMDImage.calendar24.swiftUIImage
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
  }
  
  @ViewBuilder
  private var contentView: some View {
    Group {
      switch viewModel.selectedTab {
      case .home:
        HomeViewFactory.create()
        
      case .history:
        HistoryViewFactory.create()
      }
    }
    .padding(.bottom, 92)
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
    .frame(minHeight: 92, maxHeight: 92, alignment: .top)
    .background(.white)
    .amdShadow(.tabbar)
  }
  
  private func tabBarButton(for tab: AMDTabBarType) -> some View {
    Button {
      viewModel.handleAction(.tabBarItemTapped(tab))
    } label: {
      VStack(spacing: 2) {
        Group {
          if viewModel.selectedTab == tab {
            tab.selectedIcon
          } else {
            tab.icon
          }
        }
        
        Text(tab.rawValue)
          .amdFont(.xxsmallRegular)
          .foregroundStyle(viewModel.selectedTab == tab ? .gray95 : .gray60)
      }
      .padding(.vertical, 8)
      .padding(.horizontal, 16)
    }
    .frame(maxWidth: .infinity)
  }
}
