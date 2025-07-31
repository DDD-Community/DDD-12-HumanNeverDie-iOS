//
//  BeverageRecordViewModel.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/28/25.
//

import Foundation
import Observation

import CommonFeature
import BeverageDomain

import Dependencies

@Observable
@MainActor
public final class BeverageRecordViewModel: ViewModelable {
  public struct State: Equatable {
    var productID: String
    var isLiked: Bool
    
    var beverageDetail: BeverageDetail = .init(name: "", productID: "", thumbnailURL: "", kcal: 0, sugar: 0, protein: 0, saturatedFat: 0, sodium: 0, caffeine: 0, brandName: "")
  }
  
  public enum Action {
    case likeButtonTapped
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  @Dependency(\.beverageLocalLikeUseCase) private var beverageLocalLikeUseCase
  
  public var state: State
  public init(
    productID: String,
    isLiked: Bool
  ) {
    self.state = .init(
      productID: productID,
      isLiked: isLiked
    )
    
    Task { await getBeverageDetail(productID) }
  }
  
  deinit {
    print("deinit BeverageRecordViewModel")
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .likeButtonTapped:
      let originalIsLiked = state.isLiked
      let newLikedState = !state.isLiked
      state.isLiked = newLikedState
      
      do {
        var updatedBeverage = state.beverageDetail.toBeverage(isLiked: originalIsLiked)
        updatedBeverage.isLiked = newLikedState
        
        try beverageLocalLikeUseCase.handleBeverageLike(
          beverage: updatedBeverage,
          originalIsLiked: originalIsLiked
        )
      } catch {
        print("로컬 좋아요 저장 실패: \(error)")
      }
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
