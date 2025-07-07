//
//  AMDToast.swift
//  DesignSystem
//
//  Created by 김규철 on 7/5/25.
//

import SwiftUI

public struct AMDToast: View {
  private let property: AMDToastProperty
  
  public init(_ property: AMDToastProperty) {
    self.property = property
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: 10) {
      icon
      titleView
    }
    .padding(.horizontal, 20)
    .frame(height: 56)
    .background(.gray85)
    .amdCornerRadius(.medium)
  }
  
  @ViewBuilder
  private var icon: some View {
    switch property.type {
    case .success:
      AMDImage.success24.swiftUIImage
    case .failure:
      AMDImage.failed24.swiftUIImage
    }
  }
  
  private var titleView: some View {
    Text(property.message)
      .amdFont(.mediumRegular)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}
