//
//  APIManager.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

/// Protocol for taking a RequestProtocol, Executing It, Returning Data or Throw An Error
protocol APIManagerProtocol {
  func send(request: RequestProtocol, authToken: String) async throws -> Data
  func token() async throws -> Data
}

final class APIManager: APIManagerProtocol {
  private let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func send(request: RequestProtocol, authToken: String = "") async throws -> Data {
    let urlRequest = try request.buildUrlRequest(authToken: authToken)
    let (data, response) = try await session.data(for: urlRequest)
    
    guard
      response.is200Status
    else { throw NetworkError.invalidServerResponse }
    
    return data
  }
  
  func token() async throws -> Data {
    try await send(request: AuthTokenRequest.auth)
  }
}
