//
//  AMDGlobalStateModifier.swift
//  CommonFeature
//
//  Created by 김규철 on 8/25/25.
//

import SwiftUI

import Dependencies

public struct GlobalStateModifier: ViewModifier {
  private let streamType: GlobalEvent
  private let action: () -> Void
  @Dependency(\.globalState) private var globalState
  
  public init(streamType: GlobalEvent, action: @escaping () -> Void) {
    self.streamType = streamType
    self.action = action
  }
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        Task {
          switch streamType {
          case .homeRefresh:
            for await _ in globalState.homeEventStream {
              action()
            }
          case .historyRefresh:
            for await _ in globalState.historyEventStream {
              action()
            }
          }
        }
      }
  }
}

public extension View {
  func onGlobalEvent(_ streamType: GlobalEvent, perform action: @escaping () -> Void) -> some View {
    modifier(GlobalStateModifier(streamType: streamType, action: action))
  }
}
