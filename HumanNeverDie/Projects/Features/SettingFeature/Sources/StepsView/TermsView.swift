//
//  TermsView.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI
import CommonFeature

public struct TermsView: View {
  @State private var viewModel: TermsViewModel
  @Environment(Router.self) private var router

  public init(viewModel: TermsViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }

  public var body: some View {
    List {
      Section {
        TermsRow(title: "이용약관") {
          //페이지 이동
        }

        TermsRow(title: "개인정보처리방침") {
          //외부링크 이동
        }
      }
    }
    .listStyle(.plain)
    .listRowSeparator(.hidden)
    .padding(.top, 30)
    .commonToolbar(item: .terms)
  }
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
    .padding(.horizontal, 20)
    .contentShape(Rectangle())
    .onTapGesture(perform: onTap)
    .listRowSeparator(.hidden)
    .listRowInsets(EdgeInsets())
  }
}
