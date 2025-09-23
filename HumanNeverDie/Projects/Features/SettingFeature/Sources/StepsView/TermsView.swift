//
//  TermsView.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI
import CommonFeature
import DesignSystem

public struct TermsView: View {
  @State private var viewModel: TermsViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: TermsViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    List {
      Section {
        TermsRow(title: SettingItem.termsOfUse.title) {
          viewModel.handleAction(.openTerms(
            title: SettingItem.termsOfUse.title,
            url: AMDWebURL.addTermsOfUse
          ))
        }
        
        TermsRow(title: SettingItem.privacyPolicy.title) {
          viewModel.handleAction(.openTerms(
            title: SettingItem.privacyPolicy.title,
            url: AMDWebURL.addPrivacyPolicy
          ))
        }
      }.padding(.horizontal, 20)
    }.settingToolbar(item: .terms) {
      self.router.pop()
    }
    .listStyle(.plain)
    .listRowSeparator(.hidden)
    .fullScreenCover(isPresented: $viewModel.state.isPresentedAddTermsWebView) {
      if let url = viewModel.state.selectedURL {
        VStack(spacing: 0) {
          webViewNavigationBar
          AMDWebView(url: url)
        }
        .ignoresSafeArea(edges: .bottom)
      }
    }
  }
  
  private var webViewNavigationBar: some View {
    HStack(spacing: 0) {
      Button {
        viewModel.handleAction(.closeWebView)
      } label: {
        AMDImage.arrowLeft24.swiftUIImage
      }
      
      Spacer()
      
      Text(viewModel.state.webViewTitle)
        .amdFont(.mediumRegular)
        .foregroundColor(.gray85)
      
      Spacer()
      
      Color.clear
        .frame(width: 24, height: 24)
    }
    .padding(.horizontal, 16)
    .frame(height: 56)
    .background(Color.white)
    .padding(.top, 1)
  }
  
  private struct TermsRow: View {
    let title: String
    let onTap: () -> Void
    
    var body: some View {
      HStack {
        Text(title)
          .amdFont(.mediumRegular)
          .foregroundColor(.gray85)
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .foregroundColor(.gray40)
          .font(.system(size: 16))
      }
      .padding(.vertical, 15)
      .contentShape(Rectangle())
      .onTapGesture(perform: onTap)
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
    }
  }

}
