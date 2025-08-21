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
    userSugarTargetValue: Binding<Int>,
    selectedDate: Binding<Date?>,
    onTapTitle: @escaping () -> Void,
    onMonthChanged: @escaping (Date) -> Void
  ) -> some View {
    AMDMonthCalendarView(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue,
      selectedDate: selectedDate,
      onTapTitle: onTapTitle,
      onMonthChanged: onMonthChanged
    )
  }
  
  public static func createWeekly(
    currentDate: Date,
    sugarIntakeRecordData: [SugarIntakeRecord],
    userSugarTargetValue: Binding<Int>,
    selectedDate: Binding<Date?>,
    onTapTitle: @escaping () -> Void,
    onWeekChanged: @escaping (Date) -> Void
  ) -> some View {
    AMDWeekCalendarView(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue,
      selectedDate: selectedDate,
      onTapTitle: onTapTitle,
      onWeekChanged: onWeekChanged
    )
  }
}
