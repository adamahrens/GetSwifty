//
//  RequestManager.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

protocol RequestManagerProtocol {
  func send<T: Decodable>(request: RequestProtocol) async throws -> T
  func requestAccessToken() async throws -> String
}

final class RequestManager: RequestManagerProtocol {
  private let apiManager: APIManagerProtocol
  private let parser: DataParserProtocol
  private let tokenManager: AccessTokenManagerProtocol
  
  init(apiManager: APIManagerProtocol = APIManager(),
       parser: DataParserProtocol = DataParser(),
       accessTokenManager: AccessTokenManagerProtocol = AccessTokenManager()) {
    self.apiManager = apiManager
    self.parser = parser
    self.tokenManager = accessTokenManager
  }
  
  func send<T: Decodable>(request: RequestProtocol) async throws -> T {
    let authToken = try await requestAccessToken()
    print("Got authToken \(authToken)")
    let data = try await apiManager.send(request: request, authToken: authToken)
    print("Fetched data for ")
    let decoded: T = try parser.parse(data: data)
    return decoded
  }
  
  func requestAccessToken() async throws -> String {
    guard
      !tokenManager.isTokenValid()
    else { return tokenManager.fetchToken() }
    
    let data = try await apiManager.token()
    let token: APIToken = try parser.parse(data: data)
    return token.bearerAccessToken
  }
}
