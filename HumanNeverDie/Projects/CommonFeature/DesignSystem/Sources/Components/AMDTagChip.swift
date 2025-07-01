//
//  AMDTagChip.swift
//  DesignSystem
//
//  Created by 김규철 on 6/24/25.
//

import SwiftUI

public struct AMDTagChip: View {
  private let title: String
  private let action: () -> Void
  
  public init(
    title: String,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.action = action
  }
  
  public var body: some View {
    HStack(spacing: 4) {
      chipTitle
      deleteButton
    }
    .padding(.horizontal, 12)
    .frame(height: 36)
    .amdStrokeBorder(.gray25)
  }
  
  private var chipTitle: some View {
    Text(title)
      .amdFont(.smallRegular)
      .foregroundStyle(.gray80)
  }
  
  private var deleteButton: some View {
    AMDImage.xIcon.swiftUIImage
      .resizable()
      .scaledToFill()
      .frame(width: 11, height: 11)
      .onTapGesture {
        withAnimation(.bouncy(duration: 0.6, extraBounce: 0.2)) {
          action()
        }
      }
  }
}

#Preview {
  AMDTagChip(title: "asdadsa", action: {})
}
