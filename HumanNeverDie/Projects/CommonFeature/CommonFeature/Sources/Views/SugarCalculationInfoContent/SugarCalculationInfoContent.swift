//
//  sugarCalculationInfoContent.swift
//  CommonFeature
//
//  Created by Seulki Lee on 8/23/25.
//

import SwiftUI
import DesignSystem

public struct SugarCalculationInfoContent: View {
  let onDismiss: () -> Void
  
  public init(onDismiss: @escaping () -> Void) {
    self.onDismiss = onDismiss
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Text("아맞당은 당 섭취량을 이렇게 계산해요")
            .amdFont(.largeBold)
            .foregroundColor(.gray85)
          
          // 1번 섹션
          HStack(alignment: .top, spacing: 8) {
            Text("1.")
              .amdFont(.mediumRegular)
              .foregroundColor(.gray80)
              .frame(width: 20, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 12) {
              Text("성별, 나이, 키 정보로 기초 대사량을 먼저 계산한 후 활동량을 고려 활동 대사량을 계산해요.")
                .amdFont(.mediumRegular)
                .foregroundColor(.gray80)
              
              VStack(alignment: .leading, spacing: 8) {
                HStack {
                  Text("기초대사량 계산법")
                    .amdFont(.smallRegular)
                    .foregroundColor(.gray70)
                  Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("• 18-30세")
                    .amdFont(.smallRegular)
                    .foregroundColor(.gray70)
                  
                  VStack(alignment: .leading, spacing: 4) {
                    Text("  • 남성: 15.3 × 체중 + 679")
                      .amdFont(.smallRegular)
                      .foregroundColor(.gray70)
                    Text("  • 여성: 14.7 × 체중 + 496")
                      .amdFont(.smallRegular)
                      .foregroundColor(.gray70)
                  }
                  
                  Text("• 30-60세")
                    .amdFont(.smallRegular)
                    .foregroundColor(.gray70)
                  
                  VStack(alignment: .leading, spacing: 4) {
                    Text("  • 남성: 11.6 × 체중 + 879")
                      .amdFont(.smallRegular)
                      .foregroundColor(.gray70)
                    Text("  • 여성: 8.7 × 체중 + 829")
                      .amdFont(.smallRegular)
                      .foregroundColor(.gray70)
                  }
                  
                  Text("• 60세 이상")
                    .amdFont(.smallRegular)
                    .foregroundColor(.gray70)
                  
                  VStack(alignment: .leading, spacing: 4) {
                    Text("  • 남성: 13.5 × 체중 + 487")
                      .amdFont(.smallRegular)
                      .foregroundColor(.gray70)
                    Text("  • 여성: 10.5 × 체중 + 596")
                      .amdFont(.smallRegular)
                      .foregroundColor(.gray70)
                  }
                }
                .padding(.leading, 8)
              }
            }
          }
          
          HStack(alignment: .top, spacing: 8) {
            Text("2.")
              .amdFont(.mediumRegular)
              .foregroundColor(.gray80)
              .frame(width: 20, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
              Text("활동량에 따라 신체 활동 수준 값을 적용해서 총 에너지 요구량을 계산해요.")
                .amdFont(.mediumRegular)
                .foregroundColor(.gray80)
              
              VStack(alignment: .leading, spacing: 8) {
                HStack {
                  Text("신체 활동 수준 값")
                    .amdFont(.smallRegular)
                    .foregroundColor(.gray70)
                  Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("• 가벼운 활동: 1.4-1.5")
                    .amdFont(.smallRegular)
                    .foregroundColor(.gray70)
                  Text("• 보통 활동: 1.6-1.7")
                    .amdFont(.smallRegular)
                    .foregroundColor(.gray70)
                  Text("• 활발한 활동: 1.8-1.9")
                    .amdFont(.smallRegular)
                    .foregroundColor(.gray70)
                }
                .padding(.leading, 8)
              }
            }
          }
          
          HStack(alignment: .top, spacing: 8) {
            Text("3.")
              .amdFont(.mediumRegular)
              .foregroundColor(.gray80)
              .frame(width: 20, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 12) {
              Text("계산된 총 에너지 요구량을 바탕으로 WHO 세계 표준 권장 당류 계산식을 적용해 일일 권장 당 섭취량을 도출해요.")
                .amdFont(.mediumRegular)
                .foregroundColor(.gray80)
              
              VStack(alignment: .leading, spacing: 8) {
                HStack {
                  Text("당류 목표량 계산")
                    .amdFont(.smallRegular)
                    .foregroundColor(.gray70)
                  Spacer()
                }
                
                VStack(alignment: .leading, spacing: 12) {
                  VStack(alignment: .leading, spacing: 8) {
                    Text("1단계 - 당류 칼로리(kcal) 계산")
                      .amdFont(.smallRegular)
                      .foregroundColor(.gray70)
                    
                    VStack(alignment: .leading, spacing: 4) {
                      Text("• 일일 권장량: 총 에너지 요구량 × 10%")
                        .amdFont(.smallRegular)
                        .foregroundColor(.gray70)
                      Text("• 이상적 목표량: 총 에너지 요구량 × 5% (WHO 강력 권장)")
                        .amdFont(.smallRegular)
                        .foregroundColor(.gray70)
                    }
                    .padding(.leading, 8)
                  }
                  
                  VStack(alignment: .leading, spacing: 8) {
                    Text("2단계 - 그램(gram) 변환")
                      .amdFont(.smallRegular)
                      .foregroundColor(.gray70)
                    
                    VStack(alignment: .leading, spacing: 4) {
                      Text("• 당류 1g = 4kcal")
                        .amdFont(.smallRegular)
                        .foregroundColor(.gray70)
                      Text("• 당류량(g) = 당류 칼로리 ÷ 4")
                        .amdFont(.smallRegular)
                        .foregroundColor(.gray70)
                    }
                  }
                }
              }
            }
          }
            
            // 주의사항
          VStack(alignment: .leading, spacing: 4) {
            Text("*정확한 권장 당류 섭취량은 개인 체질에 따라 다를 수 있으니 참고해주세요.")
              .amdFont(.xsmallRegular)
              .foregroundColor(.gray60)
              .lineLimit(nil)
            
            Text("*BMI에 따라 신체 활동 수준 값이 달라질 수 있어요.")
              .amdFont(.xsmallRegular)
              .foregroundColor(.gray60)
              .lineLimit(nil)
            
            Text("*신체 질환이나 질병이 있다면 의료진과 상담해주세요.")
              .amdFont(.xsmallRegular)
              .foregroundColor(.gray60)
              .lineLimit(nil)
          }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
      }
      
      AMDButton(
        type: .secondary,
        title: "닫기",
        action: onDismiss
      )
      .padding(.all, 20)
    }
  }
}

