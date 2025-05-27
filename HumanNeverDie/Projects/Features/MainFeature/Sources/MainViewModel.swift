//
//  MainViewModel.swift
//  MainFeature
//
//  Created by 김규철 on 5/25/25.
//

import Foundation
import Observation

import MainDomain

@Observable
@MainActor
public final class MainViewModel {
  enum Action {
    case onAppear
  }
  
  private(set) var todoData: Todo = .init(userId: 0, id: 0, title: "")
  
  private let mainUseCase: MainUseCase
  public init(mainUseCase: MainUseCase) {
    self.mainUseCase = mainUseCase
  }
  
  func handleAction(action: Action) {
    switch action {
    case .onAppear:
      Task { await fetchTodo() }
    }
  }
  
  private func fetchTodo() async {
    do {
      let todo = try await mainUseCase.fetchTodo()
      
      print("네트워크 통신 결과:", todo)
      todoData = todo
    } catch {
      print(error)
    }
  }
}
