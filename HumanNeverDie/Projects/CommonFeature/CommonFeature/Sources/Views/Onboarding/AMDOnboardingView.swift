//
//  AMDOnboardingView.swift
//  CommonFeature
//
//  Created by 김규철 on 8/27/25.
//

import SwiftUI

import DesignSystem

public struct AMDOnboardingView: View {
  @State private var isDontShowAgain: Bool = false
  
  private let onDismiss: (Bool) -> Void
  
  public init(onDismiss: @escaping (Bool) -> Void) {
    self.onDismiss = onDismiss
  }
  
  public var body: some View {
    ZStack(alignment: .top) {
      backgroundView
      contentView
    }
  }
  
  private var backgroundView: some View {
    Color.black.opacity(0.75)
      .ignoresSafeArea()
  }
  
  private var contentView: some View {
    VStack(spacing: 0) {
      titleSection
      characterIconsSection
      mainContentSection
      actionSection
      Spacer()
    }
    .padding(.horizontal, 20)
  }
  
  private var titleSection: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 0) {
        Text("고미당씨는 ")
          .amdFont(.largeBold)
          .foregroundStyle(.white)
        
        Text("당 섭취량")
          .amdFont(.largeBold)
          .foregroundStyle(.amdPrimary)
        
        Text("에 따라서")
          .amdFont(.largeBold)
          .foregroundStyle(.white)
      }
      
      HStack(spacing: 0) {
        Text("3단 변화")
          .amdFont(.largeBold)
          .foregroundStyle(.amdPrimary)
        Text("해요")
          .amdFont(.largeBold)
          .foregroundStyle(.white)
      }
    }
    .padding(.top, 60)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var characterIconsSection: some View {
    HStack {
      AMDImage.homeOnboardingIcons.swiftUIImage
      Spacer()
    }
    .padding(.top, 12)
  }
  
  private var mainContentSection: some View {
    AMDImage.homeOnboarding.swiftUIImage
      .resizable()
      .scaledToFit()
      .frame(maxHeight: 450)
      .padding(.top, 35)
  }
  
  private var actionSection: some View {
    HStack {
      dontShowAgainCheckbox
      Spacer()
      closeButton
    }
    .padding(.top, 35)
  }
  
  private var dontShowAgainCheckbox: some View {
    Button {
      isDontShowAgain.toggle()
    } label: {
      HStack(spacing: 4) {
        Image(systemName: isDontShowAgain ? "checkmark.circle.fill" : "circle")
          .foregroundStyle(.white)
          .font(.system(size: 20))
        
        Text("다시 보지 않기")
          .amdFont(.mediumRegular)
          .foregroundStyle(.white)
      }
    }
  }
  
  private var closeButton: some View {
    Button {
      onDismiss(isDontShowAgain)
    } label: {
      Text("닫기")
        .amdFont(.smallRegular)
        .foregroundStyle(.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .amdStrokeBorder(.white, radius: .small, linewidth: 1)
    }
  }
}
