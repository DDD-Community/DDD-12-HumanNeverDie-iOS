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
import Shared

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
      brandType: nil
    )
    var selectedSizeType: BeverageSize?
    var isBeverageRecordCompleted: Bool = false
    
    var baseSugar: Int = 0
    var totalSugar: Int = 0
  }
  
  public enum Action {
    case likeButtonTapped
    case recordButtonTapped
    case beverageSizeButtonTapped(BeverageSize)
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  @Dependency(\.beverageLocalLikeUseCase) private var beverageLocalLikeUseCase
  
  @ObservationIgnored
  @Dependency(\.globalState) private var globalState
  
  @ObservationIgnored
  @Dependency(\.userDefaultClient) private var userDefaultClient
  
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
    
    Task { 
      await getBeverageDetail(productID)
      await getUserSugar()
    }
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
      
      Task {
        await handleBeverageLike(
          state.beverageDetail.toBeverage(isLiked: originalIsLiked),
          newIsLiked: newLikedState,
          originalIsLiked: originalIsLiked
        )
      }
      
    case .recordButtonTapped:
      Task { await recordBeverage() }
      
    case let .beverageSizeButtonTapped(sizeType):
      let previousSugar = state.selectedSizeType?.nutrition.sugar ?? 0
      let newSugar = sizeType.nutrition.sugar
      
      state.selectedSizeType = sizeType
      state.totalSugar = state.totalSugar - previousSugar + newSugar
    }
  }
  
  private func getBeverageDetail(_ productID: String) async {
    do {
      let beverageDetail = try await beverageUseCase.getBeverageDetail(productID: productID)
      
      await MainActor.run {
        state.beverageDetail = beverageDetail
        state.selectedSizeType = beverageDetail.sizes.first
      }
    } catch {
      print(error)
    }
  }
  
  private func getUserSugar() async {
    guard let baseSugar: Int = userDefaultClient.getValue(forKey: AMDUserDefaultKey.baseSugar),
          let totalSugar: Int = userDefaultClient.getValue(forKey: AMDUserDefaultKey.totalSugar) else {
      return
    }
    
    await MainActor.run {
      state.baseSugar = baseSugar
      state.totalSugar = totalSugar + (state.selectedSizeType?.nutrition.sugar ?? 0)
    }
  }
  
  private func handleBeverageLike(_ beverage: Beverage, newIsLiked: Bool, originalIsLiked: Bool) async {
    do {
      if newIsLiked {
        _ = try await beverageUseCase.likeBeverage(productID: beverage.productID)
      } else {
        _ = try await beverageUseCase.unLikeBeverage(productID: beverage.productID)
      }
      
      await MainActor.run {
        globalState.beverageLikeUpdatePublisher.send((productID: beverage.productID, isLiked: newIsLiked))
      }
    } catch {
      saveToLocalStorage(beverage, newIsLiked: newIsLiked, originalIsLiked: originalIsLiked)
    }
  }
  
  private func saveToLocalStorage(_ beverage: Beverage, newIsLiked: Bool, originalIsLiked: Bool) {
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
      guard let selectedSize = state.selectedSizeType else {
        throw BeverageRecordError.noSizeSelected
      }
      
      let success = try await beverageUseCase.recordBeverage(
        productID: state.productID,
        recordDate: state.beverageRecordDate,
        size: selectedSize.sizeType.uppercased()
      )
      
      if success {
        await MainActor.run {
          state.isBeverageRecordCompleted = true
        }
      } else {
        print("음료 기록 실패")
      }
    } catch {
      print("음료 기록 에러: \(error)")
    }
  }
}
