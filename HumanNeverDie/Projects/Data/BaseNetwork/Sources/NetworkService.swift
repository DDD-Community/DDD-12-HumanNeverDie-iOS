import Foundation
import Alamofire

public protocol NetworkService {
    func request<Response: Decodable>(_ target: APIRequestable, as type: Response.Type) async throws -> Response
    func requestDDD<Response: Decodable>(_ target: APIRequestable, as type: Response.Type) async throws -> Response
    func request(_ target: APIRequestable) async throws
}

public final class DefaultNetworkService: NetworkService {
    private let session: Session

    public init(timeout: TimeInterval = 5) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        self.session = Session(configuration: configuration)
    }

    // 테스트용 / 외부 API 용도
    public func request<Response: Decodable>(
        _ target: APIRequestable,
        as type: Response.Type
    ) async throws -> Response {
        let dataTask = session.request(try target.asURLRequest())
            .validate()
            .serializingData()

        let response = await dataTask.response
        let statusCode = response.response?.statusCode ?? -1

        switch response.result {
        case .success(let data):
            do {
                return try JSONDecoder().decode(Response.self, from: data)
            } catch {
                throw AppError.network(retryable: false, statusCode: statusCode)
            }

        case .failure(let error):
            if let urlError = error.underlyingError as? URLError,
               urlError.code == .timedOut {
                throw AppError.network(retryable: false, statusCode: -1001)
            } else {
                throw AppError.network(retryable: false, statusCode: statusCode)
            }
        }
    }
  
  public func request(_ target: APIRequestable) async throws {
      let dataTask = session.request(try target.asURLRequest())
          .validate()
          .serializingData()

      let response = await dataTask.response
      let statusCode = response.response?.statusCode ?? -1

      switch response.result {
      case .success:
          return

      case .failure(let error):
          if let urlError = error.underlyingError as? URLError,
             urlError.code == .timedOut {
              throw AppError.network(retryable: false, statusCode: -1001)
          } else {
              throw AppError.network(retryable: false, statusCode: statusCode)
          }
      }
  }

    // ✅ 실사용용 (서버 공통 응답 포맷 사용)
    public func requestDDD<Response: Decodable>(
        _ target: APIRequestable,
        as type: Response.Type
    ) async throws -> Response {
        let dataTask = session.request(try target.asURLRequest())
            .validate()
            .serializingData()

        let response = await dataTask.response
        let statusCode = response.response?.statusCode ?? -1

        switch response.result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(APIResponse<Response>.self, from: data)

                if let result = decoded.data {
                    return result
                } else {
                    throw APIError(
                        code: decoded.code,
                        status: decoded.status,
                        message: "응답 데이터가 없습니다.",
                        path: nil,
                        timestamp: nil
                    )
                }

            } catch {
                if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                    throw apiError
                } else {
                    throw AppError.network(retryable: false, statusCode: statusCode)
                }
            }

        case .failure(let error):
            if let urlError = error.underlyingError as? URLError,
               urlError.code == .timedOut {
                throw AppError.network(retryable: false, statusCode: -1001)
            } else {
                throw AppError.network(retryable: false, statusCode: statusCode)
            }
        }
    }
}

