//
//  AccountInfoViewFactory.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/17/25.
//

import SwiftUI

@MainActor
public struct AccountInfoViewFactory {
  public static func create() -> some View {
    let viewModel = AccountInfoViewModel()
    return AccountInfoView(viewModel: viewModel)
  }
}
