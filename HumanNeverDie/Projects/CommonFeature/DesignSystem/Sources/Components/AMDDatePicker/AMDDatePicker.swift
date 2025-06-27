//
//  AMDDatePicker.swift
//  DesignSystem
//
//  Created by 김규철 on 6/27/25.
//

import SwiftUI

public struct AMDDatePicker: UIViewControllerRepresentable {
  @Binding private var selectedDate: Date
  private let pickerType: PickerType
  
  public init(
    selectedDate: Binding<Date>,
    pickerType: PickerType
  ) {
    self._selectedDate = selectedDate
    self.pickerType = pickerType
  }
  
  public enum PickerType {
    case yearMonth
    case yearMonthDay
    case time
  }
  
  public func makeUIViewController(context: Context) -> AMDDatePickerViewController {
    let viewController = AMDDatePickerViewController(
      selectedDate: selectedDate,
      pickerType: pickerType
    )
    
    viewController.onDateChanged = { newDate in
      selectedDate = newDate
    }
    
    return viewController
  }
  
  public func updateUIViewController(_ uiViewController: AMDDatePickerViewController, context: Context) {
    uiViewController.selectedDate = selectedDate
  }
}
