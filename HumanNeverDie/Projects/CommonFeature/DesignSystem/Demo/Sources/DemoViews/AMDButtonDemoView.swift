//
//  AMDButtonDemoView.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 7/1/25.
//

import SwiftUI

import DesignSystem

struct AMDButtonDemoView: View {
  @State private var isEnabled = true
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        // 제목
        Text("AMDButton 데모")
          .amdFont(.largeBold)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        // 활성화/비활성화 토글
        Toggle("버튼 활성화", isOn: $isEnabled)
          .amdFont(.mediumRegular)
        
        // Default 타입 버튼들
        VStack(alignment: .leading, spacing: 16) {
          Text("Default 타입")
            .amdFont(.mediumBold)
            .foregroundStyle(.amdPrimary)
          
          AMDButton(
            type: .default,
            title: "기본 버튼"
          ) {
            print("기본 버튼 탭됨")
          }
          .disabled(!isEnabled)
        }
        
        // Secondary 타입 버튼들
        VStack(alignment: .leading, spacing: 16) {
          Text("Secondary 타입")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray80)
          
          AMDButton(
            type: .secondary,
            title: "보조 버튼"
          ) {
            print("보조 버튼 탭됨")
          }
          .disabled(!isEnabled)
        }
        
        // Delete 타입 버튼들
        VStack(alignment: .leading, spacing: 16) {
          Text("Delete 타입")
            .amdFont(.mediumBold)
            .foregroundStyle(.danger)
          
          AMDButton(
            type: .delete,
            title: "삭제 버튼"
          ) {
            print("삭제 버튼 탭됨")
          }
          .disabled(!isEnabled)
        }
        
        // 모든 타입을 한번에 보기
        VStack(alignment: .leading, spacing: 16) {
          Text("모든 타입 비교")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray80)
          
          VStack(spacing: 12) {
            AMDButton(
              type: .default,
              title: "Default 버튼"
            ) {
              print("Default 버튼 탭됨")
            }
            .disabled(!isEnabled)
            
            AMDButton(
              type: .secondary,
              title: "Secondary 버튼"
            ) {
              print("Secondary 버튼 탭됨")
            }
            .disabled(!isEnabled)
            
            AMDButton(
              type: .delete,
              title: "Delete 버튼"
            ) {
              print("Delete 버튼 탭됨")
            }
            .disabled(!isEnabled)
          }
        }
        
        // 상태 설명
        VStack(alignment: .leading, spacing: 12) {
          Text("상태 설명")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray80)
          
          VStack(alignment: .leading, spacing: 8) {
            HStack {
              Circle()
                .fill(.amdPrimary)
                .frame(width: 8, height: 8)
              Text("Default: 기본 상태")
                .amdFont(.smallRegular)
            }
            
            HStack {
              Circle()
                .fill(.primaryDarker)
                .frame(width: 8, height: 8)
              Text("Pressed: 버튼을 누를 때 (0.95배 축소)")
                .amdFont(.smallRegular)
            }
            
            HStack {
              Circle()
                .fill(.gray50)
                .frame(width: 8, height: 8)
              Text("Disabled: 비활성화 상태")
                .amdFont(.smallRegular)
            }
          }
        }
        .padding()
        .background(.gray15)
        .amdCornerRadius(.medium)
      }
      .padding()
    }
    .background(.white)
  }
}

#Preview {
  AMDButtonDemoView()
}
