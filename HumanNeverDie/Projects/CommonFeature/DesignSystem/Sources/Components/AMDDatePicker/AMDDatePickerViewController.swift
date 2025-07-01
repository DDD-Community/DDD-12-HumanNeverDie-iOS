//
//  AMDDatePickerViewController.swift
//  DesignSystem
//
//  Created by 김규철 on 6/27/25.
//

import SwiftUI
import UIKit

private struct AMDDatePickerConstants {
  fileprivate static let years = Array(1970...Date().year)
  fileprivate static let months = Array(1...12)
  fileprivate static let amPmOptions = ["오전", "오후"]
  fileprivate static let hours12 = Array(1...12)
  fileprivate static let minutes = Array(0...59)
  
  fileprivate static let pickerViewRows = 10_000
  fileprivate static let pickerViewMiddle = ((pickerViewRows / hours12.count) / 2) * hours12.count
}

public final class AMDDatePickerViewController: UIViewController {
  private let picker = UIPickerView()
  private let pickerType: AMDDatePicker.PickerType
  
  var selectedDate: Date {
    didSet {
      updatePickerValues()
    }
  }
  
  var onDateChanged: ((Date) -> Void)?
  
  public init(
    selectedDate: Date,
    pickerType: AMDDatePicker.PickerType
  ) {
    self.selectedDate = selectedDate
    self.pickerType = pickerType
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupPickerView()
    updatePickerValues()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    picker.subviews[1].backgroundColor = .clear
  }
  
  private func setupPickerView() {
    picker.delegate = self
    picker.dataSource = self
    picker.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(picker)
    
    NSLayoutConstraint.activate([
      picker.topAnchor.constraint(equalTo: view.topAnchor),
      picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      picker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - Private Methods
private extension AMDDatePickerViewController {
  func updatePickerValues() {
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
      
      let targetRow = rowForHourValue(currentDate.displayHour12)
      picker.selectRow(targetRow, inComponent: 1, animated: false)
      
      picker.selectRow(currentDate.minute, inComponent: 2, animated: false)
    }
  }
  
  func updateSelectedYearMonth(_ pickerView: UIPickerView) {
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
      onDateChanged?(newDate)
    }
  }
  
  func updateSelectedDate(_ pickerView: UIPickerView, changedComponent: Int) {
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
      onDateChanged?(newDate)
    }
  }
  
  func updateSelectedTime(_ pickerView: UIPickerView) {
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
    let minute = AMDDatePickerConstants.minutes[minuteRow]
    
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
      onDateChanged?(newDate)
    }
  }
  
  func getSelectedYear(_ pickerView: UIPickerView) -> Int {
    let yearIndex = pickerView.selectedRow(inComponent: 0)
    return AMDDatePickerConstants.years[yearIndex]
  }
  
  func getSelectedMonth(_ pickerView: UIPickerView) -> Int {
    return pickerView.selectedRow(inComponent: 1) + 1
  }
  
  func daysInMonth(year: Int, month: Int) -> Int {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: year, month: month)
    let date = calendar.date(from: dateComponents) ?? Date()
    let range = calendar.range(of: .day, in: .month, for: date)
    return range?.count ?? 0
  }
  
  func rowForHourValue(_ hourValue: Int) -> Int {
    let valueIndex = hourValue - 1
    return AMDDatePickerConstants.pickerViewMiddle + valueIndex
  }
  
  func hourValueForRow(_ row: Int) -> Int {
    return (row % AMDDatePickerConstants.hours12.count) + 1
  }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension AMDDatePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
      case 0: return AMDDatePickerConstants.years.count
      case 1: return AMDDatePickerConstants.months.count
      default: return 0
      }
      
    case .yearMonthDay:
      switch component {
      case 0: return AMDDatePickerConstants.years.count
      case 1: return AMDDatePickerConstants.months.count
      case 2: return daysInMonth(year: getSelectedYear(pickerView), month: getSelectedMonth(pickerView))
      default: return 0
      }
      
    case .time:
      switch component {
      case 0: return AMDDatePickerConstants.amPmOptions.count
      case 1: return AMDDatePickerConstants.pickerViewRows
      case 2: return AMDDatePickerConstants.minutes.count
      default: return 0
      }
    }
  }
  
  public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let containerView = UIView()
    
    let numberOfComponents = pickerView.numberOfComponents
    let totalPadding: CGFloat = 40
    let componentSpacing: CGFloat = CGFloat(numberOfComponents - 1) * 10
    let availableWidth = pickerView.bounds.width - totalPadding - componentSpacing
    let componentWidth = availableWidth / CGFloat(numberOfComponents)
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: componentWidth, height: 36))
    label.textAlignment = .center
    label.font = AMDFont.mediumMedium.uiFont
    label.textColor = .gray85
    label.layer.cornerRadius = 8
    label.clipsToBounds = true
    label.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      label.widthAnchor.constraint(equalToConstant: componentWidth),
      label.heightAnchor.constraint(equalToConstant: 36)
    ])
    
    switch pickerType {
    case .yearMonth:
      switch component {
      case 0: label.text = "\(AMDDatePickerConstants.years[row])년"
      case 1: label.text = "\(AMDDatePickerConstants.months[row])월"
      default: label.text = ""
      }
      
    case .yearMonthDay:
      switch component {
      case 0: label.text = "\(AMDDatePickerConstants.years[row])년"
      case 1: label.text = "\(AMDDatePickerConstants.months[row])월"
      case 2: label.text = "\(row + 1)일"
      default: label.text = ""
      }
      
    case .time:
      switch component {
      case 0: label.text = AMDDatePickerConstants.amPmOptions[row]
      case 1: label.text = "\(hourValueForRow(row))시"
      case 2: label.text = String(format: "%02d분", AMDDatePickerConstants.minutes[row])
      default: label.text = ""
      }
    }
    
    let isSelected = pickerView.selectedRow(inComponent: component) == row
    
    label.backgroundColor = isSelected ? .gray15 : UIColor.clear
    label.textColor = isSelected ? .gray85 : .gray60
    
    return containerView
  }
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    DispatchQueue.main.async {
      UIView.transition(with: pickerView, duration: 0.2, options: .transitionCrossDissolve) {
        pickerView.reloadComponent(component)
      }
    }
    
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
