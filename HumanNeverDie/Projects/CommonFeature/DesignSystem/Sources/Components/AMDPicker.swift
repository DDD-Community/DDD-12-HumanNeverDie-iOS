//
//  AMDPicker.swift
//  DesignSystem
//
//  Created by 김규철 on 6/26/25.
//

import SwiftUI

private struct PickerConstants {
  fileprivate static let years = Array(1970...Date().year)
  fileprivate static let months = Array(1...12)
  fileprivate static let amPmOptions = ["오전", "오후"]
  fileprivate static let hours12 = Array(1...12)
  fileprivate static let minutes = Array(0...59)
  
  fileprivate static let pickerViewRows = 10_000
  fileprivate static let pickerViewMiddle = ((pickerViewRows / hours12.count) / 2) * hours12.count
}

public struct AMDPicker: UIViewRepresentable {
  @Binding private var selectedDate: Date
  private let pickerType: PickerType
  private let picker: UIPickerView
  private let coordinator: Coordinator
  
  public init(
    selectedDate: Binding<Date>,
    pickerType: PickerType
  ) {
    self._selectedDate = selectedDate
    self.pickerType = pickerType
    self.picker = UIPickerView()
    self.coordinator = Coordinator(selectedDate, pickerType: pickerType)
  }
  
  public enum PickerType {
    case yearMonth
    case yearMonthDay
    case time
  }
  
  public func makeUIView(context: Context) -> UIPickerView {
    picker.delegate = coordinator
    picker.dataSource = coordinator
    
    setupInitialValues(picker: picker)
    
    return picker
  }
  
  public func updateUIView(_ uiView: UIPickerView, context: Context) {
    setupInitialValues(picker: uiView)
  }
  
  public func makeCoordinator() -> Coordinator {
    return coordinator
  }
  
  private func setupInitialValues(picker: UIPickerView) {
    let currentDate = selectedDate
    
    switch pickerType {
    case .yearMonth:
      picker.selectRow(currentDate.year - 1970, inComponent: 0, animated: false)
      picker.selectRow(currentDate.month - 1, inComponent: 1, animated: false)
      
    case .yearMonthDay:
      picker.selectRow(currentDate.year - 1970, inComponent: 0, animated: false)
      picker.selectRow(currentDate.month - 1, inComponent: 1, animated: false)
      picker.selectRow(currentDate.day - 1, inComponent: 2, animated: false)
      
    case .time:
      picker.selectRow(currentDate.isAM ? 0 : 1, inComponent: 0, animated: false)
      
      let targetRow = coordinator.rowForHourValue(currentDate.displayHour12)
      picker.selectRow(targetRow, inComponent: 1, animated: false)
      
      picker.selectRow(currentDate.minute, inComponent: 2, animated: false)
    }
    
    DispatchQueue.main.async {
      for componentIndex in 0..<picker.numberOfComponents {
        picker.reloadComponent(componentIndex)
      }
    }
  }
}

public extension AMDPicker {
  class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    @Binding private var selectedDate: Date
    private let pickerType: PickerType
    
    init(
      _ selectedDate: Binding<Date>,
      pickerType: PickerType
    ) {
      self._selectedDate = selectedDate
      self.pickerType = pickerType
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
      switch pickerType {
      case .yearMonth: return 2
      case .yearMonthDay: return 3
      case .time: return 3
      }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch pickerType {
      case .yearMonth:
        switch component {
        case 0: return PickerConstants.years.count
        case 1: return PickerConstants.months.count
        default: return 0
        }
        
      case .yearMonthDay:
        switch component {
        case 0: return PickerConstants.years.count
        case 1: return PickerConstants.months.count
        case 2: return daysInMonth(year: getSelectedYear(pickerView), month: getSelectedMonth(pickerView))
        default: return 0
        }
        
      case .time:
        switch component {
        case 0: return PickerConstants.amPmOptions.count
        case 1: return PickerConstants.pickerViewRows
        case 2: return PickerConstants.minutes.count
        default: return 0
        }
      }
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
      let containerView = UIView()
      
      let label = UILabel()
      label.textAlignment = .center
      label.font = AMDFont.mediumMedium.uiFont
      label.textColor = .gray60
      label.translatesAutoresizingMaskIntoConstraints = false
      
      containerView.addSubview(label)
      
      NSLayoutConstraint.activate([
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
      ])
      
      switch pickerType {
      case .yearMonth:
        switch component {
        case 0: label.text = "\(PickerConstants.years[row])년"
        case 1: label.text = "\(PickerConstants.months[row])월"
        default: label.text = ""
        }
        
      case .yearMonthDay:
        switch component {
        case 0: label.text = "\(PickerConstants.years[row])년"
        case 1: label.text = "\(PickerConstants.months[row])월"
        case 2: label.text = "\(row + 1)일"
        default: label.text = ""
        }
        
      case .time:
        switch component {
        case 0: label.text = PickerConstants.amPmOptions[row]
        case 1: label.text = "\(hourValueForRow(row))시"
        case 2: label.text = String(format: "%02d분", PickerConstants.minutes[row])
        default: label.text = ""
        }
      }
      
      let isSelected = pickerView.selectedRow(inComponent: component) == row
      label.textColor = isSelected ? .gray95 : .gray60
      
      return containerView
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch pickerType {
      case .yearMonth:
        updateSelectedYearMonth(pickerView)
        
      case .yearMonthDay:
        updateSelectedDate(pickerView, changedComponent: component)
        
      case .time:
        if component == 1 {
          let currentHourValue = hourValueForRow(row)
          let newRow = rowForHourValue(currentHourValue)
          pickerView.selectRow(newRow, inComponent: component, animated: false)
        }
        
        updateSelectedTime(pickerView)
      }
      
      DispatchQueue.main.async {
        UIView.transition(with: pickerView, duration: 0.2, options: .transitionCrossDissolve) {
          pickerView.reloadComponent(component)
        }
      }
    }
  }
}

