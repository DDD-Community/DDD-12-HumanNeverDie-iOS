//
//  AMDCalenderFactory.swift
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
    userSugarTargetValue: Int
  ) -> some View {
    let viewModel = AMDCalendarViewModel(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue
    )
    return AMDCalendar(viewModel: viewModel)
  }
}
