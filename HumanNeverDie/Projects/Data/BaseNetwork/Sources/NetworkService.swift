import Foundation
import Alamofire

public protocol NetworkService {
  func request<Response: Decodable>(endpoint: APIEndpoint, responseType: Response.Type) async throws -> Response
}

public final class DefaultNetworkService: NetworkService {
  private let session: Session

  public init(timeout: TimeInterval = 5) {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = timeout
    self.session = Session(configuration: configuration)
  }

  public func request<Response: Decodable>(
    endpoint: APIEndpoint,
    responseType: Response.Type
  ) async throws -> Response {
    let dataTask = session.request(try endpoint.asURLRequest())
      .validate()
      .serializingData()

    let response = await dataTask.response
    let statusCode = response.response?.statusCode ?? -1

    switch response.result {
    case .success(let data):
      // 바디가 비었거나 {}라면 직접 JSON 제공
      if data.isEmpty ||
         String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) == "{}" {

        let json = """
        {
          "id": 0,
          "userId": 0,
          "title": "",
          "completed": true
        }
        """
        let jsonData = json.data(using: .utf8)!
        return try JSONDecoder().decode(Response.self, from: jsonData)
      }

      do {
        return try JSONDecoder().decode(Response.self, from: data)
      } catch {
        throw NetworkError.failed(retryable: false, statusCode: statusCode)
      }

    case .failure(let error):
      if let urlError = error.underlyingError as? URLError,
         urlError.code == .timedOut {
        throw NetworkError.failed(retryable: true, statusCode: -1001)
      } else {
        throw NetworkError.failed(retryable: false, statusCode: statusCode)
      }
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
  case failed(retryable: Bool, statusCode: Int)
}
