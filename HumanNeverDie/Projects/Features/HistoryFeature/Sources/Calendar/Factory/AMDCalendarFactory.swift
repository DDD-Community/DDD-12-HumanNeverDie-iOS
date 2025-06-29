//
//  AMDCalendarFactory.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/26/25.
//

import SwiftUI

@MainActor
public struct AMDCalendarFactory {
  public static func create(
    currentDate: Date,
    sugarIntakeRecordData: [SugarIntakeRecord],
    userSugarTargetValue: Int,
    selectedDate: Binding<Date?>
  ) -> some View {
    let viewModel = AMDCalendarViewModel(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue
    )
    return AMDCalendarView(viewModel: Bindable(viewModel), selectedDate: selectedDate)
  }
  
  public static func createWeekly(
    currentDate: Date,
    sugarIntakeRecordData: [SugarIntakeRecord],
    userSugarTargetValue: Int,
    selectedDate: Binding<Date?>
  ) -> some View {
    let viewModel = AMDCalendarViewModel(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue
    )
    return AMDWeekCalendarView(viewModel: Bindable(viewModel), selectedDate: selectedDate)
  }
}
