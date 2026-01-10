//
//  AMDSliderDemoView.swift
//  DesignSystem
//
//  Created by Claude on 1/10/26.
//

import SwiftUI

import DesignSystem

struct AMDSliderDemoView: View {
  @State private var defaultValue: Double = 50
  @State private var labelValue: Double = 75
  @State private var customRangeValue: Double = 100
  @State private var customStyleValue: Double = 30

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {
        defaultSliderSection
        labelSliderSection
        customRangeSection
        customStyleSection
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 32)
    }
  }

  private var defaultSliderSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Default Slider")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)

      SliderItem(
        title: "Basic (0-100)",
        value: $defaultValue,
        showsLabel: false
      )
    }
  }

  private var labelSliderSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("With Percentage Label")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)

      SliderItem(
        title: "Label Enabled",
        value: $labelValue,
        showsLabel: true
      )
    }
  }

  private var customRangeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Custom Range")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)

      VStack(alignment: .leading, spacing: 12) {
        Text("Range: 50-150")
          .amdFont(.smallRegular)
          .foregroundColor(.gray40)

        AMDSlider(value: $customRangeValue, in: 50...150)
          .showsPercentageLabel(true)

        Text("Value: \(Int(customRangeValue))")
          .amdFont(.xsmallRegular)
          .foregroundColor(.gray60)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(16)
      .background(Color.gray5)
      .cornerRadius(8)
    }
  }

  private var customStyleSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Custom Style")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)

      VStack(alignment: .leading, spacing: 12) {
        Text("Custom Thumb & Track")
          .amdFont(.smallRegular)
          .foregroundColor(.gray40)

        AMDSlider(value: $customStyleValue, in: 0...100)
          .showsPercentageLabel(true)
          .thumbSize(32)
          .trackHeight(8)

        Text("Value: \(Int(customStyleValue))%")
          .amdFont(.xsmallRegular)
          .foregroundColor(.gray60)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(16)
      .background(Color.gray5)
      .cornerRadius(8)
    }
  }
}

private struct SliderItem: View {
  let title: String
  @Binding var value: Double
  let showsLabel: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(title)
        .amdFont(.smallRegular)
        .foregroundColor(.gray40)

      AMDSlider(value: $value, in: 0...100)
        .showsPercentageLabel(showsLabel)

      Text("Value: \(Int(value))%")
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
  AMDSliderDemoView()
}
