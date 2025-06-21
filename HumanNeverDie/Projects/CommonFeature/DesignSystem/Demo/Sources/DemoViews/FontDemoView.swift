//
//  FontDemoView.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 6/18/25.
//

import SwiftUI

import DesignSystem

struct FontDemoView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {
        xxlargeSection
        xlargeSection
        largeSection
        mediumSection
        smallSection
        xsmallSection
        xxsmallSection
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 32)
    }
  }
  
  private var xxlargeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("XXLarge (24pt)")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.xxlargeBold)",
        font: .xxlargeBold
      )
    }
  }
  
  private var xlargeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("XLarge (20pt)")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.xlargeBold)",
        font: .xlargeBold
      )
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.xlargeRegular)",
        font: .xlargeRegular
      )
    }
  }
  
  private var largeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Large (17pt)")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.largeBold)",
        font: .largeBold
      )
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.largeRegular)",
        font: .largeRegular
      )
    }
  }
  
  private var mediumSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Medium (16pt)")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.mediumBold)",
        font: .mediumBold
      )
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.mediumMedium)",
        font: .mediumMedium
      )
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.mediumRegular)",
        font: .mediumRegular
      )
    }
  }
  
  private var smallSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Small (14pt)")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.smallBold)",
        font: .smallBold
      )
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.smallRegular)",
        font: .smallRegular
      )
    }
  }
  
  private var xsmallSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("XSmall (12pt)")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.xsmallBold)",
        font: .xsmallBold
      )
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.xsmallRegular)",
        font: .xsmallRegular
      )
    }
  }
  
  private var xxsmallSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("XXSmall (11pt)")
        .amdFont(.mediumBold)
        .foregroundColor(Color.gray60)
      
      FontItem(
        text: "폰트 시스템을 통해 일관된 타이포그래피를 제공합니다.\n.amdFont(.xxsmallRegular)",
        font: .xxsmallRegular
      )
    }
  }
}

private struct FontItem: View {
  private let text: String
  private let font: AMDFont
  
  init(
    text: String,
    font: AMDFont
  ) {
    self.text = text
    self.font = font
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(text)
        .amdFont(font)
        .fixedSize(horizontal: false, vertical: true)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(16)
    .background(Color.gray5)
    .cornerRadius(8)
  }
}

