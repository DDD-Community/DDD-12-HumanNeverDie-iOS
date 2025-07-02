//
// HomeView.swift
// Home
//
// Created by 김규철 on 2025.
//

import SwiftUI

import CommonFeature
import DesignSystem

public struct HomeView: View {
  @State private var viewModel: HomeViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: HomeViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ZStack {
      Color.pink
      
      AMDFloatingButton(
        title: "음료 기록하기",
        action: { router.push(to: .beverageRecordList) }
      )
    }
  }
}
