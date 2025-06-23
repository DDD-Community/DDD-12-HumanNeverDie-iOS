//
//  AMDCardDemoView.swift
//  DesignSystem
//
//  Created by 김규철 on 6/23/25.
//

import SwiftUI

import DesignSystem

struct AMDCardDemoView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {
        healthySection
        warningSection
        dangerSection
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 32)
    }
  }
  
  private var healthySection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Healthy Status")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      CardItem(
        title: "Healthy Status",
        consumedGlucose: 25.0,
        baseGlucose: 25.0,
        variant: .healthy
      )
      .padding(.horizontal, 24)
    }
  }
  
  private var warningSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Warning Values")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      CardItem(
        title: "High Glucose",
        consumedGlucose: 35.0,
        baseGlucose: 25.0,
        variant: .warning
      )
      .padding(.horizontal, 24)
    }
  }
  
  
  private var dangerSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Danger Examples")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      
      CardItem(
        title: "Danger",
        consumedGlucose: 40.0,
        baseGlucose: 40.0,
        variant: .danger
      )
      .padding(.horizontal, 24)
    }
  }
}

private struct CardItem: View {
  private let title: String
  private let consumedGlucose: Double
  private let baseGlucose: Double
  private let variant: AMDStatusVariant
  
  init(
    title: String,
    consumedGlucose: Double,
    baseGlucose: Double,
    variant: AMDStatusVariant
  ) {
    self.title = title
    self.consumedGlucose = consumedGlucose
    self.baseGlucose = baseGlucose
    self.variant = variant
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(title)
        .amdFont(.smallRegular)
        .foregroundColor(.gray40)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      AMDCard(
        consumedGlucose: consumedGlucose,
        baseGlucose: baseGlucose,
        variant: variant
      )
      .amdFlipCard(backView: cardBackView)
    }
    .frame(width: 295)
  }
  
  private var cardBackView: some View {
    VStack(spacing: 16) {
      Text("카드 정보")
        .amdFont(.largeBold)
        .foregroundStyle(.gray95)
      
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          Text("상태:")
            .amdFont(.mediumRegular)
            .foregroundStyle(.gray60)
          Text(statusText)
            .amdFont(.mediumBold)
            .foregroundStyle(statusColor)
        }
        
        HStack {
          Text("소비 포도당:")
            .amdFont(.mediumRegular)
            .foregroundStyle(.gray60)
          Text("\(Int(consumedGlucose))g")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray95)
        }
        
        HStack {
          Text("기준 포도당:")
            .amdFont(.mediumRegular)
            .foregroundStyle(.gray60)
          Text("\(Int(baseGlucose))g")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray95)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      Spacer()
      
      Text("스와이프하여 뒤집기")
        .amdFont(.smallRegular)
        .foregroundStyle(.gray40)
    }
    .padding(30)
    .frame(width: 295, height: 384)
    .background(cardBackGradient)
    .amdCornerRadius(.large)
  }
  
  private var statusText: String {
    switch variant {
    case .healthy:
      return "건강"
    case .warning:
      return "걱정"
    case .danger:
      return "위험"
    }
  }
  
  private var statusColor: Color {
    switch variant {
    case .healthy:
      return .primaryDarker
    case .warning:
      return .yellowDarker
    case .danger:
      return .redDarker
    }
  }
  
  private var cardBackGradient: LinearGradient {
    switch variant {
    case .healthy:
      return .cardHealthy
    case .warning:
      return .cardWarning
    case .danger:
      return .cardDanger
    }
  }
}


