import Foundation

import DependenciesMacros

@DependencyClient
public struct BeverageLocalLikeUseCase: Sendable {
  public var fetchBeverageLikeCount: @Sendable () throws -> Int
  public var fetchAllBeverageLike: @Sendable () throws -> [BeverageLike]
  public var handleBeverageLike: @Sendable (_ beverage: Beverage, _ originalIsLiked: Bool) throws -> Void
  public var removeBeverageLike: @Sendable (_ productID: String) throws -> Void
}
