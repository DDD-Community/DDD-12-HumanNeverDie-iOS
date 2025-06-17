//
//  MainViewModel.swift
//  MainFeature
//
//  Created by 김규철 on 5/25/25.
//

import Foundation
import Observation

import CommonFeature
import MainDomain

import Dependencies

@Observable
@MainActor
public final class MainViewModel: ViewModelable {
  public struct State: Equatable {
    var todoData: Todo = .init(id: 0, userId: 0, title: "")
  }
  
  public enum Action {
    case onGetTapped
    case onPostTapped
    case onPutTapped
    case onPatchTapped
    case onDeleteTapped
  }
  
  public var state: State = .init()
  private let mainUseCase: MainUseCaseProtocol
  
  public init() {
    @Dependency(\.mainUseCase) var mainUseCase
    self.mainUseCase = mainUseCase
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onGetTapped:
      Task { await fetchTodo() }
      
    case .onPostTapped:
      Task { await postTodo() }
      
    case .onPutTapped:
      Task { await putTodo() }
      
    case .onPatchTapped:
      Task { await patchTodo() }
      
    case .onDeleteTapped:
      Task { await deleteTodo() }
    }
  }
}

private extension MainViewModel {
  func fetchTodo() async {
    do {
      let todo = try await mainUseCase.fetchTodo(id: 3)
      state.todoData = todo
      print("GET 결과:", todo)
    } catch {
      print(error)
    }
  }
  
  func postTodo() async {
    do {
      let todo = try await mainUseCase.postTodo(todo: .init(id: 3, userId: 2, title: "dataTest"))
      state.todoData = todo
      print("POST 결과:", todo)
    } catch {
      print("POST 실패:", error)
    }
  }
  
  func putTodo() async {
    do {
      let todo = try await mainUseCase.putTodo(todo: .init(id: 3, userId: 2, title: "dataTest"))
      state.todoData = todo
      print("PUT 결과:", todo)
    } catch {
      print("PUT 실패:", error)
    }
  }
  
  func patchTodo() async {
    do {
      let todo = try await mainUseCase.patchTodo(todo: .init(id: 5, userId: 0, title: "Edit"))
      state.todoData = todo
      print("PATCH 결과:", todo)
    } catch {
      print("PATCH 실패:", error)
    }
  }
  
  func deleteTodo() async {
    do {
      try await mainUseCase.deleteTodo(id: 3)
      print("DELETE 성공")
    } catch {
      print("DELETE 실패:", error)
    }
  }
}
