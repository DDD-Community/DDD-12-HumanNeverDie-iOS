import Foundation

import BaseNetwork
import MainDomain

public final class DefaultMainRepository: MainRepository {
  private let networkService: NetworkService
  
  public init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  public func fetchTodo() async throws -> Todo {
    let endpoint = APIEndpoint(
      baseURL: Config.baseURL,
      path: "/todos/1",
      method: .GET
    )
    return try await networkService.request(endpoint: endpoint, responseType: TodoResponse.self)
      .toDomain()
  }
}