private extension AMDPicker.Coordinator {
  private func updateSelectedYearMonth(_ pickerView: UIPickerView) {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.day, .hour, .minute, .second], from: selectedDate)
    
    components.year = getSelectedYear(pickerView)
    components.month = getSelectedMonth(pickerView)
    
    // 선택된 월의 최대 일수 확인
    let maxDay = daysInMonth(year: components.year!, month: components.month!)
    if let currentDay = components.day, currentDay > maxDay {
      components.day = maxDay
    }
    
    if let newDate = calendar.date(from: components) {
      selectedDate = newDate
    }
  }
  
  private func updateSelectedDate(_ pickerView: UIPickerView, changedComponent: Int) {
    // 월이 변경되면 일수 업데이트
    if changedComponent == 0 || changedComponent == 1 {
      pickerView.reloadComponent(2)
      
      let maxDay = daysInMonth(year: getSelectedYear(pickerView), month: getSelectedMonth(pickerView))
      let currentDay = pickerView.selectedRow(inComponent: 2) + 1
      if currentDay > maxDay {
        pickerView.selectRow(maxDay - 1, inComponent: 2, animated: true)
      }
    }
    
    // 날짜 업데이트
    let calendar = Calendar.current
    var components = calendar.dateComponents([.hour, .minute, .second], from: selectedDate)
    
    components.year = getSelectedYear(pickerView)
    components.month = getSelectedMonth(pickerView)
    components.day = pickerView.selectedRow(inComponent: 2) + 1
    
    if let newDate = calendar.date(from: components) {
      selectedDate = newDate
    }
  }
    
  private func updateSelectedTime(_ pickerView: UIPickerView) {
    let calendar = Calendar.current
    
    // 기존 날짜 정보 유지
    var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
    
    // 오전/오후
    let amPmIndex = pickerView.selectedRow(inComponent: 0)
    let isAM = amPmIndex == 0
    
    // 시간
    let hourRow = pickerView.selectedRow(inComponent: 1)
    let hour12 = hourValueForRow(hourRow)
    
    // 분
    let minuteRow = pickerView.selectedRow(inComponent: 2)
    let minute = PickerConstants.minutes[minuteRow]
    
    // 12시간 → 24시간 변환
    let hour24: Int
    if isAM {
      hour24 = hour12 == 12 ? 0 : hour12 // 12AM → 0시, 나머지는 그대로
    } else {
      hour24 = hour12 == 12 ? 12 : hour12 + 12 // 12PM → 12시, 나머지는 +12
    }
    
    components.hour = hour24
    components.minute = minute
    components.second = 0
    
    if let newDate = calendar.date(from: components) {
      selectedDate = newDate
    }
  }
}

private extension AMDPicker.Coordinator {
  private func getSelectedYear(_ pickerView: UIPickerView) -> Int {
    let yearIndex = pickerView.selectedRow(inComponent: 0)
    return PickerConstants.years[yearIndex]
  }
  
  private func getSelectedMonth(_ pickerView: UIPickerView) -> Int {
    return pickerView.selectedRow(inComponent: 1) + 1
  }
  
  private func daysInMonth(year: Int, month: Int) -> Int {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: year, month: month)
    let date = calendar.date(from: dateComponents) ?? Date()
    let range = calendar.range(of: .day, in: .month, for: date)
    return range?.count ?? 0
  }
}

private extension AMDPicker.Coordinator {
  func rowForHourValue(_ hourValue: Int) -> Int {
    let valueIndex = hourValue - 1
    return PickerConstants.pickerViewMiddle + valueIndex
  }
  
  func hourValueForRow(_ row: Int) -> Int {
    return (row % PickerConstants.hours12.count) + 1
  }
}

// MARK: - Date Extensions
private extension Date {
  var year: Int {
    return Calendar.current.component(.year, from: self)
  }
  
  var month: Int {
    return Calendar.current.component(.month, from: self)
  }
  
  var day: Int {
    return Calendar.current.component(.day, from: self)
  }
  
  var isAM: Bool {
    let hour = Calendar.current.component(.hour, from: self)
    return hour < 12
  }
  
  var displayHour12: Int {
    let hour = Calendar.current.component(.hour, from: self)
    switch hour {
    case 0: return 12
    case 1...11: return hour
    case 12: return 12
    default: return hour - 12
    }
  }
  
  var minute: Int {
    return Calendar.current.component(.minute, from: self)
  }
}
