import SwiftUI

import CommonFeature

public struct MainView: View {
  @State private var viewModel: MainViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: MainViewModel) {
    self._viewModel = .init(initialValue: viewModel)
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
#else
      Text("Release MODE")
        .foregroundColor(.blue)
        .font(.caption)
      
      Text("Release MODE userId: \(viewModel.todoData.userId)")
      Text("Release MODE id: \(viewModel.todoData.id)")
      Text("Release MODE title: \(viewModel.todoData.title)")
#endif
    }
    .onAppear {
      viewModel.handleAction(action: .onAppear)
    }
  }
}
