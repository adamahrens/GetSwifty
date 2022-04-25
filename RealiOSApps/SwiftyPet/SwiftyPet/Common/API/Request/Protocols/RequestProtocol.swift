//
//  RequestProtocol.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

protocol RequestProtocol {
  /// Path of the request
  var path: String { get }
  
  /// Headers to include in the request
  var headers: [String : String] { get }
  
  /// Request Body
  var body: [String: Any] { get }
  
  /// URL Encoded Query Params
  var queryParams: [String: String] { get }
  
  /// Determined if Authorization Token is required
  var authorized: Bool { get }
  
  /// Type of request to make POST, GET, PATCH, DELETE, etc
  var requestType: RequestType { get }
}

/// Default Implementation
extension RequestProtocol {
  var host: String {
    APIConstants.host
  }
  
  var authorized: Bool {
    true
  }
  
  var headers: [String: String] {
    [:]
  }
  
  var queryParams: [String: String] {
    [:]
  }
  
  var body: [String: Any] {
    [:]
  }
  
  func buildUrlRequest(authToken: String) throws -> URLRequest {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = path
    
    // Add query params if present
    if !queryParams.isEmpty {
      components.queryItems = queryParams.map { URLQueryItem(name: $0, value: $1) }
    }
    
    guard
      let url = components.url
    else { throw NetworkError.invalidURL }
    
    var request = URLRequest(url: url)
    request.httpMethod = requestType.rawValue
    
    // Add Headers if present
    if !headers.isEmpty {
      request.allHTTPHeaderFields = headers
    }
    
    // Is it an authorized request?
    if authorized && !authToken.isEmpty {
      request.setValue(authToken, forHTTPHeaderField: HTTPHeader.authorization)
    }
    
    request.setValue("application/json", forHTTPHeaderField: HTTPHeader.contentType)
    
    // Does it have a body?
    if !body.isEmpty {
      request.httpBody = try JSONSerialization.data(withJSONObject: body)
    }
    
    return request
  }
}

enum RequestType: String {
  case GET
  case POST
}
