//
//  Router.swift
//  CommonFeature
//
//  Created by 김규철 on 5/25/25.
//

import SwiftUI
import Observation

@Observable
public final class Router {
  public var path = NavigationPath()
  public var rootRoute: RootRoute {
    didSet {
      self.rootViewId = UUID()
    }
  }
  
  public private(set) var rootViewId = UUID()
  private var resultHandler: ((any Equatable) -> Void)?
  
  public init(rootRoute: RootRoute = .splash) {
    print("root route: \(rootRoute)")
    self.rootRoute = rootRoute
  }
  
  public func push(to route: Route) {
    print("push: \(route)")
    path.append(route)
  }
  
  public func pop() {
    path.removeLast()
  }
  
  public func popWithResult<T: Equatable>(_ result: T) {
    let handler = resultHandler
    resultHandler = nil
    handler?(result)
    pop()
  }
  
  public func setResultHandler<T: Equatable>(_ handler: @escaping (T) -> Void) {
    resultHandler = { result in
      if let typedResult = result as? T {
        handler(typedResult)
      }
    }
  }
  
  public func popToRoot() {
    path.removeLast(path.count)
  }
  
  public func setRoute(_ route: RootRoute) {
    print("set root route: \(route)")
    path.removeLast(path.count)
    rootRoute = route
  }
}
