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
import AuthDomain
import Shared

import Dependencies

@Observable
@MainActor
public final class SplashViewModel: ViewModelable {
  public struct State: Equatable {
    var route: RootRoute?
  }
  
  public enum Action {
    case onAppear
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  @Dependency(\.beverageLocalLikeUseCase) private var beverageLocalLikeUseCase
  
  @ObservationIgnored
  @Dependency(\.authUseCase) private var authUseCase
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      Task {
        guard await checkUserToken() else { return }
        guard await refreshTokenAndContinue() else { return }
        
        await syncLocalLikeToServer()
        await navigateTo(.main)
      }
    }
  }
  
  private func checkUserToken() async -> Bool {
    let hasToken = authUseCase.hasValidAccessToken()
    
    guard hasToken else {
      print("❌ 토큰 없음 - 로그인 화면으로 이동")
      await navigateTo(.login)
      return false
    }
    
    print("✅ 토큰 존재 - 토큰 재발급 시도")
    return true
  }
  
  private func refreshTokenAndContinue() async -> Bool {
    do {
      _ = try await authUseCase.refreshToken()
      print("✅ 토큰 재발급 성공")
      return true
    } catch {
      print("❌ 토큰 재발급 실패: \(error) - 로그인 화면으로 이동")
      await navigateTo(.login)
      return false
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
}

private extension SplashViewModel {
  func navigateTo(_ route: RootRoute) async {
    await MainActor.run {
      state.route = route
    }
  }
}
