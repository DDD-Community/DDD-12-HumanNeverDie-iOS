//
//  AMDFloatingButtonDemoView.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 7/1/25.
//

import SwiftUI

import DesignSystem

struct AMDFloatingButtonDemoView: View {
  @State private var isEnabled = true
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        // 제목
        Text("AMDFloatingButton 데모")
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
          
          AMDFloatingButton(
            type: .default,
            title: "기본 플로팅 버튼"
          ) {
            print("기본 플로팅 버튼 탭됨")
          }
          .disabled(!isEnabled)
          
          AMDFloatingButton(
            type: .default,
            title: "왼쪽 아이콘 버튼",
            leftIcon: Image(systemName: "plus")
          ) {
            print("왼쪽 아이콘 버튼 탭됨")
          }
          .disabled(!isEnabled)
          
          AMDFloatingButton(
            type: .default,
            title: "오른쪽 아이콘 버튼",
            rightIcon: Image(systemName: "arrow.right")
          ) {
            print("오른쪽 아이콘 버튼 탭됨")
          }
          .disabled(!isEnabled)
          
          AMDFloatingButton(
            type: .default,
            title: "양쪽 아이콘 버튼",
            leftIcon: Image(systemName: "heart"),
            rightIcon: Image(systemName: "arrow.right")
          ) {
            print("양쪽 아이콘 버튼 탭됨")
          }
          .disabled(!isEnabled)
        }
        
        // Secondary 타입 버튼들
        VStack(alignment: .leading, spacing: 16) {
          Text("Secondary 타입")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray80)
          
          AMDFloatingButton(
            type: .secondary,
            title: "보조 플로팅 버튼"
          ) {
            print("보조 플로팅 버튼 탭됨")
          }
          .disabled(!isEnabled)
          
          AMDFloatingButton(
            type: .secondary,
            title: "왼쪽 아이콘 버튼",
            leftIcon: Image(systemName: "minus")
          ) {
            print("보조 왼쪽 아이콘 버튼 탭됨")
          }
          .disabled(!isEnabled)
          
          AMDFloatingButton(
            type: .secondary,
            title: "오른쪽 아이콘 버튼",
            rightIcon: Image(systemName: "chevron.right")
          ) {
            print("보조 오른쪽 아이콘 버튼 탭됨")
          }
          .disabled(!isEnabled)
          
          AMDFloatingButton(
            type: .secondary,
            title: "양쪽 아이콘 버튼",
            leftIcon: Image(systemName: "star"),
            rightIcon: Image(systemName: "chevron.right")
          ) {
            print("보조 양쪽 아이콘 버튼 탭됨")
          }
          .disabled(!isEnabled)
        }
        
        // 모든 타입을 한번에 보기
        VStack(alignment: .leading, spacing: 16) {
          Text("모든 타입 비교")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray80)
          
          VStack(spacing: 12) {
            AMDFloatingButton(
              type: .default,
              title: "Default 플로팅 버튼"
            ) {
              print("Default 플로팅 버튼 탭됨")
            }
            .disabled(!isEnabled)
            
            AMDFloatingButton(
              type: .secondary,
              title: "Secondary 플로팅 버튼"
            ) {
              print("Secondary 플로팅 버튼 탭됨")
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
              Text("Default: 기본 상태 (그림자 포함)")
                .amdFont(.smallRegular)
            }
            
            HStack {
              Circle()
                .fill(.primaryDarker)
                .frame(width: 8, height: 8)
              Text("Pressed: 버튼을 누를 때 (0.97배 축소)")
                .amdFont(.smallRegular)
            }
            
            HStack {
              Circle()
                .fill(.gray50)
                .frame(width: 8, height: 8)
              Text("Disabled: 비활성화 상태")
                .amdFont(.smallRegular)
            }
            
            HStack {
              Circle()
                .fill(.gray25)
                .frame(width: 8, height: 8)
              Text("Secondary: 테두리가 있는 흰색 배경")
                .amdFont(.smallRegular)
            }
          }
        }
        .padding()
        .background(.gray15)
        .amdCornerRadius(.medium)
        
        // 특징 설명
        VStack(alignment: .leading, spacing: 12) {
          Text("특징")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray80)
          
          VStack(alignment: .leading, spacing: 8) {
            HStack {
              Circle()
                .fill(.amdPrimary)
                .frame(width: 8, height: 8)
              Text("높이: 52pt 고정")
                .amdFont(.smallRegular)
            }
            
            HStack {
              Circle()
                .fill(.amdPrimary)
                .frame(width: 8, height: 8)
              Text("아이콘 크기: 24x24pt")
                .amdFont(.smallRegular)
            }
            
            HStack {
              Circle()
                .fill(.amdPrimary)
                .frame(width: 8, height: 8)
              Text("좌우 패딩: 20pt")
                .amdFont(.smallRegular)
            }
            
            HStack {
              Circle()
                .fill(.amdPrimary)
                .frame(width: 8, height: 8)
              Text("아이콘 간격: 4pt")
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
  AMDFloatingButtonDemoView()
}
