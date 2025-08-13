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
    var beverageRecordDate: Date

    var beverageDetail: BeverageDetail = .init(
      name: "",
      productID: "",
      thumbnailURL: "",
      defaultNutrition: BeverageNutrition(kcal: 0, sugar: 0, protein: 0, saturatedFat: 0, sodium: 0, caffeine: 0),
      sizes: [],
      brandName: ""
    )
  }

  public enum Action {
    case likeButtonTapped
    case recordButtonTapped
  }

  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase

  @ObservationIgnored
  @Dependency(\.beverageLocalLikeUseCase) private var beverageLocalLikeUseCase

  public var state: State
  public init(
    productID: String,
    isLiked: Bool,
    beverageRecordDate: Date
  ) {
    self.state = .init(
      productID: productID,
      isLiked: isLiked,
      beverageRecordDate: beverageRecordDate
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

      handleBeverageLike(
        state.beverageDetail.toBeverage(isLiked: originalIsLiked),
        newIsLiked: newLikedState,
        originalIsLiked: originalIsLiked
      )

    case .recordButtonTapped:
      Task { await recordBeverage() }
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

  private func handleBeverageLike(_ beverage: Beverage, newIsLiked: Bool, originalIsLiked: Bool) {
    do {
      var updatedBeverage = beverage
      updatedBeverage.isLiked = newIsLiked

      try beverageLocalLikeUseCase.handleBeverageLike(
        beverage: updatedBeverage,
        originalIsLiked: originalIsLiked
      )
    } catch {
      print("로컬 좋아요 저장 실패: \(error)")
    }
  }

  private func recordBeverage() async {
    do {
      let success = try await beverageUseCase.recordBeverage(
        productID: state.productID,
        recordDate: state.beverageRecordDate
      )

      if success {
        print("음료 기록 성공")
      } else {
        print("음료 기록 실패")
      }
    } catch {
      print("음료 기록 에러: \(error)")
    }
  }
}
