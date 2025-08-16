//
//  TermsFactory.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import SwiftUI
import UserDomain

@MainActor
public struct TermsFactory {
  public static func create() -> some View {
    let viewModel = TermsViewModel()
    return TermsView(viewModel: viewModel)
  }
}

