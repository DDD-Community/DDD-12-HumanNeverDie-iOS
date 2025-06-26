//
//  CalendarCommonViews.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/27/25.
//

import SwiftUI
import DesignSystem

public struct CalendarTitleView: View {
  let title: String
  let onTap: () -> Void

  public init(title: String, onTap: @escaping () -> Void) {
    self.title = title
    self.onTap = onTap
  }

  public var body: some View {
    HStack {
      Button(action: onTap) {
        HStack(spacing: 4) {
          Text(title)
            .amdFont(.xlargeBold)
            .foregroundColor(Color.gray100)

          Image(systemName: "chevron.down")
            .foregroundColor(Color.gray50)
        }
      }
      Spacer()
    }
    .padding(.horizontal)
  }
}

public struct CalendarWeekdayView: View {
  let items: [WeekdayValue]
  let columns: [GridItem]

  public init(items: [WeekdayValue], columns: [GridItem]) {
    self.items = items
    self.columns = columns
  }

  public var body: some View {
    LazyVGrid(columns: columns, spacing: 15) {
      ForEach(items, id: \.id) { weekday in
        Text(weekday.label)
          .amdFont(.mediumMedium)
          .fontWeight(.semibold)
          .foregroundColor(weekday.color)
          .frame(width: 44, height: 20)
      }
    }
  }
}
