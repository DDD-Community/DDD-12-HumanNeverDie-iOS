//
//  AccountInfoFactory.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import SwiftUI

@MainActor
public struct AccountInfoFactory {
  public static func create(userInfo: UserInfo) -> some View {
    let viewModel = AccountInfoViewModel(userInfo: userInfo)
    return AccountInfoView(viewModel: viewModel) // SettingView → AccountInfoView
  }
}
