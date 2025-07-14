//
//  Observable+.swift
//  Shared
//
//  Created by 김규철 on 7/12/25.
//

import SwiftUI

public extension Observable where Self: AnyObject {
  func withObservationTracking(
    tracking apply: @escaping () -> Void,
    willChange: (() -> Void)? = nil,
    didChange: @escaping () -> Void
  ) async {
    Observation.withObservationTracking(apply) { [weak self] in
      guard let self else { return }
      willChange?()
      
      RunLoop.current.perform { [weak self] in
        guard let self else { return }
        didChange()
        
        Task { @MainActor in
          await self.withObservationTracking(
            tracking: apply,
            willChange: willChange,
            didChange: didChange
          )
        }
      }
    }
  }
}
