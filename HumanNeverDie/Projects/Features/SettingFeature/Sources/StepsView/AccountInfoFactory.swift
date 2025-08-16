//
//  AccountInfoFactory.swift
//  SettingFeature
//
//  Created by Seulki Lee on 8/16/25.
//
import SwiftUI
import UserDomain

@MainActor
public struct AccountInfoFactory {
  public static func create(userInfo: UserInfo) -> some View {
    let viewModel = AccountInfoViewModel(userInfo: userInfo)
    return AccountInfoView(viewModel: viewModel) 
  }
}


