//
//  Debounce+.swift
//  Shared
//
//  Created by 김규철 on 7/27/25.
//

import SwiftUI
import AsyncAlgorithms

public extension View {
  func debounce<T: Equatable>(
    _ query: Binding<T>,
    using channel: AsyncChannel<T>,
    for duration: Duration,
    action: @escaping (T) -> Void
  ) -> some View {
    self
      .task {
        for await query in channel.debounce(for: duration) {
          action(query)
        }
      }
      .task(id: query.wrappedValue) {
        await channel.send(query.wrappedValue)
      }
  }
}
