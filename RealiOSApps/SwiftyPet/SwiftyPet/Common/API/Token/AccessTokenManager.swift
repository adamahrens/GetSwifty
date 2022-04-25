//
//  AccessTokenManager.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

protocol AccessTokenManagerProtocol {
  func isTokenValid() -> Bool
  func fetchToken() -> String
  func refreshWith(apiToken: APIToken) throws
}

class AccessTokenManager {
  private let userDefaults: UserDefaults
  private var accessToken: String?
  private var expiresAt = Date()

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
}

// MARK: - AccessTokenManagerProtocol
extension AccessTokenManager: AccessTokenManagerProtocol {
  func isTokenValid() -> Bool {
    accessToken = getToken()
    expiresAt = getExpirationDate()
    return accessToken != nil && expiresAt.compare(Date()) == .orderedDescending
  }

  func fetchToken() -> String {
    guard let token = accessToken else {
      return ""
    }
    return token
  }

  func refreshWith(apiToken: APIToken) throws {
    let expiresAt = apiToken.expiresAt
    let token = apiToken.bearerAccessToken

    save(token: apiToken)
    self.expiresAt = expiresAt
    self.accessToken = token
  }
}

// MARK: - Token Expiration
private extension AccessTokenManager {
  func save(token: APIToken) {
    userDefaults.set(token.expiresAt.timeIntervalSince1970, forKey: UserDefaultsKey.expiresAt)
    userDefaults.set(token.bearerAccessToken, forKey: UserDefaultsKey.bearerAccessToken)
  }

  func getExpirationDate() -> Date {
    Date(timeIntervalSince1970: userDefaults.double(forKey: UserDefaultsKey.expiresAt))
  }

  func getToken() -> String? {
    userDefaults.string(forKey: UserDefaultsKey.bearerAccessToken)
  }
}
