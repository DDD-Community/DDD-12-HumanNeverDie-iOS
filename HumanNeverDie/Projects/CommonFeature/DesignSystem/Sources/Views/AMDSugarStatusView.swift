//
//  AMDSugarStatusView.swift
//  DesignSystem
//
//  Created by 김규철 on 7/2/25.
//

import SwiftUI

public struct AMDSugarStatusView: View {
  public enum Style {
    case main(sugar: Int, baseSugar: Int)
    case history(drinkCount: Int, sugar: Int, baseSugar: Int)
    case record(sugar: Int, baseSugar: Int)
  }
  
  private let variant: AMDStatusVariant
  private let style: Style
  
  private var characterImage: Image {
    switch variant {
    case .healthy:
      return AMDImage.healthyCharacter.swiftUIImage
    case .warning:
      return AMDImage.warningCharacter.swiftUIImage
    case .danger:
      return AMDImage.dangerCharacter.swiftUIImage
    }
  }
  
  private var color: Color {
    switch variant {
    case .healthy:
      return .primaryBackground
    case .warning:
      return .yellowBackground
    case .danger:
      return .redBackground
    }
  }
  
  public init(
    variant: AMDStatusVariant,
    style: Style
  ) {
    self.variant = variant
    self.style = style
  }
  
  public var body: some View {
    switch style {
    case .main(let sugar, let baseSugar):
      mainStyleBody(sugar: sugar, baseSugar: baseSugar)
      
    case .history(let drinkCount, let sugar, let baseSugar):
      historyStyleBody(drinkCount: drinkCount, sugar: sugar, baseSugar: baseSugar)
      
    case .record(sugar: let sugar, baseSugar: let baseSugar):
      recordStyleBody(sugar: sugar, baseSugar: baseSugar)
    }
  }
  
  private func mainStyleBody(sugar: Int, baseSugar: Int) -> some View {
    HStack(alignment: .center, spacing: 18) {
      characterImage
      
      VStack(spacing: 10) {
        contentMainView(sugar: sugar, baseSugar: baseSugar)
        progressBar(sugar: sugar, baseSugar: baseSugar, isStatusLavbledHidden: true)
      }
    }
    .padding(.horizontal, 20)
    .amdDivider(isTop: true, isBottom: true)
    .frame(minHeight: 84, maxHeight: 84)
    .background(.white)
    .amdShadow(.tabbar)
  }
  
  @ViewBuilder
  private func contentMainView(sugar: Int, baseSugar: Int) -> some View {
    HStack {
      sugarStatusText(sugar: sugar, baseSugar: baseSugar, fontStyle: (.largeBold, .largeRegular))
      
      Spacer()
      
      AMDGlucoseValueLabel(
        consumedGlucose: Double(sugar),
        baseGlucose: Double(baseSugar),
        type: .progress,
        variant: variant
      )
    }
  }
  
  private func historyStyleBody(drinkCount: Int, sugar: Int, baseSugar: Int) -> some View {
    verticalStyleBody(sugar: sugar, baseSugar: baseSugar) {
      contentHistoryView(drinkCount: drinkCount, sugar: sugar, baseSugar: baseSugar)
    }
  }
  
  private func recordStyleBody(sugar: Int, baseSugar: Int) -> some View {
    verticalStyleBody(sugar: sugar, baseSugar: baseSugar) {
      contentRecordView(sugar: sugar, baseSugar: baseSugar)
    }
  }
  
  private func verticalStyleBody<Content: View>(sugar: Int, baseSugar: Int, @ViewBuilder content: () -> Content) -> some View {
    VStack(spacing: 0) {
      VStack(alignment: .center, spacing: 4) {
        HStack(spacing: 10) {
          characterImage
          content()
        }
        progressBar(sugar: sugar, baseSugar: baseSugar, isStatusLavbledHidden: false)
      }
      .frame(minHeight: 87, maxHeight: 87)
    }
    .padding(.vertical, 10)
    .background(Color.white)
  }
  
  // MARK: - Helper Views
  
  @ViewBuilder
  private func speechBubbleContentView<Content: View>(
    sugar: Int, 
    baseSugar: Int, 
    @ViewBuilder content: () -> Content
  ) -> some View {
    HStack(spacing: 4.5) {
      speechBubbleView {
        content()
      }
      
      Spacer()
      
      totalSugarIntakeView(sugar: sugar, baseSugar: baseSugar)
    }
  }
  
  @ViewBuilder
  private func speechBubbleView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    ZStack(alignment: .bottomLeading) {
      content()
        .background(Color.gray10)
        .cornerRadius(16)
      
      CharacterSpeechTail()
        .fill(color)
        .frame(width: 20, height: 10)
        .offset(x: -5, y: -2)
    }
  }
  
  private func totalSugarIntakeView(sugar: Int, baseSugar: Int) -> some View {
    VStack(spacing: 2) {
      Text("총 당 섭취량")
        .amdFont(.xsmallRegular)
        .foregroundStyle(.gray50)
      
      AMDGlucoseValueLabel(
        consumedGlucose: Double(sugar),
        baseGlucose: Double(baseSugar),
        type: .progress,
        variant: variant
      )
    }
  }
  
  @ViewBuilder
  private func sugarStatusText(
    sugar: Int, 
    baseSugar: Int, 
    fontStyle: (AMDFont, AMDFont)
  ) -> some View {
    let isExceeded = sugar > baseSugar
    
    HStack(spacing: 4) {
      if !isExceeded {
        Text("\(baseSugar - sugar)g")
          .amdFont(fontStyle.0)
          .foregroundStyle(.gray85)
      }
      
      Text(isExceeded ? "윽,, 더 이상 마실 수 없당!" : "더 마실 수 있당!")
        .amdFont(fontStyle.1)
        .foregroundStyle(.gray70)
    }
  }
    
  private func contentHistoryView(drinkCount: Int, sugar: Int, baseSugar: Int) -> some View {
    speechBubbleContentView(sugar: sugar, baseSugar: baseSugar) {
      HStack(spacing: 2) {
        Text("총 ")
          .amdFont(.largeRegular)
          .foregroundStyle(.gray70)
        
        Text("\(drinkCount)잔")
          .amdFont(.largeBold)
          .foregroundStyle(.gray85)
        
        Text("이당!")
          .amdFont(.largeRegular)
          .foregroundStyle(.gray70)
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 12)
    }
  }
    
  @ViewBuilder
  private func contentRecordView(sugar: Int, baseSugar: Int) -> some View {
    speechBubbleContentView(sugar: sugar, baseSugar: baseSugar) {
      sugarStatusText(sugar: sugar, baseSugar: baseSugar, fontStyle: (.mediumBold, .mediumMedium))
        .minimumScaleFactor(0.8)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
  }
  
  private func progressBar(sugar: Int, baseSugar: Int, isStatusLavbledHidden: Bool) -> some View {
    AMDProgress(
      glucose: Double(sugar) / Double(baseSugar),
      isStatusLabelHidden: isStatusLavbledHidden,
      type: .small,
      variant: variant
    )
  }
}

private struct CharacterSpeechTail: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let offset: CGFloat = rect.width * 0.4
    path.move(to: CGPoint(x: rect.minX + offset, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.closeSubpath()
    
    return path
  }
}
