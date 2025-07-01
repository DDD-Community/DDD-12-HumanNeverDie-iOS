//
//  AMDTextFieldDemoView.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 6/30/25.
//

import SwiftUI
import DesignSystem

struct AMDTextFieldDemoView: View {
  @State private var basicText = ""
  @State private var titleText = ""
  @State private var placeholderText = ""
  @State private var searchText = ""
  @State private var dateText = ""
  @State private var editText = ""
  @State private var maxCountText = ""
  @State private var errorText = ""
  @State private var helperText = ""
  @State private var clearButtonText = ""
  @State private var actionText = ""
  @State private var showAlert = false
  @State private var alertMessage = ""
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        // 기본 TextField
        VStack(alignment: .leading, spacing: 8) {
          Text("기본 TextField")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(text: $basicText)
        }
        
        // 제목이 있는 TextField
        VStack(alignment: .leading, spacing: 8) {
          Text("제목이 있는 TextField")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $titleText,
            title: "이름"
          )
        }
        
        // 플레이스홀더가 있는 TextField
        VStack(alignment: .leading, spacing: 8) {
          Text("플레이스홀더가 있는 TextField")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $placeholderText,
            placeholder: "이름을 입력해주세요"
          )
        }
        
        // 검색 버튼이 있는 TextField (액션 포함)
        VStack(alignment: .leading, spacing: 8) {
          Text("검색 버튼이 있는 TextField (액션 포함)")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $searchText,
            placeholder: "검색어를 입력하세요",
            rightButtonType: .search,
            rightButtonAction: {
              alertMessage = "검색 버튼이 눌렸습니다: \(searchText)"
              showAlert = true
            }
          )
        }
        
        // 날짜 버튼이 있는 TextField (액션 포함)
        VStack(alignment: .leading, spacing: 8) {
          Text("날짜 버튼이 있는 TextField (액션 포함)")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $dateText,
            title: "생년월일",
            placeholder: "YYYY-MM-DD",
            rightButtonType: .date,
            rightButtonAction: {
              alertMessage = "날짜 선택 버튼이 눌렸습니다"
              showAlert = true
            }
          )
        }
        
        // 편집 버튼이 있는 TextField (액션 포함)
        VStack(alignment: .leading, spacing: 8) {
          Text("편집 버튼이 있는 TextField (액션 포함)")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $editText,
            title: "메모",
            placeholder: "메모를 입력하세요",
            rightButtonType: .edit,
            rightButtonAction: {
              alertMessage = "편집 버튼이 눌렸습니다"
              showAlert = true
            }
          )
        }
        
        // 최대 글자수 제한이 있는 TextField
        VStack(alignment: .leading, spacing: 8) {
          Text("최대 글자수 제한 (10자)")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $maxCountText,
            title: "한 줄 소개",
            placeholder: "자기소개를 입력하세요",
            maxCount: 10
          )
        }
        
        // 에러 메시지가 있는 TextField
        VStack(alignment: .leading, spacing: 8) {
          Text("에러 메시지가 있는 TextField")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $errorText,
            title: "이메일",
            placeholder: "이메일을 입력하세요",
            errorMessage: "올바른 이메일 형식이 아닙니다"
          )
        }
        
        // 도움말 메시지가 있는 TextField
        VStack(alignment: .leading, spacing: 8) {
          Text("도움말 메시지가 있는 TextField")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $helperText,
            title: "비밀번호",
            placeholder: "비밀번호를 입력하세요",
            helperMessage: "8자 이상, 영문/숫자/특수문자 조합"
          )
        }
        
        // 클리어 버튼이 있는 TextField
        VStack(alignment: .leading, spacing: 8) {
          Text("클리어 버튼이 있는 TextField")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $clearButtonText,
            title: "검색",
            placeholder: "검색어를 입력하세요",
            hiddenClearButton: false,
            rightButtonType: .search,
            rightButtonAction: {
              alertMessage = "검색 실행: \(clearButtonText)"
              showAlert = true
            }
          )
        }
        
        // 액션이 있는 TextField (버튼 없이)
        VStack(alignment: .leading, spacing: 8) {
          Text("액션이 있는 TextField (버튼 없이)")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $actionText,
            title: "사용자 입력",
            placeholder: "입력 후 엔터를 누르세요",
            rightButtonType: .none,
            rightButtonAction: {
              alertMessage = "액션이 실행되었습니다: \(actionText)"
              showAlert = true
            }
          )
        }
        
        // 복합 케이스: 모든 기능이 포함된 TextField
        VStack(alignment: .leading, spacing: 8) {
          Text("복합 케이스 (모든 기능 포함)")
            .amdFont(.mediumBold)
            .foregroundStyle(.gray85)
          
          AMDTextField(
            text: $basicText,
            title: "상세 설명",
            placeholder: "상세한 설명을 입력하세요",
            hiddenClearButton: false,
            maxCount: 50,
            rightButtonType: .edit,
            rightButtonAction: {
              alertMessage = "편집 모드로 전환되었습니다"
              showAlert = true
            },
            errorMessage: "50자를 초과했습니다",
            helperMessage: "최대 50자까지 입력 가능합니다"
          )
        }
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
    }
    .navigationTitle("AMDTextField Demo")
    .navigationBarTitleDisplayMode(.inline)
    .alert("알림", isPresented: $showAlert) {
      Button("확인") { }
    } message: {
      Text(alertMessage)
    }
  }
}

#Preview {
  NavigationView {
    AMDTextFieldDemoView()
  }
}
