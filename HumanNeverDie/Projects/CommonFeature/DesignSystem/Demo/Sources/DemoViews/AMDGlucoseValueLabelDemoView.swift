//
//  AMDGlucoseValueLabelDemoView.swift
//  DesignSystem
//
//  Created by 김규철 on 6/23/25.
//

import SwiftUI

import DesignSystem

struct AMDGlucoseValueLabelDemoView: View {
  @State private var consumedGlucose1: Double = 25.0
  @State private var consumedGlucose2: Double = 35.0
  @State private var consumedGlucose3: Double = 45.0
  @State private var consumedGlucose4: Double = 15.0
  @State private var consumedGlucose5: Double = 25.0
  @State private var consumedGlucose6: Double = 35.0
  @State private var consumedGlucose7: Double = 20.0
  @State private var consumedGlucose8: Double = 30.0
  @State private var consumedGlucose9: Double = 40.0
  @State private var consumedGlucose10: Double = 18.5
  @State private var consumedGlucose11: Double = 28.3
  @State private var consumedGlucose12: Double = 38.7
  @State private var consumedGlucose13: Double = 12.0
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {
        animationButtonSection
        cardTypeSection
        progressTypeSection
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
  
  private var cardTypeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Card Type")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      GlucoseValueItem(
        title: "Healthy Status",
        consumedGlucose: consumedGlucose1,
        baseGlucose: 25.0,
        type: .card,
        variant: .healthy
      )
      
      GlucoseValueItem(
        title: "Warning Status",
        consumedGlucose: consumedGlucose2,
        baseGlucose: 25.0,
        type: .card,
        variant: .warning
      )
      
      GlucoseValueItem(
        title: "Danger Status",
        consumedGlucose: consumedGlucose3,
        baseGlucose: 25.0,
        type: .card,
        variant: .danger
      )
    }
  }
  
  private var progressTypeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Progress Type")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      GlucoseValueItem(
        title: "Healthy Status",
        consumedGlucose: consumedGlucose4,
        baseGlucose: 15.0,
        type: .progress,
        variant: .healthy
      )
      
      GlucoseValueItem(
        title: "Warning Status",
        consumedGlucose: consumedGlucose5,
        baseGlucose: 15.0,
        type: .progress,
        variant: .warning
      )
      
      GlucoseValueItem(
        title: "Danger Status",
        consumedGlucose: consumedGlucose6,
        baseGlucose: 15.0,
        type: .progress,
        variant: .danger
      )
    }
  }
  
  private var variantSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Status Variants")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      GlucoseValueItem(
        title: "Healthy (Primary Darker)",
        consumedGlucose: consumedGlucose7,
        baseGlucose: 20.0,
        type: .card,
        variant: .healthy
      )
      
      GlucoseValueItem(
        title: "Warning (Yellow Darker)",
        consumedGlucose: consumedGlucose8,
        baseGlucose: 20.0,
        type: .card,
        variant: .warning
      )
      
      GlucoseValueItem(
        title: "Danger (Red Darker)",
        consumedGlucose: consumedGlucose9,
        baseGlucose: 20.0,
        type: .card,
        variant: .danger
      )
    }
  }
  
  private var combinationSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Combination Examples")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      GlucoseValueItem(
        title: "Card + Healthy",
        consumedGlucose: consumedGlucose10,
        baseGlucose: 18.5,
        type: .card,
        variant: .healthy
      )
      
      GlucoseValueItem(
        title: "Progress + Warning",
        consumedGlucose: consumedGlucose11,
        baseGlucose: 18.5,
        type: .progress,
        variant: .warning
      )
      
      GlucoseValueItem(
        title: "Card + Danger",
        consumedGlucose: consumedGlucose12,
        baseGlucose: 18.5,
        type: .card,
        variant: .danger
      )
      
      GlucoseValueItem(
        title: "Progress + Healthy",
        consumedGlucose: consumedGlucose13,
        baseGlucose: 12.0,
        type: .progress,
        variant: .healthy
      )
    }
  }
  
  private func updateAllValues() {
      consumedGlucose1 = Double.random(in: 20...30)
      consumedGlucose2 = Double.random(in: 30...40)
      consumedGlucose3 = Double.random(in: 40...50)
      consumedGlucose4 = Double.random(in: 10...20)
      consumedGlucose5 = Double.random(in: 20...30)
      consumedGlucose6 = Double.random(in: 30...40)
      consumedGlucose7 = Double.random(in: 15...25)
      consumedGlucose8 = Double.random(in: 25...35)
      consumedGlucose9 = Double.random(in: 35...45)
      consumedGlucose10 = Double.random(in: 15...25)
      consumedGlucose11 = Double.random(in: 25...35)
      consumedGlucose12 = Double.random(in: 35...45)
      consumedGlucose13 = Double.random(in: 8...18)
  }
  
  private func resetAllValues() {
      consumedGlucose1 = 25.0
      consumedGlucose2 = 35.0
      consumedGlucose3 = 45.0
      consumedGlucose4 = 15.0
      consumedGlucose5 = 25.0
      consumedGlucose6 = 35.0
      consumedGlucose7 = 20.0
      consumedGlucose8 = 30.0
      consumedGlucose9 = 40.0
      consumedGlucose10 = 18.5
      consumedGlucose11 = 28.3
      consumedGlucose12 = 38.7
      consumedGlucose13 = 12.0
  }
}

private struct GlucoseValueItem: View {
  private let title: String
  private let consumedGlucose: Double
  private let baseGlucose: Double
  private let type: AMDGlucoseValueLabel.LabelType
  private let variant: AMDStatusVariant
  
  init(
    title: String,
    consumedGlucose: Double,
    baseGlucose: Double,
    type: AMDGlucoseValueLabel.LabelType,
    variant: AMDStatusVariant
  ) {
    self.title = title
    self.consumedGlucose = consumedGlucose
    self.baseGlucose = baseGlucose
    self.type = type
    self.variant = variant
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(title)
        .amdFont(.smallRegular)
        .foregroundColor(.gray40)
      
      AMDGlucoseValueLabel(
        consumedGlucose: consumedGlucose,
        baseGlucose: baseGlucose,
        type: type,
        variant: variant
      )
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(16)
    .background(Color.gray5)
    .cornerRadius(8)
  }
}
