//
// SplashViewModel.swift
// Splash
//
// Created by 김규철 on 2025.
//

import Foundation
import Observation

import CommonFeature
import UserDomain
import BeverageDomain
import AuthDomain
import Shared

import Dependencies

@Observable
@MainActor
public final class SplashViewModel: ViewModelable {
  public struct State: Equatable {
    var userID: String = ""
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
  
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  
  @ObservationIgnored
  @Dependency(\.keychainClient) private var keychainClient
  
  @ObservationIgnored
  @Dependency(\.userDefaultClient) private var userDefaultClient

  @ObservationIgnored
  @Dependency(\.notificationClient) private var notificationClient

  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      Task {
        guard await checkUserToken() else { return }
        guard await refreshTokenAndContinue() else { return }
        guard await checkUserID() else { return }
        guard await checkUserInfo() else { return }
        await checkNotification()
        await syncLocalLikeToServer()
        await navigateTo(.main)
      }
    }
  }
  
  private func checkUserToken() async -> Bool {
    let hasToken = authUseCase.hasValidAccessToken()
    
    guard hasToken else {
      printIfDebug("❌ 토큰 없음 - 로그인 화면으로 이동")
      await navigateTo(.login)
      return false
    }
    
    printIfDebug("✅ 토큰 존재 - 토큰 재발급 시도")
    return true
  }
  
  private func refreshTokenAndContinue() async -> Bool {
    do {
      _ = try await authUseCase.refreshToken()
      printIfDebug("✅ 토큰 재발급 성공")
      return true
    } catch {
      printIfDebug("❌ 토큰 재발급 실패: \(error) - 로그인 화면으로 이동")
      await navigateTo(.login)
      return false
    }
  }
  
  private func checkUserID() async -> Bool {
    guard let userID = keychainClient.getValue(forKey: AMDKeychainKey.userID) else {
      printIfDebug("❌ 유저아이디 없음 - 로그인 화면으로 이동")
      await navigateTo(.login)
      return false
    }
    
    printIfDebug("✅ 유저아이디 존재")
    state.userID = userID
    return true
  }
  
  private func checkUserInfo() async -> Bool {
    do {
      let userInfo = try await userUseCase.getUserInfo(userID: state.userID)
      
      guard !userInfo.nickname.isEmpty ||
            !userInfo.birthDate.isEmpty ||
            userInfo.selectedGender != .none else {
        await navigateTo(.onboarding)
        return false
      }
      
      return true
    } catch {
      printIfDebug("❌ 유저 정보 로딩 실패 & 정보없음: \(error)")
      await navigateTo(.login)
      return false
    }
  }
  
  private func checkNotification() async {
    do {
      let isNotDetermined = await notificationClient.isNotDetermined()

      if isNotDetermined {
        let granted = try await notificationClient.requestAuthorization()
        _ = try await userUseCase.updateNotifications(userID: state.userID, isEnabled: granted)
      }

      await notificationClient.registerForRemoteNotifications()
    } catch {
      printIfDebug("❌ notification Register 실패 \(error)")
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
              printIfDebug("❌ 동기화 실패: \(localLike.productID)")
              return nil
            }
          }
        }
        
        for await productID in group {
          if let productID {
            do {
              try beverageLocalLikeUseCase.removeBeverageLike(productID: productID)
            } catch {
              printIfDebug("❌ 로컬 삭제 실패: \(productID)")
            }
          }
        }
      }
    } catch {
      printIfDebug("❌ 로컬 데이터 조회 실패")
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
