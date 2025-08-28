//
//  AMDOnboardingView.swift
//  CommonFeature
//
//  Created by 김규철 on 8/27/25.
//

import SwiftUI

import DesignSystem

public struct AMDOnboardingView: View {
  private let onDismiss: () -> Void
  @State private var isFirstContentVisible: Bool = true
  
  public init(onDismiss: @escaping () -> Void) {
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
      closeButtonSection
      Spacer()
      contentSection
      Spacer()
      Spacer()
    }
    .ignoresSafeArea()
    .animation(.default, value: isFirstContentVisible)
  }
  
  private var closeButtonSection: some View {
    HStack {
      Spacer()
      
      Button {
        if isFirstContentVisible {
          isFirstContentVisible = false
        } else {
          onDismiss()
        }
      } label: {
        AMDImage.delete24.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(.white)
      }
    }
    .padding(.top, 60)
    .padding(.horizontal, 20)
  }
  
  private var contentSection: some View {
    Group {
      if isFirstContentVisible {
        firstContentSection
      } else {
        secondContentSection
      }
    }
    .animation(.default, value: isFirstContentVisible)
  }
  
  private var firstContentSection: some View {
    VStack(alignment: .center, spacing: 20) {
      VStack(alignment: .center, spacing: 0) {
        Text("고미당씨는 그 날의")
          .amdFont(.largeBold)
          .foregroundStyle(.white)
        
        HStack(spacing: 0) {
          Text("당 섭취량")
            .amdFont(.largeBold)
            .foregroundStyle(.amdPrimary)
          
          Text("에 따라")
            .amdFont(.largeBold)
            .foregroundStyle(.white)
          
          Text("3단 변화")
            .amdFont(.largeBold)
            .foregroundStyle(.amdPrimary)
          Text("해요")
            .amdFont(.largeBold)
            .foregroundStyle(.white)
        }
      }
      .frame(maxWidth: .infinity, alignment: .center)
      
      AMDImage.homeOnboarding.swiftUIImage
        .resizable()
        .scaledToFit()
        .frame(maxHeight: 450)
    }
    .padding(.horizontal, 45)
  }
  
  private var secondContentSection: some View {
    ZStack(alignment: .bottom) {
      AMDImage.homeOnboarding2.swiftUIImage
        .resizable()
        .scaledToFit()
        .frame(maxHeight: 384)
      
      VStack(alignment: .center, spacing: 30) {
        AMDImage.homeOnboarding2Icon.swiftUIImage
        
        VStack(alignment: .center, spacing: 0) {
          Text("카드를 뒤집어")
            .amdFont(.largeBold)
            .foregroundStyle(.white)
          
          HStack(spacing: 0) {
            Text("오늘 마신 음료")
              .amdFont(.largeBold)
              .foregroundStyle(.amdPrimary)
            
            Text("를 확인해보세요")
              .amdFont(.largeBold)
              .foregroundStyle(.white)
          }
        }
        .frame(maxWidth: .infinity, alignment: .center)
      }
      .padding(.bottom, 60)
    }
    .padding(.horizontal, 45)
  }
}
