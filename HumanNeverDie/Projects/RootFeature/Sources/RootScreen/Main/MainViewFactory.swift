//
//  MainViewFactory.swift
//  MainFeature
//
//  Created by 김규철 on 6/17/25.
//

import SwiftUI

@MainActor
public struct MainViewFactory {
  public static func create() -> some View {
    let viewModel = MainViewModel()
    return MainView(viewModel: viewModel)
  }
}
