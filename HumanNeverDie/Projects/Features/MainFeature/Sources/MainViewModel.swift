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
    case onGetTapped
    case onPostTapped
    case onPutTapped
    case onPatchTapped
    case onDeleteTapped
  }
  
  private(set) var todoData: Todo = .init(id: 0, userId: 0, title: "")
  private(set) var todoDataWithTest: Todo = .init(id: 3, userId: 2, title: "dataTest")
  private(set) var todoDataWithEdit: TodoEditing = .init(id: 5, title: "Edit")
  private let mainUseCase: MainUseCaseProtocol
  
  public init() {
    @Dependency(\.mainUseCase) var mainUseCase
    self.mainUseCase = mainUseCase
  }
  
  func handleAction(_ action: Action) {
    Task {
      do {
        switch action {
        case .onGetTapped:
          todoData = try await mainUseCase.fetchTodo(id: todoDataWithTest.id)
          print("GET 결과:", todoData)
          
        case .onPostTapped:
          todoData = try await mainUseCase.postTodo(todo: todoDataWithTest)
          print("POST 결과:", todoData)
          
        case .onPutTapped:
          todoData = try await mainUseCase.putTodo(todo: todoDataWithTest)
          print("PUT 결과:", todoData)
          
        case .onPatchTapped:
          todoData = try await mainUseCase.patchTodo(todoEditing: todoDataWithEdit)
          print("PATCH 결과:", todoData)
          
        case .onDeleteTapped:
          let result = try await mainUseCase.deleteTodo(id: todoDataWithTest.id)
          print("DELETE 결과:", result)
        }
      } catch {
        print("\(action) 실패:", error)
      }
    }
  }
  
}
