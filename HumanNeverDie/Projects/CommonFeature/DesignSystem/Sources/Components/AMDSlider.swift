//
//  AMDSlider.swift
//  DesignSystem
//
//  Created by Claude on 1/10/26.
//

import SwiftUI

public struct AMDSlider: View {
  @Binding private var value: Double
  private let range: ClosedRange<Double>
  private var showsPercentageLabel: Bool = false
  private var trackHeight: CGFloat = 6
  private var thumbSize: CGFloat = 32
  private var activeTrackColor: Color = .amdPrimary
  private var inactiveTrackColor: Color = .gray15
  
  private var normalizedValue: Double {
    let clampedValue = min(max(value, range.lowerBound), range.upperBound)
    return (clampedValue - range.lowerBound) / (range.upperBound - range.lowerBound)
  }
  
  private var percentageText: String {
    let percentage = Int(normalizedValue * 100)
    return "\(percentage)%"
  }
  
  public init(
    value: Binding<Double>,
    in range: ClosedRange<Double> = 0...100
  ) {
    self._value = value
    self.range = range
  }
  
  public var body: some View {
    GeometryReader { geometry in
      let trackWidth = max(0, geometry.size.width - thumbSize)
      let thumbOffset = trackWidth * normalizedValue

      ZStack(alignment: .leading) {
        trackView(trackWidth: trackWidth, thumbOffset: thumbOffset)

        thumbView(thumbOffset: thumbOffset, trackWidth: trackWidth, geometry: geometry)
      }
    }
    .frame(height: showsPercentageLabel ? thumbSize + 38 : thumbSize)
  }
  
  private func trackView(trackWidth: CGFloat, thumbOffset: CGFloat) -> some View {
    ZStack(alignment: .leading) {
      Capsule()
        .fill(inactiveTrackColor)
        .frame(height: trackHeight)
        .padding(.horizontal, thumbSize / 2)
      
      Capsule()
        .fill(activeTrackColor)
        .frame(width: max(0, thumbOffset + thumbSize / 2), height: trackHeight)
        .padding(.leading, thumbSize / 2)
    }
    .padding(.top, showsPercentageLabel ? 38 : 0)
  }
  
  private func thumbView(thumbOffset: CGFloat, trackWidth: CGFloat, geometry: GeometryProxy) -> some View {
    VStack(spacing: 8) {
      if showsPercentageLabel {
        percentageLabelView
      }
      
      Circle()
        .fill(.white)
        .frame(width: thumbSize, height: thumbSize)
        .overlay(
          Circle()
            .strokeBorder(Color.gray15, lineWidth: 1)
        )
        .amdShadow(.fab)
    }
    .offset(x: thumbOffset)
    .gesture(
      DragGesture(minimumDistance: 0)
        .onChanged { gesture in
          updateValue(gesture: gesture, trackWidth: trackWidth, geometry: geometry)
        }
    )
  }
  
  private var percentageLabelView: some View {
    Text(percentageText)
      .amdFont(.mediumRegular)
      .foregroundStyle(.primaryDarker)
      .padding(.horizontal, 10)
      .padding(.vertical, 8)
      .background(
        RoundedRectangle(cornerRadius: 13)
          .fill(.white)
          .amdShadow(.card)
      )
  }
}

// MARK: - Helper Methods

extension AMDSlider {
  private func updateValue(gesture: DragGesture.Value, trackWidth: CGFloat, geometry: GeometryProxy) {
    guard trackWidth > 0 else { return }
    let xPosition = gesture.location.x - thumbSize / 2
    let clampedPosition = min(max(xPosition, 0), trackWidth)
    let newNormalizedValue = clampedPosition / trackWidth
    let newValue = range.lowerBound + newNormalizedValue * (range.upperBound - range.lowerBound)
    value = newValue
  }
}

// MARK: - Builder Methods

extension AMDSlider {
  public func showsPercentageLabel(_ show: Bool) -> AMDSlider {
    var slider = self
    slider.showsPercentageLabel = show
    return slider
  }
  
  public func trackHeight(_ height: CGFloat) -> AMDSlider {
    var slider = self
    slider.trackHeight = height
    return slider
  }
  
  public func thumbSize(_ size: CGFloat) -> AMDSlider {
    var slider = self
    slider.thumbSize = size
    return slider
  }
  
  public func activeTrackColor(_ color: Color) -> AMDSlider {
    var slider = self
    slider.activeTrackColor = color
    return slider
  }
  
  public func inactiveTrackColor(_ color: Color) -> AMDSlider {
    var slider = self
    slider.inactiveTrackColor = color
    return slider
  }
}
