//
// SplashViewModel.swift
// Splash
//
// Created by 김규철 on 2025.
//

import Foundation
import Observation

import CommonFeature
import BeverageDomain
import Shared

import Dependencies

@Observable
@MainActor
public final class SplashViewModel: ViewModelable {
  public struct State: Equatable {
    var isInitializationComplete: Bool = false
  }
  
  public enum Action {
    case onAppear
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  @Dependency(\.beverageLocalLikeUseCase) private var beverageLocalLikeUseCase
  
  @ObservationIgnored
  @Dependency(\.userDefaultClient) private var userDefaultClient
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      Task {
        await getUserMaxSugar()
        await syncLocalLikeToServer()
        await setInitializationCompleted()
      }
    }
  }
  
  private func syncLocalLikeToServer() async {
    do {
      let localLikes = try beverageLocalLikeUseCase.fetchAllBeverageLike()
      
      await withTaskGroup(of: String?.self) { group in
        for localLike in localLikes {
          group.addTask {
            do {
              if localLike.isLiked {
                _ = try await self.beverageUseCase.likeBeverage(productID: localLike.productID)
              } else {
                _ = try await self.beverageUseCase.unLikeBeverage(productID: localLike.productID)
              }
              return localLike.productID
            } catch {
              print("동기화 실패: \(localLike.productID)")
              return nil
            }
          }
        }
        
        for await productID in group {
          if let productID {
            do {
              try beverageLocalLikeUseCase.removeBeverageLike(productID: productID)
            } catch {
              print("로컬 삭제 실패: \(productID)")
            }
          }
        }
      }
    } catch {
      print("로컬 데이터 조회 실패")
    }
  }
  
  private func getUserMaxSugar() async {
    do {
      let result = try await beverageUseCase.getBeveragDailyCalender(dailyDate: "1999-01-01T17:30:00")
      
      // 시스템 권장값 저장
      await userDefaultClient.setValue(result.sugarMaxG, forKey: AMDUserDefaultKey.userMaxSugar)
      print("API 호출 성공 - systemMaxSugar: \(result.sugarMaxG) 저장 완료")
      
    } catch {
      print("API 호출 실패: \(error)")
    }
  }
  
  private func setInitializationCompleted() async {
    state.isInitializationComplete = true
  }
}
