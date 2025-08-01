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
  
  public init(
    variant: AMDStatusVariant,
    style: Style
  ) {
    self.variant = variant
    self.style = style
  }
  
  public var body: some View {
    switch style {
    case .main(let sugar, let baseSugar,):
      mainStyleBody(sugar: sugar, baseSugar: baseSugar)
      
    case .history(let drinkCount, let sugar, let baseSugar):
      historyStyleBody(drinkCount: drinkCount,sugar: sugar, baseSugar: baseSugar)
    }
  }
  
  private func mainStyleBody( sugar: Int, baseSugar: Int) -> some View {
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
  
  private func contentMainView(sugar: Int, baseSugar: Int) -> some View {
    HStack {
      HStack(spacing: 4) {
        Text("\(baseSugar - sugar)g")
          .amdFont(.largeBold)
          .foregroundStyle(.gray85)
        
        Text("더 마실 수 있당!")
          .amdFont(.largeRegular)
          .foregroundStyle(.gray70)
      }
      
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
    VStack(spacing:0) {
      VStack(alignment: .center, spacing: 4) {
        HStack(spacing: 10) {
          characterImage
          contentHistoryView(drinkCount: drinkCount, sugar: sugar, baseSugar: baseSugar)
      
        }
        progressBar(sugar: sugar, baseSugar: baseSugar, isStatusLavbledHidden: false)
      }
      .frame(minHeight: 87, maxHeight: 87)
      
    }
    .padding(.vertical, 10)
    .background(Color.white)
  }
  
  private struct characterSpeechTail: Shape {
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
  private func contentHistoryView(drinkCount: Int, sugar: Int, baseSugar: Int) -> some View {
    HStack(spacing: 4.5){
      // 🎯 말풍선 + 삼각형 꼬리
       ZStack(alignment: .bottomLeading) {
         // 말풍선 본체
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
         .background(Color.gray10)
         .cornerRadius(16)
         
         characterSpeechTail()
               .fill(Color.gray10)
               .frame(width: 20, height: 10)
               .offset(x: -5, y: -2) // 말풍선 밖으로 나오도록 조정
       }
      Spacer()
      
      VStack {
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
