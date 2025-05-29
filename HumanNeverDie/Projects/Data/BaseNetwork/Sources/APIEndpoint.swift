import Foundation

public struct APIEndpoint {
  let baseURL: String
  let path: String
  let method: HTTPMethod
  
  public init(
    baseURL: String,
    path: String,
    method: HTTPMethod
  ) {
    self.baseURL = baseURL
    self.path = path
    self.method = method
  }
  
  var fullURL: String {
    return baseURL + path
  }
}

public enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
}
