//
//  AMDDatePickerBottomSheet.swift
//  CommonFeature
//
//  Created by Seulki Lee on 8/2/25.
//

import SwiftUI
import DesignSystem

public struct AMDDatePickerBottomSheet: ViewModifier {
  private let pickerTitle: String
  private let isResetButtonHidden: Bool
  @Binding var isPresented: Bool
  @Binding var selectedDate: Date
  private let onConfirm: (Date) -> Void
  
  @State private var tempDate: Date
  
  public init(
    pickerTitle: String = "",
    isResetButtonHidden: Bool = false,
    isPresented: Binding<Bool>,
    selectedDate: Binding<Date>,
    onConfirm: @escaping (Date) -> Void
  ) {
    self.pickerTitle = pickerTitle
    self.isResetButtonHidden = isResetButtonHidden
    self._isPresented = isPresented
    self._selectedDate = selectedDate
    self.onConfirm = onConfirm
    self._tempDate = State(initialValue: selectedDate.wrappedValue)
  }
  
  public func body(content: Content) -> some View {
    content
      .amdBottomSheet(isPresented: $isPresented, detents: [.height(356)]) {
        bottomSheetContent()
      }
  }
}

// MARK: - Private Methods
extension AMDDatePickerBottomSheet {
  
  private func bottomSheetContent() -> some View {
    VStack(spacing: 0) {
      headerView()
      datePickerView()
      Spacer()
      confirmButton()
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .onAppear {
      tempDate = selectedDate
    }
  }
  
  private func headerView() -> some View {
    HStack {
      Text(pickerTitle)
        .amdFont(.largeBold)
        .foregroundColor(.gray85)
      
      Spacer()
      
      if !isResetButtonHidden {
        resetButton()
      }
    }
    .padding(.top, 20)
    .padding(.bottom, 10)
  }
  
  private func resetButton() -> some View {
    Button {
      tempDate = Date()
    } label: {
      HStack(spacing: 4) {
        Text("초기화")
          .amdFont(.mediumRegular)
          .foregroundColor(.gray60)
        
        Image(systemName: "arrow.clockwise")
          .amdFont(.mediumRegular)
          .foregroundColor(.gray60)
      }
    }
  }
  
  private func datePickerView() -> some View {
    DatePicker(
      "날짜 선택",
      selection: $tempDate,
      displayedComponents: [.date]
    )
    .datePickerStyle(.wheel)
    .labelsHidden()
  }
  
  private func confirmButton() -> some View {
    AMDButton(
      type: .default,
      title: "확인"
    ) {
      selectedDate = tempDate
      onConfirm(tempDate)
      isPresented = false
    }
  }
}

extension View {
  public func amdDatePickerBottomSheet(
    pickerTitle: String = "",
    isResetButtonHidden: Bool = false,
    isPresented: Binding<Bool>,
    selectedDate: Binding<Date>,
    onConfirm: @escaping (Date) -> Void
  ) -> some View {
    modifier(AMDDatePickerBottomSheet(
      pickerTitle: pickerTitle,
      isResetButtonHidden: isResetButtonHidden,
      isPresented: isPresented,
      selectedDate: selectedDate,
      onConfirm: onConfirm
    ))
  }
}
