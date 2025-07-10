//
//  AMDNetworkLogger.swift
//  BaseNetwork
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import Alamofire

final class AMDNetworkLogger: EventMonitor {
  let queue = DispatchQueue(label: "AMDNetworkLogger")
  
  func requestDidResume(_ request: Request) {
#if DEBUG
    let url = request.request?.url?.absoluteString ?? "Unknown"
    let method = request.request?.httpMethod ?? "Unknown"
    
    print("🚀 [\(method)] \(url)")
    
    if let query = request.request?.url?.query, !query.isEmpty {
      print("   📝 Query: \(query)")
    }
    
    if let httpBody = request.request?.httpBody,
       let bodyString = String(data: httpBody, encoding: .utf8) {
      let truncatedBody = bodyString.count > 200 ? String(bodyString.prefix(200)) + "..." : bodyString
      print("   📤 Body: \(truncatedBody)")
    }
    
    if let headers = request.request?.allHTTPHeaderFields {
      let importantHeaders = headers.filter { key, _ in
        ["Content-Type", "Authorization", "Accept"].contains(key)
      }
      if !importantHeaders.isEmpty {
        let headerString = importantHeaders.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
        print("   📋 Headers: \(headerString)")
      }
    }
#endif
  }
  
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
#if DEBUG
    let url = request.request?.url?.absoluteString ?? "Unknown"
    let method = request.request?.httpMethod ?? "Unknown"
    let responseTime = getResponseTime(from: response)
    
    switch response.result {
    case .success:
      let statusCode = response.response?.statusCode ?? 0
      print("✅ [\(method)] \(statusCode) \(url) (\(responseTime))")
      
    case .failure(let error):
      let statusCode = response.response?.statusCode ?? 0
      print("❌ [\(method)] \(statusCode) \(url) (\(responseTime))")
      print("   💥 Error: \(error.localizedDescription)")
    }
#endif
  }
  
  private func getResponseTime<Value>(from response: DataResponse<Value, AFError>) -> String {
#if DEBUG
    if let metrics = response.metrics {
      let taskInterval = metrics.taskInterval
      let duration = taskInterval.duration
      return String(format: "%.3fs", duration)
    }
    return "?.???s"
#else
    return ""
#endif
  }
}
