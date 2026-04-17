//
//  BeverageLocalSearchUseCaseTest.swift
//  BeverageDomainTest
//

import Foundation
import Testing

import Dependencies
import Shared

@testable import BeverageDomain

@Suite("BeverageLocalSearchUseCase.live")
struct BeverageLocalSearchUseCaseTests {

  @Test("addRecentSearch: 검색어를 최근 검색 목록 맨 앞에 추가한다")
  func addRecentSearch_prependsNewTerm() async throws {
    let userDefault = StubUserDefaultClient()
    await userDefault.setValue(["라떼", "아메리카노"], forKey: AMDUserDefaultKey.recentSearchList)

    await withDependencies {
      $0.userDefaultClient = userDefault
    } operation: {
      await BeverageLocalSearchUseCase.live.addRecentSearch("모카")
    }

    let list: [String]? = userDefault.getValue(forKey: AMDUserDefaultKey.recentSearchList)
    #expect(list == ["모카", "라떼", "아메리카노"])
  }

  @Test("addRecentSearch: 중복 검색어는 맨 앞으로 이동 (기존 항목 제거)")
  func addRecentSearch_deduplicates() async throws {
    let userDefault = StubUserDefaultClient()
    await userDefault.setValue(["라떼", "아메리카노", "모카"], forKey: AMDUserDefaultKey.recentSearchList)

    await withDependencies {
      $0.userDefaultClient = userDefault
    } operation: {
      await BeverageLocalSearchUseCase.live.addRecentSearch("아메리카노")
    }

    let list: [String]? = userDefault.getValue(forKey: AMDUserDefaultKey.recentSearchList)
    #expect(list == ["아메리카노", "라떼", "모카"])
  }

  @Test("addRecentSearch: 빈 문자열은 저장하지 않는다")
  func addRecentSearch_emptyStringIgnored() async throws {
    let userDefault = StubUserDefaultClient()

    await withDependencies {
      $0.userDefaultClient = userDefault
    } operation: {
      await BeverageLocalSearchUseCase.live.addRecentSearch("")
    }

    let list: [String]? = userDefault.getValue(forKey: AMDUserDefaultKey.recentSearchList)
    #expect(list == nil)
  }

  @Test("removeRecentSearch: 지정한 검색어만 목록에서 제거한다")
  func removeRecentSearch() async throws {
    let userDefault = StubUserDefaultClient()
    await userDefault.setValue(["라떼", "아메리카노", "모카"], forKey: AMDUserDefaultKey.recentSearchList)

    await withDependencies {
      $0.userDefaultClient = userDefault
    } operation: {
      await BeverageLocalSearchUseCase.live.removeRecentSearch("아메리카노")
    }

    let list: [String]? = userDefault.getValue(forKey: AMDUserDefaultKey.recentSearchList)
    #expect(list == ["라떼", "모카"])
  }
}
