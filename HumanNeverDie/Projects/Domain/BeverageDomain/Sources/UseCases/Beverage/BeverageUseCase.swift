import Foundation

import DependenciesMacros

@DependencyClient
public struct BeverageUseCase: Sendable {
  public var getBeverageCount: @Sendable () async throws -> BeverageCount
  public var getBeverageList: @Sendable (_ cursor: String?, _ sugarLevel: BeverageSugarLevelType?, _ onlyLiked: Bool) async throws -> BeverageList
  public var getBeverageDetail: @Sendable (_ productID: String) async throws -> BeverageDetail
  public var getBeverageMonthCalender: @Sendable (_ dateInWeek: String) async throws -> [BeverageCalendar]
  public var getBeverageWeeklyCalender: @Sendable (_ dateInWeek: String) async throws -> [BeverageCalendar]
  public var getBeveragDailyCalender: @Sendable (_ dailyDate: String) async throws -> BeverageCalendar
  public var likeBeverage: @Sendable (_ productID: String) async throws -> BeverageLike
  public var unLikeBeverage: @Sendable (_ productID: String) async throws -> BeverageLike
  public var searchBeverage: @Sendable (_ keyword: String, _ sugarLevel: BeverageSugarLevelType?, _ onlyLiked: Bool) async throws -> BeverageList
  public var recordBeverage: @Sendable (_ productID: String, _ recordDate: Date, _ size: String) async throws -> Bool
  public var deleteBeverage: @Sendable (_ productID: String, _ intakeTime: String) async throws -> Bool
  public var getBeverageLikeUpdate: @Sendable (_ beverages: [Beverage], _ productID: String, _ newLikeStatus: Bool) -> (beverageIndex: Int, likeCountChange: Int)?
}
