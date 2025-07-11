//
//  ColorDemoView.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 6/18/25.
//

import SwiftUI
import DesignSystem

struct ColorDemoView: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 32) {
        graySection
        primarySection
        redSection
        yellowSection
        systemSection
        gradientSection
      }
      .padding()
    }
  }
  
  private var graySection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Gray Colors")
        .font(.headline)
      
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        ColorItem(name: "gray0", color: Color.gray0)
        ColorItem(name: "gray5", color: Color.gray5)
        ColorItem(name: "gray10", color: Color.gray10)
        ColorItem(name: "gray15", color: Color.gray15)
        ColorItem(name: "gray25", color: Color.gray25)
        ColorItem(name: "gray40", color: Color.gray40)
        ColorItem(name: "gray50", color: Color.gray50)
        ColorItem(name: "gray60", color: Color.gray60)
        ColorItem(name: "gray70", color: Color.gray70)
        ColorItem(name: "gray80", color: Color.gray80)
        ColorItem(name: "gray85", color: Color.gray85)
        ColorItem(name: "gray95", color: Color.gray95)
        ColorItem(name: "gray100", color: Color.gray100)
      }
    }
  }
  
  private var primarySection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Primary Colors")
        .font(.headline)
      
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        ColorItem(name: "primary", color: Color.amdPrimary)
        ColorItem(name: "primaryBackground", color: Color.primaryBackground)
        ColorItem(name: "primaryDarker", color: Color.primaryDarker)
        ColorItem(name: "primaryLighter", color: Color.primaryLighter)
      }
    }
  }
  
  private var redSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Red Colors")
        .font(.headline)
      
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        ColorItem(name: "red", color: Color.amdRed)
        ColorItem(name: "redBackground", color: Color.redBackground)
        ColorItem(name: "redDarker", color: Color.redDarker)
        ColorItem(name: "redLighter", color: Color.redLighter)
      }
    }
  }
  
  private var yellowSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Yellow Colors")
        .font(.headline)
      
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        ColorItem(name: "yellow", color: Color.amdYellow)
        ColorItem(name: "yellowBackground", color: Color.yellowBackground)
        ColorItem(name: "yellowDarker", color: Color.yellowDarker)
        ColorItem(name: "yellowLighter", color: Color.yellowLighter)
      }
    }
  }
  
  private var systemSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("System Colors")
        .font(.headline)
      
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        ColorItem(name: "success", color: Color.success)
        ColorItem(name: "danger", color: Color.danger)
        ColorItem(name: "dangerBackground", color: Color.dangerBackground)
        ColorItem(name: "information", color: Color.information)
      }
    }
  }
  
  private var gradientSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Gradients")
        .font(.headline)
      
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        GradientItem(name: "phase2", gradient: AMDGradient.phase2)
        GradientItem(name: "phase3", gradient: AMDGradient.phase3)
      }
    }
  }
}

private struct ColorItem: View {
  private let name: String
  private let color: Color
  
  init(name: String, color: Color) {
    self.name = name
    self.color = color
  }
  
  var body: some View {
    VStack(spacing: 8) {
      RoundedRectangle(cornerRadius: 8)
        .fill(color)
        .frame(height: 60)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray5, lineWidth: 0.5)
        )
      
      Text(name)
        .font(.caption)
    }
  }
}

private struct GradientItem: View {
  private let name: String
  private let gradient: LinearGradient
  
  init(name: String, gradient: LinearGradient) {
    self.name = name
    self.gradient = gradient
  }
  
  var body: some View {
    VStack(spacing: 8) {
      RoundedRectangle(cornerRadius: 8)
        .fill(gradient)
        .frame(height: 60)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray5, lineWidth: 0.5)
        )
      
      Text(name)
        .font(.caption)
    }
  }
}
