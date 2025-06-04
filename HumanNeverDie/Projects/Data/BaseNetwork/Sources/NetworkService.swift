import Foundation


public protocol NetworkService {
  func request<Response: Decodable>(endpoint: APIEndpoint, responseType: Response.Type) async throws -> Response
//  func requestWithBody<Response: Decodable>(endpoint: APIEndpoint, responseType: Response.Type) async throws -> Response
  func deleteRequest( endpoint: APIEndpoint) async throws -> Bool
}

public final class DefaultNetworkService: NetworkService {
  let timeoutInterval: TimeInterval = 5
  
  public init() {}
  
  public func request<Response: Decodable>(
    endpoint: APIEndpoint,
    responseType: Response.Type
  ) async throws -> Response {
    guard let url = URL(string: endpoint.fullURL) else {
      throw NetworkError.invalidURL(failedURL: endpoint.fullURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.timeoutInterval = timeoutInterval

    if let body = endpoint.body {
      let encodedBody = try JSONEncoder().encode(AnyEncodable(body))
      request.httpBody = encodedBody
    }
    do {

      let (data, response) = try await URLSession.shared.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode) else {
        throw NetworkError.failed(retryable: false, statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
      }
      
      return try JSONDecoder().decode(responseType, from: data)
    } catch let error as URLError where error.code == .timedOut {
      throw NetworkError.failed(retryable: true, statusCode: -1001) // -1001: timeout
    }
  }

  
  public func deleteRequest( endpoint: APIEndpoint) async throws -> Bool {
    guard let url = URL(string: endpoint.fullURL) else {
      throw NetworkError.invalidURL(failedURL: endpoint.fullURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.timeoutInterval = timeoutInterval
    do {
      let (_, response) = try await URLSession.shared.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.failed(retryable: false, statusCode: -1)
      }
      
      return (200..<300).contains(httpResponse.statusCode)
    } catch let error as URLError where error.code == .timedOut {
      throw NetworkError.failed(retryable: true, statusCode: -1001) // -1001: timeout
    }
  }
}

public struct AnyEncodable: Encodable {
  private let encodeFunc: (Encoder) throws -> Void

  public init<T: Encodable>(_ wrapped: T) {
    self.encodeFunc = wrapped.encode
  }

  public func encode(to encoder: Encoder) throws {
    try encodeFunc(encoder)
  }
}

public enum NetworkError: Error {
  case complet(complet : Bool)
  case invalidURL(failedURL: String)
  case failed(retryable: Bool, statusCode: Int)
}
