//
//  AccountInfoView.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/16/25.
//

import SwiftUI

public struct AccountInfoView: View {
  @State public var viewModel: SettingViewModel
  
  public init(viewModel: SettingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ScrollView {
      
  
    }.commonToolbar(item: .accountInfo)
  }
}

