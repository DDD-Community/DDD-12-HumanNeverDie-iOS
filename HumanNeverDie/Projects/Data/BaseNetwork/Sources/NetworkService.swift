import Foundation

public protocol NetworkService {
  func request<Response: Decodable>(endpoint: APIEndpoint, responseType: Response.Type) async throws -> Response
}

public final class DefaultNetworkService: NetworkService {
  
  public init() {}
  
  public func request<Response: Decodable>(endpoint: APIEndpoint, responseType: Response.Type) async throws -> Response {
    let url = URL(string: endpoint.fullURL)!
    
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method.rawValue
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    let responseModel = try JSONDecoder().decode(responseType, from: data)
    
    return responseModel
  }
}

public enum NetworkError: Error {
  case failed
}
