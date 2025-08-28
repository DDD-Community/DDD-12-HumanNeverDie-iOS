//
//  AMDWebView.swift
//  CommonFeature
//
//  Created by 김규철 on 8/28/25.
//

import SwiftUI
import WebKit

public struct AMDWebView: UIViewRepresentable {
  private let url: URL
  
  public init(url: URL) {
    self.url = url
  }
  
  public func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  public func updateUIView(_ webView: WKWebView, context: Context) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
}
