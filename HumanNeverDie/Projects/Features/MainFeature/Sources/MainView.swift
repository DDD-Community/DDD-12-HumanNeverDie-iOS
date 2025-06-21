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
    case .home: return AMDImage.success24.swiftUIImage
    case .history: return AMDImage.liked24.swiftUIImage
    }
  }
  
  var selectedIcon: Image {
    switch self {
    case .home: return AMDImage.unliked24.swiftUIImage
    case .history: return AMDImage.unliked24.swiftUIImage
    }
  }
}

public struct MainView: View {
  @State private var viewModel: MainViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: MainViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ZStack(alignment: .bottom) {
      contentView
        .padding(.bottom, 66)
      
      tabBar
    }
    .toolbar(.hidden)
  }
  
  @ViewBuilder
  private var contentView: some View {
    switch viewModel.selectedTab {
    case .home:
      HomeViewFactory.create()
      
    case .history:
      HistoryViewFactory.create()
    }
  }
  
  private var tabBar: some View {
    VStack(spacing: 0) {
      AMDDevider()
        .amdShadow(.tabbar)
      
      HStack(spacing: 0) {
        ForEach(AMDTabBarType.allCases, id: \.self) { tab in
          tabBarButton(for: tab)
        }
      }
    }
    .background(.white)
  }
  
  private func tabBarButton(for tab: AMDTabBarType) -> some View {
    Button {
      viewModel.handleAction(.tabBarItemTapped(tab))
    } label: {
      VStack(spacing: 2) {
        tab.icon
          .foregroundColor(viewModel.selectedTab == tab ? .gray60 : .gray40)
        
        Text(tab.rawValue)
          .amdFont(.xxsmallRegular)
          .foregroundColor(viewModel.selectedTab == tab ? .gray95 : .gray70)
      }
    }
    .frame(maxWidth: .infinity, minHeight: 65, maxHeight: 65)
  }
}
