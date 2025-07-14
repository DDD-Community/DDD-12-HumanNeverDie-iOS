//
//  BeverageDetailViewModel.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/12/25.
//

import Foundation
import Observation

import CommonFeature
import BeverageDomain

import Dependencies

@Observable
@MainActor
public final class BeverageDetailViewModel: ViewModelable {
  public enum Size: String, CaseIterable {
    case tail = "Tail"
  }
  
  public struct State: Equatable {
    var beverageDetail: BeverageDetail?
    var size: Size = .tail
  }
  
  public enum Action {
    case sizeItemTapped(Size)
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
      // 백엔드 사이즈 별 리스폰스 업데이트 이후 수정
      state.size = size
    }
  }
  
  private func getBeverageDetail(_ productID: String) async {
    do {
      let beverageDetail = try await beverageUseCase.getBeverageDetail(productID: productID)
      
      await MainActor.run {
        state.beverageDetail = beverageDetail
      }
    } catch {
      print(error)
    }
  }
}
