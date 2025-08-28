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
  fileprivate static let minutes = Array(stride(from: 0, to: 60, by: 5))
  
  fileprivate static let pickerViewRows = 10_000
  fileprivate static let pickerViewMiddle = ((pickerViewRows / hours12.count) / 2) * hours12.count
}

public final class AMDDatePickerViewController: UIViewController {
  private let picker = UIPickerView()
  private let pickerType: AMDDatePicker.PickerType
  private let isAgeRestricted: Bool
  
  var selectedDate: Date {
    didSet {
      updatePickerValues()
    }
  }
  
  var onDateChanged: ((Date) -> Void)?
  
  private var maxSelectableYear: Int {
    if isAgeRestricted == true {
      let maxDate = Calendar.current.date(byAdding: .year, value: -14, to: Date()) ?? Date()
      return Calendar.current.component(.year, from: maxDate)
    }
    return Date().year
  }
  
  public init(
    selectedDate: Date,
    pickerType: AMDDatePicker.PickerType,
    isAgeRestricted: Bool
  ) {
    self.pickerType = pickerType
    self.isAgeRestricted = isAgeRestricted
    
    // 14세 제한이 있는 경우 선택된 날짜가 유효한지 확인
    if isAgeRestricted {
      let maxDate = Calendar.current.date(byAdding: .year, value: -14, to: Date()) ?? Date()
      
      // 전달받은 날짜가 최대 선택 가능한 날짜보다 미래인 경우 최대 날짜로 조정
      if selectedDate > maxDate {
        self.selectedDate = maxDate
      } else {
        self.selectedDate = selectedDate
      }
    } else {
      self.selectedDate = selectedDate
    }
    
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
  var availableYears: [Int] {
    if isAgeRestricted == true {
      return Array(1970...maxSelectableYear)
    }
    return AMDDatePickerConstants.years
  }
  
  // 정확한 14세 제한 날짜
  private var maxSelectableDate: Date {
    if isAgeRestricted == true {
      return Calendar.current.date(byAdding: .year, value: -14, to: Date()) ?? Date()
    }
    return Date()
  }
  
  // 현재 선택된 년도에 따른 사용 가능한 월 배열
  var availableMonths: [Int] {
    guard isAgeRestricted == true else {
      return AMDDatePickerConstants.months
    }
    
    let selectedYear = getSelectedYear(picker)
    let maxDate = maxSelectableDate
    
    if selectedYear < maxDate.year {
      return AMDDatePickerConstants.months
    } else if selectedYear == maxDate.year {
      return Array(1...maxDate.month)
    } else {
      return [1]
    }
  }
  
  // 현재 선택된 년월에 따른 사용 가능한 일수
  func availableDays(for year: Int, month: Int) -> Int {
    guard isAgeRestricted == true else {
      return daysInMonth(year: year, month: month)
    }
    
    let maxDate = maxSelectableDate
    let maxDayInMonth = daysInMonth(year: year, month: month)
    
    if year < maxDate.year {
      return maxDayInMonth
    } else if year == maxDate.year && month < maxDate.month {
      return maxDayInMonth
    } else if year == maxDate.year && month == maxDate.month {
      return min(maxDayInMonth, maxDate.day)
    } else {
      return 1
    }
  }
  
  // 14세 제한에 맞는 유효한 날짜를 반환하는 헬퍼 메서드
  private func getValidDateForAgeRestriction(_ date: Date) -> Date {
    guard isAgeRestricted else { return date }
    
    let maxDate = maxSelectableDate
    
    // 전달받은 날짜가 최대 선택 가능한 날짜보다 미래면 최대 날짜 반환
    if date > maxDate {
      return maxDate
    }
    
    // 전달받은 날짜가 1970년보다 이전이면 최대 날짜 반환
    let minDate = Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1)) ?? Date()
    if date < minDate {
      return maxDate
    }
    
