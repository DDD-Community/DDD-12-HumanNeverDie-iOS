//
//  GoalSettingView.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI

struct GoalSettingView: View {
  @State private var viewModel: GoalSettingViewModel
  
  public init(viewModel: GoalSettingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
    var body: some View {
      VStack{
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      }.commonToolbar(item: .goalSetting)
    }
}

