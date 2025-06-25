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
    valueByDate: [Date: Int],
    userSugarTargetValue: Int
  ) -> some View {
    let viewModel = AMDCalendarViewModel(
      currentDate: currentDate,
      valueByDate: valueByDate,
      userSugarTargetValue: userSugarTargetValue
    )
    return AMDCalendar(viewModel: viewModel)
  }
}
