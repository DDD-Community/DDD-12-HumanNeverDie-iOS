//
//  AMDBeverageDetailViewModel.swift
//  CommonFeature
//
//  Created by 김규철 on 8/8/25.
//

import Foundation
import Observation

import BeverageDomain

import Dependencies

@Observable
@MainActor
public final class AMDBeverageDetailViewModel: ViewModelable {
  public struct State: Equatable {
    var beverageDetail: BeverageDetail?
    var selectedSize: BeverageSize?
  }
  
  public enum Action {
    case sizeItemTapped(BeverageSize)
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  public var state: State = .init()

  public init(productID: String) {
    Task {
      await getBeverageDetail(productID)
    }
  }
  
  deinit {
    print("deinit BeverageDetailViewModel")
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case let .sizeItemTapped(size):
      state.selectedSize = size
    }
  }
  
  private func getBeverageDetail(_ productID: String) async {
    do {
      let beverageDetail = try await beverageUseCase.getBeverageDetail(productID: productID)
      
      await MainActor.run {
        state.beverageDetail = beverageDetail
        state.selectedSize = beverageDetail.sizes.first
      }
    } catch {
      print(error)
    }
  }
}
