//
//  AMDChipDemoView.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 6/25/25.
//

import SwiftUI

import DesignSystem

struct AMDChipDemoView: View {
  @State private var selectedFilterChips: Set<String> = []
  @State private var selectedChipButtons: Set<String> = []
  @State private var tagChips: [String] = ["Tag 1", "Tag 2", "Tag 3"]

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        filterChipSection
        chipButtonSection
        tagChipSection
        interactionSection
      }
      .padding(.horizontal, 24)
    }
  }

  private var filterChipSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      sectionHeader(title: "Filter Chip", description: "선택 가능한 필터 칩")
      
      VStack(alignment: .leading, spacing: 12) {
        HStack(spacing: 12) {
          AMDFilterChip(
            icon: AMDImage.liked18.swiftUIImage,
            title: "좋아요",
            count: 3,
            isSelected: selectedFilterChips.contains("좋아요")
          ) {
            toggleFilterChip("좋아요")
          }
          
          AMDFilterChip(
            icon: AMDImage.success24.swiftUIImage,
            title: "성공",
            count: 1,
            isSelected: selectedFilterChips.contains("성공")
          ) {
            toggleFilterChip("성공")
          }
          
          AMDFilterChip(
            title: "전체",
            count: 10,
            isSelected: selectedFilterChips.contains("전체")
          ) {
            toggleFilterChip("전체")
          }
        }
      }
      .padding(.vertical, 8)
    }
  }
  
  private var chipButtonSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      sectionHeader(title: "Chip Button", description: "선택 가능한 칩 버튼")
      
      HStack(spacing: 12) {
        AMDChipButton(
          title: "남성",
          isSelected: selectedChipButtons.contains("남성")
        ) {
          toggleChipButton("남성")
        }
        
        AMDChipButton(
          title: "여성",
          isSelected: selectedChipButtons.contains("여성")
        ) {
          toggleChipButton("여성")
        }
        
        AMDChipButton(
          title: "기타",
          isSelected: selectedChipButtons.contains("기타")
        ) {
          toggleChipButton("기타")
        }
      }
    }
  }
  
  private var tagChipSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      sectionHeader(title: "Tag Chip", description: "삭제 가능한 태그 칩")
      
      HStack(spacing: 8) {
        ForEach(tagChips, id: \.self) { tag in
          AMDTagChip(title: tag) {
            removeTagChip(tag)
          }
        }
      }
    }
  }
  
  private var interactionSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      sectionHeader(title: "상호작용 예시", description: "필터 칩, 칩 버튼, 태그 칩의 선택/삭제 등 다양한 상호작용을 테스트할 수 있습니다.")
    }
  }
  
  private func sectionHeader(title: String, description: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .amdFont(.mediumBold)
        .foregroundColor(.gray80)
      Text(description)
        .amdFont(.smallRegular)
        .foregroundColor(.gray40)
    }
  }
  
  private func toggleFilterChip(_ name: String) {
    if selectedFilterChips.contains(name) {
      selectedFilterChips.remove(name)
    } else {
      selectedFilterChips.insert(name)
    }
  }
  
  private func toggleChipButton(_ name: String) {
    if selectedChipButtons.contains(name) {
      selectedChipButtons.remove(name)
    } else {
      selectedChipButtons.insert(name)
    }
  }

  private func removeTagChip(_ name: String) {
    tagChips.removeAll { $0 == name }
  }
}

#Preview {
  AMDChipDemoView()
}
