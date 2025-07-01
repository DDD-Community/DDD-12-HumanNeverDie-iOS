//
//  AMDProgressDemoView.swift
//  DesignSystem
//
//  Created by 김규철 on 6/24/25.
//

import SwiftUI

import DesignSystem

struct AMDProgressDemoView: View {
  @State private var glucose1: Double = 0.25
  @State private var glucose2: Double = 0.5
  @State private var glucose3: Double = 0.75
  @State private var glucose4: Double = 0.33
  @State private var glucose5: Double = 0.66
  @State private var glucose6: Double = 0.9
  @State private var glucose7: Double = 0.1
  @State private var glucose8: Double = 0.45
  @State private var glucose9: Double = 0.8
  @State private var glucose10: Double = 0.15
  @State private var glucose11: Double = 0.55
  @State private var glucose12: Double = 0.95
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {
        animationButtonSection
        smallTypeSection
        mediumTypeSection
        variantSection
        combinationSection
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 32)
    }
  }
  
  private var animationButtonSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Animation Test")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      HStack(spacing: 12) {
        Button("Random Values") {
          updateAllValues()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.primary)
        .foregroundColor(.white)
        .cornerRadius(8)
        
        Button("Reset Values") {
          resetAllValues()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.gray40)
        .foregroundColor(.white)
        .cornerRadius(8)
      }
    }
  }
  
  private var smallTypeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Small Type")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      ProgressItem(
        title: "Healthy Status",
        glucose: glucose1,
        type: .small,
        variant: .healthy
      )
      
      ProgressItem(
        title: "Warning Status",
        glucose: glucose2,
        type: .small,
        variant: .warning
      )
      
      ProgressItem(
        title: "Danger Status",
        glucose: glucose3,
        type: .small,
        variant: .danger
      )
    }
  }
  
  private var mediumTypeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Medium Type")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      ProgressItem(
        title: "Healthy Status",
        glucose: glucose4,
        type: .medium,
        variant: .healthy
      )
      
      ProgressItem(
        title: "Warning Status",
        glucose: glucose5,
        type: .medium,
        variant: .warning
      )
      
      ProgressItem(
        title: "Danger Status",
        glucose: glucose6,
        type: .medium,
        variant: .danger
      )
    }
  }
  
  private var variantSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Status Variants")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      ProgressItem(
        title: "Healthy (Primary Lighter)",
        glucose: glucose7,
        type: .medium,
        variant: .healthy
      )
      
      ProgressItem(
        title: "Warning (Phase 2 Gradient)",
        glucose: glucose8,
        type: .medium,
        variant: .warning
      )
      
      ProgressItem(
        title: "Danger (Phase 3 Gradient)",
        glucose: glucose9,
        type: .medium,
        variant: .danger
      )
    }
  }
  
  private var combinationSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Combination Examples")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      ProgressItem(
        title: "Small + Healthy",
        glucose: glucose10,
        isStatusLabelHidden: true,
        type: .small,
        variant: .healthy
      )
      
      ProgressItem(
        title: "Medium + Warning",
        glucose: glucose11,
        isStatusLabelHidden: true,
        type: .medium,
        variant: .warning
      )
      
      ProgressItem(
        title: "Small + Danger",
        glucose: glucose12,
        isStatusLabelHidden: true,
        type: .small,
        variant: .danger
      )
    }
  }
  
  private func updateAllValues() {
    glucose1 = Double.random(in: 0.1...0.3)
    glucose2 = Double.random(in: 0.4...0.6)
    glucose3 = Double.random(in: 0.7...0.9)
    glucose4 = Double.random(in: 0.2...0.4)
    glucose5 = Double.random(in: 0.5...0.7)
    glucose6 = Double.random(in: 0.8...1.0)
    glucose7 = Double.random(in: 0.05...0.25)
    glucose8 = Double.random(in: 0.3...0.5)
    glucose9 = Double.random(in: 0.6...0.8)
    glucose10 = Double.random(in: 0.1...0.2)
    glucose11 = Double.random(in: 0.4...0.6)
    glucose12 = Double.random(in: 0.8...1.0)
  }
  
  private func resetAllValues() {
    glucose1 = 0.25
    glucose2 = 0.5
    glucose3 = 0.75
    glucose4 = 0.33
    glucose5 = 0.66
    glucose6 = 0.9
    glucose7 = 0.1
    glucose8 = 0.45
    glucose9 = 0.8
    glucose10 = 0.15
    glucose11 = 0.55
    glucose12 = 0.95
  }
}

private struct ProgressItem: View {
  private let title: String
  private let glucose: Double
  private let isStatusLabelHidden: Bool
  private let type: AMDProgress.ProgressType
  private let variant: AMDStatusVariant
  
  init(
    title: String,
    glucose: Double,
    isStatusLabelHidden: Bool = false,
    type: AMDProgress.ProgressType,
    variant: AMDStatusVariant
  ) {
    self.title = title
    self.glucose = glucose
    self.isStatusLabelHidden = isStatusLabelHidden
    self.type = type
    self.variant = variant
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(title)
        .amdFont(.smallRegular)
        .foregroundColor(.gray40)
      
      AMDProgress(
        glucose: glucose,
        isStatusLabelHidden: isStatusLabelHidden,
        type: type,
        variant: variant
      )
      
      Text("Value: \(String(format: "%.2f", glucose))")
        .amdFont(.xsmallRegular)
        .foregroundColor(.gray60)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(16)
    .background(Color.gray5)
    .cornerRadius(8)
  }
}

#Preview {
  AMDProgressDemoView()
}
