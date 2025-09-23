//
//  TermsViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation

import Shared
import UserDomain
import CommonFeature

@Observable
@MainActor
public final class TermsViewModel: ViewModelable {
  public struct State: Equatable {
    var isPresentedAddTermsWebView: Bool = false
    var webViewTitle: String = ""
    var selectedURL: URL?
  }
  
  public enum Action {
    case onAppear
    case openTerms(title: String, url: AMDWebURL)
    case closeWebView
  }
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
    case .openTerms(let title, let url):
      state.webViewTitle = title
      state.selectedURL = url.url
      state.isPresentedAddTermsWebView = true
    case .closeWebView:
      state.isPresentedAddTermsWebView = false
    }
  }
}
