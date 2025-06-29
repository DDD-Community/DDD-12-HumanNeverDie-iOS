//
//  AMDCalendarCommonViews.swift
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
      Button(action: onTap) {
        HStack(spacing: 0) {
          Text(title)
            .amdFont(.xlargeBold)
            .foregroundColor(Color.gray100)

          Image(systemName: "chevron.down")
            .foregroundColor(Color.gray50)
            .padding(9)
          
          Spacer()
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 14)
    }
    
}

public struct CalendarWeekdayTitleView: View {
  let items: [AMDWeekdayTile]
  let columns: [GridItem]

  public var body: some View {
    LazyVGrid(columns: columns, spacing: 15) {
      ForEach(items) { weekday in
        Text(weekday.label)
          .amdFont(.mediumMedium)
          .fontWeight(.semibold)
          .foregroundColor(weekday.color)
          .frame(width: 44, height: 20)
      }
    }
  }
}


public struct CalendarDayView: View {
  public let value: DateValue
  public let isToday: Bool
  public let isSelected: Bool
  public let textColor: Color
  public let stateIcon: Image?
  public let onTap: () -> Void

  public init(
    value: DateValue,
    isToday: Bool,
    isSelected: Bool,
    textColor: Color,
    stateIcon: Image? = nil,
    onTap: @escaping () -> Void
  ) {
    self.value = value
    self.isToday = isToday
    self.isSelected = isSelected
    self.textColor = textColor
    self.stateIcon = stateIcon
    self.onTap = onTap
  }

  public var body: some View {
    VStack(spacing: 0) {
      if value.day != -1 {
        ZStack {
          if let icon = stateIcon {
            icon
              .resizable()
              .frame(width: 36, height: 36)
          }
          
          Text("\(value.day)")
            .amdFont(.mediumMedium)
            .foregroundColor(textColor)
        }
        .frame(width: 44, height: 44)
        .padding(2)
        .background(
          Group {
            if isSelected {
              RoundedRectangle(cornerRadius: 13)
                .fill(Color.gray10)
            } else {
              Color.clear
            }
          }
        )
        .overlay(
          (!isSelected && isToday) ?
          RoundedRectangle(cornerRadius: 13)
            .stroke(Color.gray25, lineWidth: 1) : nil
        )
        .onTapGesture {
          onTap()
        }
      }
    }
    .frame(maxWidth: .infinity)
  }
}