    return date
  }

  func updatePickerValues() {
    let currentDate = selectedDate
    
    switch pickerType {
    case .yearMonth:
      // 14세 제한이 있는 경우 유효한 범위 내의 날짜로 조정
      let validDate = getValidDateForAgeRestriction(currentDate)
      
      let yearIndex = availableYears.firstIndex(of: validDate.year) ?? (availableYears.count - 1)
      picker.selectRow(yearIndex, inComponent: 0, animated: false)
      
      // 선택된 년도에 맞는 available months 다시 계산
      let monthIndex = availableMonths.firstIndex(of: validDate.month) ?? (availableMonths.count - 1)
      picker.selectRow(monthIndex, inComponent: 1, animated: false)
      
    case .yearMonthDay:
      // 14세 제한이 있는 경우 유효한 범위 내의 날짜로 조정
      let validDate = getValidDateForAgeRestriction(currentDate)
      
      let yearIndex = availableYears.firstIndex(of: validDate.year) ?? (availableYears.count - 1)
      picker.selectRow(yearIndex, inComponent: 0, animated: false)
      
      // 선택된 년도에 맞는 available months 다시 계산
      let monthIndex = availableMonths.firstIndex(of: validDate.month) ?? (availableMonths.count - 1)
      picker.selectRow(monthIndex, inComponent: 1, animated: false)
      
      // 유효한 일수 범위 내에서 선택
      let maxDays = availableDays(for: validDate.year, month: validDate.month)
      let dayIndex = min(validDate.day - 1, maxDays - 1)
      picker.selectRow(dayIndex, inComponent: 2, animated: false)
      
    case .time:
      picker.selectRow(currentDate.isAM ? 0 : 1, inComponent: 0, animated: false)
      
      let targetRow = rowForHourValue(currentDate.displayHour12)
      picker.selectRow(targetRow, inComponent: 1, animated: false)
      
      // 현재 분을 5분 단위로 반올림해서 가장 가까운 값 선택
      let currentMinute = currentDate.minute
      let roundedMinute = (currentMinute / 5) * 5 // 5분 단위로 반올림
      let minuteIndex = AMDDatePickerConstants.minutes.firstIndex(of: roundedMinute) ?? 0
      picker.selectRow(minuteIndex, inComponent: 2, animated: false)
    }
  }
  
  func updateSelectedYearMonth(_ pickerView: UIPickerView) {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.day, .hour, .minute, .second], from: selectedDate)
    
    components.year = getSelectedYear(pickerView)
    components.month = getSelectedMonth(pickerView)
    
    // 선택된 월의 최대 일수 확인 (14세 제한 고려)
    let maxDay = availableDays(for: components.year!, month: components.month!)
    if let currentDay = components.day, currentDay > maxDay {
      components.day = maxDay
    }
    
    if let newDate = calendar.date(from: components) {
      selectedDate = newDate
      onDateChanged?(newDate)
    }
  }
  
  func updateSelectedDate(_ pickerView: UIPickerView, changedComponent: Int) {
    // 년도나 월이 변경되면 월과 일 컴포넌트 업데이트
    if changedComponent == 0 { // 년도 변경
      let selectedYear = getSelectedYear(pickerView)
      let maxDate = maxSelectableDate
      
      // 현재 날짜 기준으로 조정할지 결정
      let shouldAdjustToCurrentDate = isAgeRestricted && selectedYear >= maxDate.year
      
      pickerView.reloadComponent(1) // 월 리로드
      pickerView.reloadComponent(2) // 일 리로드
      
      if shouldAdjustToCurrentDate {
        // 현재 날짜의 월과 일로 조정
        let targetMonth = maxDate.month
        let targetDay = maxDate.day
        
        // 사용 가능한 월 범위에서 현재 월 찾기
        let availableMonthsArray = availableMonths
        if let monthIndex = availableMonthsArray.firstIndex(of: targetMonth) {
          pickerView.selectRow(monthIndex, inComponent: 1, animated: true)
        } else {
          // 현재 월이 없으면 마지막 사용 가능한 월 선택
          pickerView.selectRow(availableMonthsArray.count - 1, inComponent: 1, animated: true)
        }
        
        // 일 조정
        let finalMonth = getSelectedMonth(pickerView)
        let maxAvailableDay = availableDays(for: selectedYear, month: finalMonth)
        let finalDay = min(targetDay, maxAvailableDay)
        pickerView.selectRow(finalDay - 1, inComponent: 2, animated: true)
      } else {
        // 현재 선택된 월이 사용 가능한 범위를 벗어나면 조정
        let availableMonthsArray = availableMonths
        let currentMonthRow = pickerView.selectedRow(inComponent: 1)
        if currentMonthRow >= availableMonthsArray.count {
          pickerView.selectRow(availableMonthsArray.count - 1, inComponent: 1, animated: true)
        }
        
        // 일수 조정
        let selectedMonth = getSelectedMonth(pickerView)
        let maxDay = availableDays(for: selectedYear, month: selectedMonth)
        let currentDay = pickerView.selectedRow(inComponent: 2) + 1
        if currentDay > maxDay {
          pickerView.selectRow(maxDay - 1, inComponent: 2, animated: true)
        }
      }
    } else if changedComponent == 1 { // 월 변경
      pickerView.reloadComponent(2) // 일 리로드
      
      // 일수 조정
      let selectedYear = getSelectedYear(pickerView)
      let selectedMonth = getSelectedMonth(pickerView)
      let maxDay = availableDays(for: selectedYear, month: selectedMonth)
      let currentDay = pickerView.selectedRow(inComponent: 2) + 1
      if currentDay > maxDay {
        pickerView.selectRow(maxDay - 1, inComponent: 2, animated: true)
      }
    }
    
    // 최종 날짜 업데이트
    let calendar = Calendar.current
    var components = calendar.dateComponents([.hour, .minute, .second], from: selectedDate)
    
    let finalYear = getSelectedYear(pickerView)
    let finalMonth = getSelectedMonth(pickerView)
    let maxDay = availableDays(for: finalYear, month: finalMonth)
    let finalDay = min(pickerView.selectedRow(inComponent: 2) + 1, maxDay)
    
    components.year = finalYear
    components.month = finalMonth
    components.day = finalDay
    
    if let newDate = calendar.date(from: components) {
      selectedDate = newDate
      onDateChanged?(newDate)
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
    
    // 분 (5분 단위)
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
    return availableYears[yearIndex]
  }
  
  func getSelectedMonth(_ pickerView: UIPickerView) -> Int {
    let monthIndex = pickerView.selectedRow(inComponent: 1)
    let availableMonthsArray = availableMonths
    
    // 인덱스가 유효한 범위를 벗어나지 않도록 보장
    guard monthIndex < availableMonthsArray.count else {
      return availableMonthsArray.last ?? 1
    }
    
    return availableMonthsArray[monthIndex]
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
      case 0: return availableYears.count
      case 1: return availableMonths.count
      default: return 0
      }
      
    case .yearMonthDay:
      switch component {
      case 0: return availableYears.count
      case 1: return availableMonths.count
      case 2:
        // 현재 선택된 년도와 월을 기준으로 일수 계산
        let selectedYear = availableYears.indices.contains(pickerView.selectedRow(inComponent: 0)) ?
          availableYears[pickerView.selectedRow(inComponent: 0)] :
          (availableYears.last ?? Date().year)
        
        let availableMonthsArray = availableMonths
        let selectedMonth = availableMonthsArray.indices.contains(pickerView.selectedRow(inComponent: 1)) ?
          availableMonthsArray[pickerView.selectedRow(inComponent: 1)] :
          (availableMonthsArray.last ?? Date().month)
        
        return availableDays(for: selectedYear, month: selectedMonth)
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
      case 0:
        if row < availableYears.count {
          label.text = "\(availableYears[row])년"
        } else {
          label.text = ""
        }
      case 1:
        if row < availableMonths.count {
          label.text = "\(availableMonths[row])월"
        } else {
          label.text = ""
        }
      default: label.text = ""
      }
      
    case .yearMonthDay:
      switch component {
      case 0:
        if row < availableYears.count {
          label.text = "\(availableYears[row])년"
        } else {
          label.text = ""
        }
      case 1:
        if row < availableMonths.count {
          label.text = "\(availableMonths[row])월"
        } else {
          label.text = ""
        }
      case 2:
        let selectedYear = getSelectedYear(pickerView)
        let selectedMonth = getSelectedMonth(pickerView)
        let maxDays = availableDays(for: selectedYear, month: selectedMonth)
        if row < maxDays {
          label.text = "\(row + 1)일"
        } else {
          label.text = ""
        }
      default: label.text = ""
      }
      
    case .time:
      switch component {
      case 0:
        if row < AMDDatePickerConstants.amPmOptions.count {
          label.text = AMDDatePickerConstants.amPmOptions[row]
        } else {
          label.text = ""
        }
      case 1: label.text = "\(hourValueForRow(row))시"
      case 2:
        if row < AMDDatePickerConstants.minutes.count {
          label.text = String(format: "%02d분", AMDDatePickerConstants.minutes[row])
        } else {
          label.text = ""
        }
      default: label.text = ""
      }
    }
    
    let isSelected = pickerView.selectedRow(inComponent: component) == row
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
