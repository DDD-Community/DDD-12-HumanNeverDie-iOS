//
//  AMDCalendarFactory.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/26/25.
//

import SwiftUI

@MainActor
public struct AMDCalendarFactory {
  public static func createMonth(
    currentDate: Date,
    sugarIntakeRecordData: [SugarIntakeRecord],
    userSugarTargetValue: Int,
    selectedDate: Binding<Date?>
  ) -> some View {
    let viewModel = AMDMonthCalendarViewModel(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue
    )
    return AMDMonthCalendarView(viewModel: viewModel, selectedDate: selectedDate)
  }
  
  public static func createWeekly(
    currentDate: Date,
    sugarIntakeRecordData: [SugarIntakeRecord],
    userSugarTargetValue: Int,
    selectedDate: Binding<Date?>
  ) -> some View {
    let viewModel = AMDWeekCalendarViewModel(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue
    )
    return AMDWeekCalendarView(viewModel: viewModel, selectedDate: selectedDate)
  }
}
