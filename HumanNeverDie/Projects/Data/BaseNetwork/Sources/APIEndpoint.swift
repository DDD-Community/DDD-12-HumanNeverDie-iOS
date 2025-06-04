import Foundation

public struct APIEndpoint {
  let baseURL: String
  let path: String
  let method: HTTPMethod
  let body: (any Encodable)?
  
  public init(
    baseURL: String,
    path: String,
    method: HTTPMethod,
    body: (any Encodable)? = nil
  ) {
    self.baseURL = baseURL
    self.path = path
    self.method = method
    self.body = body
  }
  
  var fullURL: String {
    return baseURL + path
  }
}




public enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case PUT = "PUT"
  case PATCH = "PATCH"
  case DELETE = "DELETE"
}
