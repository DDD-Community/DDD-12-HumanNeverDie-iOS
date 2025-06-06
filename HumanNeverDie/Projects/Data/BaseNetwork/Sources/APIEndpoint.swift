import Foundation

public struct APIEndpoint {
  let baseURL: String
  let path: String
  let method: HTTPMethod
  let body: (any Encodable)?
  public let headers: [String: String]?
  
  public init(
    baseURL: String,
    path: String,
    method: HTTPMethod,
    body: (any Encodable)? = nil,
    headers: [String: String]? = nil
  ) {
    self.baseURL = baseURL
    self.path = path
    self.method = method
    self.body = body
    self.headers = headers
  }
  
  var fullURL: String {
    return baseURL + path
  }
  
  public func asURLRequest() throws -> URLRequest {
     guard let url = URL(string: fullURL) else {
       throw NetworkError.failed(retryable: false, statusCode: -1)
     }

     var request = URLRequest(url: url)
     request.httpMethod = method.rawValue
     request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     
     headers?.forEach {
       request.setValue($0.value, forHTTPHeaderField: $0.key)
     }

     if let body = body {
       request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
     }

     return request
   }
}




public enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case PUT = "PUT"
  case PATCH = "PATCH"
  case DELETE = "DELETE"
}
