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
    defaultValue: Int
  ) -> some View {
    let viewModel = AMDCalendarViewModel(
      currentDate: currentDate,
      valueByDate: valueByDate,
      defaultValue: defaultValue
    )
    return AMDCalendar(viewModel: viewModel)
  }
}
