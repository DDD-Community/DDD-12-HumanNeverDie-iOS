//
// LoginViewModel.swift
// Auth
//
// Created by 김규철 on 2025.
//

import Foundation
import Observation

import AuthDomain
import CommonFeature
import DesignSystem

import Dependencies

@Observable
@MainActor
public final class LoginViewModel: ViewModelable {
  public struct State: Equatable {
    public var isLoading: Bool = false
    public var isLoginSuccess: Bool = false
  }
  
  public enum Action {
    case onAppear
    case loginButtonTapped
  }
  
  @ObservationIgnored
  @Dependency(\.authUseCase) private var authUseCase
  @ObservationIgnored
  @Dependency(\.toastClient) private var toastClient
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case .loginButtonTapped:
      Task.detached { [weak self] in
        await self?.loginWithApple()
      }
    }
  }
  
  private func loginWithApple() async {
    await MainActor.run {
      state.isLoading = true
    }
    
    do {
      let success = try await authUseCase.loginWithApple()
      
      await MainActor.run {
        state.isLoginSuccess = success
        state.isLoading = false
      }
    } catch {
      await MainActor.run {
        state.isLoading = false
      }
      
      print(error.errorDescription )
      
      await toastClient.showToast(
        AMDToastProperty(
          message: error.errorDescription ?? "로그인 중 오류가 발생했습니다",
          type: .failure
        )
      )
    }
  }
}
