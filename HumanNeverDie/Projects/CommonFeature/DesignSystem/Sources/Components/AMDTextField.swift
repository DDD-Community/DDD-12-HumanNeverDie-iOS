//
//  AMDTextField.swift
//  DesignSystem
//
//  Created by 김규철 on 6/30/25.
//

import SwiftUI

public enum AMDTextFieldRightAreaButtonType {
  case search
  case date
  case edit
  case none
  
  @ViewBuilder
  var iconView: some View {
    switch self {
    case .search:
      AMDImage.find24.swiftUIImage
    case .date:
      AMDImage.calendar24.swiftUIImage
    case .edit:
      AMDImage.edit24.swiftUIImage
    case .none:
      EmptyView()
    }
  }
}

public struct AMDTextField: View {
  @Binding private var text: String
  private var isFocused: FocusState<Bool>.Binding?
  private let title: String?
  private let titleSuffix: String?
  private let placeholder: String?
  private let hiddenClearButton: Bool
  private let maxCount: Int?
  private let rightButtonType: AMDTextFieldRightAreaButtonType
  private let rightButtonAction: (() -> Void)?
  private let errorMessage: String?
  private let helperMessage: String?
  
  @FocusState private var internalFocus: Bool
  
  public init(
    text: Binding<String>,
    isFocused: FocusState<Bool>.Binding? = nil,
    title: String? = nil,
    titleSuffix: String? = nil,
    placeholder: String? = nil,
    hiddenClearButton: Bool = true,
    maxCount: Int? = nil,
    rightButtonType: AMDTextFieldRightAreaButtonType = .none,
    rightButtonAction: (() -> Void)? = nil,
    errorMessage: String? = nil,
    helperMessage: String? = nil
  ) {
    self._text = text
    self.isFocused = isFocused
    self.title = title
    self.titleSuffix = titleSuffix
    self.placeholder = placeholder
    self.hiddenClearButton = hiddenClearButton
    self.maxCount = maxCount
    self.rightButtonType = rightButtonType
    self.rightButtonAction = rightButtonAction
    self.errorMessage = errorMessage
    self.helperMessage = helperMessage
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      titleView
      textFieldView
      messageView
    }
    .if(maxCount != nil) {
      $0.onChange(of: text) { _, newValue in
        guard let maxCount, text.count > maxCount else { return }
        self.text = String(newValue.prefix(maxCount))
      }
    }
  }
  
  public static func titleLabel(_ title: String) -> some View {
    Text(title)
      .amdFont(.smallBold)
      .foregroundStyle(.gray80)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.bottom, 8)
  }
  
  @ViewBuilder
  private var titleView: some View {
    if let title {
      Self.titleLabel(title)
    }
  }
  
  private var textFieldView: some View {
    HStack(spacing: 10) {
      if let titleSuffix, !titleSuffix.isEmpty {
        textFieldWithtitleSuffix
      } else {
        textField
      }
      textCountView
      rightAreaButtonView
    }
    .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
    .padding(.horizontal, 12)
    .background(.gray10)
    .amdCornerRadius(.medium)
    .onTapGesture {
      (isFocused ?? $internalFocus).wrappedValue = true
    }
  }
  
  private var textField: some View {
    HStack(spacing: 0) {
      TextField(text: $text) {
        if let placeholder {
          Text(placeholder)
            .amdFont(.mediumRegular)
            .foregroundStyle(.gray60)
        }
      }
      .amdFont(.mediumMedium)
      .foregroundStyle(.gray85)
      .tint(.gray85)
      .focused(isFocused ?? $internalFocus)
      .frame(height: 24)
      
      if !hiddenClearButton && (isFocused?.wrappedValue ?? internalFocus) {
        Button {
          text.removeAll()
        } label: {
          AMDImage.delete24.swiftUIImage
        }
        .padding(.leading, 8)
      }
    }
  }
  
  private var textFieldWithtitleSuffix: some View {
    ZStack(alignment: .leading) {
      TextField(
        "",
        text: $text
      )
      .keyboardType(.numberPad)
      .focused(isFocused ?? $internalFocus)
      .foregroundColor(.clear)
      .accentColor(.black)
      .padding(.trailing, 30)
      .background(Color.clear.contentShape(Rectangle()))

      HStack(spacing: 0) {
        if text.isEmpty {
          Text(placeholder ?? "")
            .amdFont(.mediumRegular)
            .foregroundStyle(.gray60)
        } else {
          Text(text)
            .amdFont(.mediumRegular)
            .foregroundStyle(.gray80)

          if let titleSuffix {
            Text(titleSuffix)
              .amdFont(.mediumRegular)
              .foregroundStyle(.gray80)
          }
        }
      }
    }
  }

  
  @ViewBuilder
  private var textCountView: some View {
    if let maxCount {
      Text("\(text.count) / \(maxCount)")
        .amdFont(.smallRegular)
        .foregroundStyle(.gray60)
        .if(maxCount >= text.count) {
          $0
            .amdNumericAnimation(text.count)
        }
    }
  }
  
  @ViewBuilder
  private var rightAreaButtonView: some View {
    rightButtonType.iconView
      .if(rightButtonType != .none) {
        $0
          .onTapGesture { rightButtonAction?() }
      }
  }
  
  private var messageView: some View {
    VStack(spacing: 8) {
      if let errorMessage {
        Text(errorMessage)
          .amdFont(.smallRegular)
          .foregroundStyle(.danger)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      if let helperMessage {
        Text(helperMessage)
          .amdFont(.smallRegular)
          .foregroundStyle(.gray60)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}

