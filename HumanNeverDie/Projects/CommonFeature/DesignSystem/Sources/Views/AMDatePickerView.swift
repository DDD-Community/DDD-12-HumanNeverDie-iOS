//
//  AMDatePickerView.swift
//  DesignSystem
//
//  Created by 김규철 on 7/5/25.
//

import SwiftUI

public struct AMDDatePickerView: View {
  private let title: String
  private let isResetButtonHidden: Bool
  private let type: AMDDatePicker.PickerType
  private let isAgeRestricted: Bool?
  private let action: (Date) -> Void
  
  @State private var date: Date = Date()
  
  public init(
    title: String = "날짜 선택",
    isResetButtonHidden: Bool = true,
    type: AMDDatePicker.PickerType,
    initialDate: Date = Date(),
    isAgeRestricted: Bool? = nil,
    action: @escaping (Date) -> Void
  ) {
    self.title = title
    self.type = type
    self.isResetButtonHidden = isResetButtonHidden
    self.action = action
    self.isAgeRestricted = isAgeRestricted
    self._date = State(initialValue: initialDate)
    
  }
  
  public var body: some View {
    VStack(spacing: 10) {
      titleView
      datePickerView
      buttonView
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 20)
    .ignoresSafeArea(edges: .bottom)
  }
  
  private var titleView: some View {
    HStack {
      Text(title)
        .amdFont(.largeBold)
        .foregroundStyle(.gray85)
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
      
      Spacer()
      
      if !isResetButtonHidden {
        resetButton
      }
    }
  }
  
  private var resetButton: some View {
    Button {
      date = Date()
    } label: {
      HStack(spacing: 4) {
        Text("초기화")
          .amdFont(.mediumRegular)
          .foregroundColor(.gray60)
        
        Image(systemName: "arrow.clockwise")
          .foregroundColor(.gray60)
      }
    }
  }
  
  private var datePickerView: some View {
    AMDDatePicker(
      selectedDate: $date,
      pickerType: type,
      isAgeRestricted: isAgeRestricted ?? false
    )
    .frame(maxWidth: .infinity, minHeight: 184, maxHeight: 184)
  }
  
  private var buttonView: some View {
    AMDButton(
      type: .default,
      title: "확인",
      action: { action(date) }
    )
  }
}
