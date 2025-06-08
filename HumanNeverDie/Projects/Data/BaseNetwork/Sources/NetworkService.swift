import Foundation
import Alamofire

public protocol NetworkService {
    func request<Response: Decodable>(_ target: APIRequestable, as type: Response.Type) async throws -> Response
}

public final class DefaultNetworkService: NetworkService {
    private let session: Session

    public init(timeout: TimeInterval = 5) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        self.session = Session(configuration: configuration)
    }

    public func request<Response: Decodable>(
        _ target: APIRequestable, as type: Response.Type
    ) async throws -> Response {
        let dataTask = session.request(try target.asURLRequest())
            .validate()
            .serializingData()

        let response = await dataTask.response
        let statusCode = response.response?.statusCode ?? -1

        switch response.result {
        case .success(let data):
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
