//
//  AMDLottieView.swift
//  DesignSystem
//
//  Created by 김규철 on 7/19/25.
//

import SwiftUI

import Lottie

public struct AMDLottieView: View {
  private let asset: AMDLottieAsset
  private let isLoopMode: Bool
  
  public init(
    asset: AMDLottieAsset,
    isLoopMode: Bool = true
  ) {
    self.asset = asset
    self.isLoopMode = isLoopMode
  }
  
  public var body: some View {
    LottieView(
      animation:.named(asset.rawValue, bundle: DesignSystemResources.bundle)
    )
    .playing(loopMode: isLoopMode ? .loop : .playOnce)
  }
}
