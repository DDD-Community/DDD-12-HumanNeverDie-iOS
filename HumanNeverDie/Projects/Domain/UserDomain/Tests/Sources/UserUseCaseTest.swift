//
//  UserUseCaseTest.swift
//  UserDomainTest
//
//  Created by Seulki Lee on 2025/07/20.
//

import Foundation
import Testing

import Dependencies

@testable import UserDomain

@Suite("UserUseCase.live")
struct UserUseCaseTests {

  @Test("getUserInfo: repository 의 결과를 그대로 반환한다")
  func getUserInfo() async throws {
    let expected = UserInfo.defaultUserInfo
    var repo = UserRepositoryInterface()
    repo.getUserInfo = { _ in expected }

    let result = try await withDependencies {
      $0.userRepository = repo
    } operation: {
      try await UserUseCase.live.getUserInfo("user-1")
    }

    #expect(result == expected)
  }

  @Test("updateUserInfo: repository 의 결과를 그대로 반환한다")
  func updateUserInfo() async throws {
    let expected = UserInfo.defaultUserInfo
    var repo = UserRepositoryInterface()
    repo.updateUserInfo = { _, _ in expected }

    let result = try await withDependencies {
      $0.userRepository = repo
    } operation: {
      try await UserUseCase.live.updateUserInfo("user-1", expected)
    }

    #expect(result == expected)
  }

  @Test("getUserSugarLavel: 성공 시 repository 결과를 반환한다")
  func getUserSugarLavel_success() async throws {
    let expected = UserSugarLevel.mock()
    var repo = UserRepositoryInterface()
    repo.getUserSugarLavel = { _ in expected }

    let result = await withDependencies {
      $0.userRepository = repo
    } operation: {
      await UserUseCase.live.getUserSugarLavel("user-1")
    }

    #expect(result == expected)
  }

  @Test("getUserSugarLavel: 네트워크 실패 시 mock() 으로 폴백한다")
  func getUserSugarLavel_fallbackToMock() async throws {
    struct DummyError: Error {}
    var repo = UserRepositoryInterface()
    repo.getUserSugarLavel = { _ in throw DummyError() }

    let result = await withDependencies {
      $0.userRepository = repo
    } operation: {
      await UserUseCase.live.getUserSugarLavel("user-1")
    }

    #expect(result == UserSugarLevel.mock())
  }
}
