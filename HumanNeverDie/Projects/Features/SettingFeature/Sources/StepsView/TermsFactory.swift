//
//  TermsFactory.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI

@MainActor
public struct TermsFactory {
  public static func create() -> some View {
    let viewModel = TermsViewModel()
    return TermsView(viewModel: viewModel)
  }
}
