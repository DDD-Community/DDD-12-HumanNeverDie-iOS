//
//  AMDAlert.swift
//  DesignSystem
//
//  Created by 김규철 on 7/4/25.
//

import SwiftUI

public struct AMDAlert: View {
  private let property: AMDAlertProperty
  private let dismiss: () async -> Void
  
  public init(
    _ property: AMDAlertProperty,
    dismiss: @escaping () async -> Void
  ) {
    self.property = property
    self.dismiss = dismiss
  }
  
  public var body: some View {
    VStack(spacing: 10) {
      contentSection
      buttonSection
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 20)
    .background(.white)
    .amdCornerRadius(.large)
  }
  
  private var contentSection: some View {
    VStack(spacing: 0) {
      titleView
      messageView
    }
  }
  
  private var titleView: some View {
    Text(property.title)
      .amdFont(.largeBold)
      .foregroundStyle(.gray85)
      .frame(maxWidth: .infinity, alignment: .leading)
      .multilineTextAlignment(.leading)
      .padding(.vertical, 10)
  }
  
  private var messageView: some View {
    VStack(spacing: 12) {
      if let message = property.message {
        Text(message)
          .amdFont(.smallRegular)
          .foregroundStyle(.gray80)
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
      }
      
      if let subMessage = property.subMessage {
        Text(subMessage)
          .amdFont(.xsmallRegular)
          .foregroundStyle(.gray60)
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
      }
    }
    .padding(.vertical, (property.message == nil && property.subMessage == nil) ? 0 : 10)
  }
  
  private var buttonSection: some View {
    HStack(spacing: 10) {
      if let secondaryButton = property.secondaryButton {
        createButton(secondaryButton)
      }
      
      createButton(property.primaryButton)
    }
    .padding(.vertical, 10)
  }
  
  private func createButton(_ button: AMDAlertButtonProperty) -> some View {
    AMDButton(
      type: button.type,
      title: button.title,
      action: {
        Task { @MainActor in
          await button.action()
          await dismiss()
        }
      }
    )
  }
}
