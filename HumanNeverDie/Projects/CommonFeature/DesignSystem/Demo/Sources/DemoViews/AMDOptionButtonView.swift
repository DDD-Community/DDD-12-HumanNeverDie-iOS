//
//  AMDOptionButtonView.swift
//  DesignSystem
//
//  Created by Seulki Lee on 7/13/25.
//

import SwiftUI
import DesignSystem

struct AMDOptionButtonView: View {
  @State private var isFirstSelected = true
  @State private var isSecondSelected = false
  @State private var isThirdSelected = true
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {

        VStack(alignment: .leading, spacing: 8) {
          Text("기본 선택된 옵션 버튼")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDOptionButton(
            title: "높은편",
            isSelected: isFirstSelected,
            action: {}
          )
        }
        
        VStack(alignment: .leading, spacing: 8) {
          Text("서브타이틀과 트레일링 텍스트가 있는 옵션 버튼")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDOptionButton(
            title: "쉬움",
            subtitle: "권장량의 100%이내 섭취",
            trailingText: "하루 200g",
            isSelected: isSecondSelected,
            action: {}
          )
        }
        
        VStack(alignment: .leading, spacing: 8) {
          Text("배지가 있는 복합 옵션 버튼")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDOptionButton(
            title: "Tall",
            subtitle: "저당",
            subtitleBadgeType: .yellow,
            sugarAndCaloriesText: AMDSugarAndCalories(suger: 4, caloriesText: 140),
            isSelected: isThirdSelected,
            action: {}
          )
        }
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
    }
    .navigationTitle("AMDOptionButton Demo")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  AMDOptionButtonView()
}
