//
//  AMDOptionView.swift
//  DesignSystem
//
//  Created by Seulki Lee on 7/13/25.
//

import SwiftUI

public struct AMDSugarAndCalories {
  public let suger: Int
  public let caloriesText: Int
  
  public init(suger: Int, caloriesText: Int) {
    self.suger = suger
    self.caloriesText = caloriesText
  }
}

public struct AMDOptionButton: View {
  private let title: String
  private let subtitle: String?
  private let subtitleBadgeType: AMDBadge.BadgeType?
  private let trailingText: String?
  private let sugarAndCaloriesText: AMDSugarAndCalories?
  private let isSelected: Bool
  private let action: () -> Void
  
  public init(
    title: String,
    subtitle: String? = nil,
    subtitleBadgeType: AMDBadge.BadgeType? = nil,
    trailingText: String? = nil,
    sugarAndCaloriesText: AMDSugarAndCalories? = nil,
    isSelected: Bool,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.subtitle = subtitle
    self.subtitleBadgeType = subtitleBadgeType
    self.sugarAndCaloriesText = sugarAndCaloriesText
    self.trailingText = trailingText
    self.isSelected = isSelected
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      HStack(spacing: 16) {
        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
          .foregroundColor(isSelected ? .amdPrimary : .gray25)
          .font(.system(size: 24))
        
        VStack(alignment: .leading, spacing: 4) {
          HStack(spacing: 8) {
            Text(title)
              .amdFont(.mediumBold)
              .foregroundColor(.gray85)
            
            if let subtitle = subtitle, let badgeType = subtitleBadgeType {
              AMDBadge(title: subtitle, type: badgeType)
            }
          }
          
          if let subtitle = subtitle, subtitleBadgeType == nil {
            Text(subtitle)
              .amdFont(.smallRegular)
              .foregroundColor(.gray60)
          }
        }
        
        Spacer()
        
        if let trailingText = trailingText {
          Text(trailingText)
            .amdFont(.mediumRegular)
            .foregroundColor(.primaryDarker)
        }
        
        if let sugarAndCaloriesInfo = sugarAndCaloriesText {
          HStack(spacing: 4) {
            Text("\(sugarAndCaloriesInfo.suger)g")
              .amdFont(.mediumBold)
              .foregroundColor(.gray85)
            
            Text("|")
              .amdFont(.mediumRegular)
              .foregroundColor(.gray40)
            
            Text("\(sugarAndCaloriesInfo.caloriesText)kcal")
              .amdFont(.mediumRegular)
              .foregroundColor(.gray70)
          }
        }
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(isSelected ? .amdPrimary.opacity(0.1) : .gray0)
          .stroke(isSelected ? .amdPrimary : .gray25, lineWidth: 1)
      )
    }
    .buttonStyle(PlainButtonStyle())
  }
}
