//
//  AMDProgress.swift
//  DesignSystem
//
//  Created by 김규철 on 6/24/25.
//

import SwiftUI

public struct AMDProgress: View {
  private let glucose: Double
  private let isStatusLabelHidden: Bool
  private let type: ProgressType
  private let variant: AMDStatusVariant
  
  public enum ProgressType {
    case small
    case medium
    
    fileprivate var height: CGFloat {
      switch self {
      case .small:
        return 10
      case .medium:
        return 12
      }
    }
    
    @ViewBuilder
    fileprivate var baseProgress: some View {
      switch self {
      case .small:
        Capsule()
          .fill(.gray15)
        
      case .medium:
        Capsule()
          .fill(.white)
          .overlay(
            Capsule()
              .stroke(.gray15, lineWidth: 1)
          )
      }
    }
  }
  
  private var progressGradient: LinearGradient {
    switch variant {
    case .healthy:
      return LinearGradient(colors: [.primaryLighter], startPoint: .leading, endPoint: .trailing)
    case .warning:
      return AMDGradient.phase2
    case .danger:
      return AMDGradient.phase3
    }
  }
  
  public init(
    glucose: Double,
    isStatusLabelHidden: Bool = false,
    type: ProgressType,
    variant: AMDStatusVariant
  ) {
    self.glucose = glucose
    self.isStatusLabelHidden = isStatusLabelHidden
    self.type = type
    self.variant = variant
  }
  
  public var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        type.baseProgress
        
        progressGradient
          .frame(width: geometry.size.width * CGFloat(glucose))
          .amdCornerRadius(.large, corners: [.topLeft, .bottomLeft])
          .animation(.easeInOut(duration: 0.3), value: glucose)
        
        divider(geometry.size.width)
      }
    }
    .frame(height: type.height)
    .if(!isStatusLabelHidden) { $0.statusLabel() }
  }
  
  private func divider(_ width: CGFloat) -> some View {
    HStack(spacing: 0) {
      Spacer()
        .frame(width: width * 0.33)
      
      Rectangle()
        .fill(.gray25)
        .frame(width: 1)
      
      Spacer()
        .frame(width: width * 0.33)
      
      Rectangle()
        .fill(.gray25)
        .frame(width: 1)
      
      Spacer()
    }
  }
}

private extension View {
  func statusLabel() -> some View {
    VStack(spacing: 4) {
      self
      
      HStack {
        ForEach(AMDStatusVariant.allCases, id: \.self) { status in
          Text(status.rawValue)
            .amdFont(.xsmallRegular)
            .foregroundStyle(.gray60)
            .frame(maxWidth: .infinity, alignment: .center)
        }
      }
    }
  }
}

#Preview {
  AMDProgress(glucose: 0.33, isStatusLabelHidden: true, type: .medium, variant: .danger)
}
