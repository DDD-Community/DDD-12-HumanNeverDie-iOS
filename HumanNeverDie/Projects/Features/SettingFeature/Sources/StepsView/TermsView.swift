//
//  TermsView.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI

struct TermsView: View {
  @State private var viewModel: TermsViewModel
  
  public init(viewModel: TermsViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
    var body: some View {
      VStack{
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      }.commonToolbar(item: .terms)
    }
}
