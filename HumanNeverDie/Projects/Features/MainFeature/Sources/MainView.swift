import SwiftUI

import CommonFeature

public struct MainView: View {
  @State private var viewModel: MainViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: MainViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  enum TestAction: String, CaseIterable, Identifiable {
     case get = "GET"
     case post = "POST"
     case put = "PUT"
     case patch = "PATCH"
     case delete = "DELETE"
     
     var id: String { rawValue }
     
     var action: MainViewModel.Action {
       switch self {
       case .get: return .onGetTapped
       case .post: return .onPostTapped
       case .put: return .onPutTapped
       case .patch: return .onPatchTapped
       case .delete: return .onDeleteTapped
       }
     }
   }
  
  public var body: some View {
    VStack {
#if DEBUG
      
      Text("DEBUG MODE")
        .foregroundColor(.red)
        .font(.caption)
      
      Text("DEBUG MODE userId: \(viewModel.todoData.userId)")
      Text("DEBUG MODE id: \(viewModel.todoData.id)")
      Text("DEBUG MODE title: \(viewModel.todoData.title)")
      Text("DEBUG MODE completed: \(viewModel.todoData.completed)")
      
      // ✅ 네트워크 테스트 레이블
      Text("🛜 NETWORK API TEST")
        .font(.headline)
        .padding(.top, 24)
      
      // ✅ 버튼 목록
      ForEach(TestAction.allCases) { test in
        Button(action: {
          print("👉 \(test.rawValue)")
          viewModel.handleAction(test.action)
        }) {
          Text(test.rawValue)
            .frame(width: 200, height: 25)
        }
        .buttonStyle(.borderedProminent)
        .padding(.bottom, 8)
      }
      
#else
      Text("Release MODE")
        .foregroundColor(.blue)
        .font(.caption)
      
      Text("Release MODE userId: \(viewModel.todoData.userId)")
      Text("Release MODE id: \(viewModel.todoData.id)")
      Text("Release MODE title: \(viewModel.todoData.title)")
#endif
    }
  }
}
