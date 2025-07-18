//
//  AccountInfoView.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/16/25.
//

import SwiftUI

public struct AccountInfoView: View {
  @State private var viewModel: AccountInfoViewModel
  public init(viewModel: AccountInfoViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ScrollView {
  
    }.commonToolbar(item: .accountInfo)
  }
}

