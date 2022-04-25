//
//  NetworkError.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

enum NetworkError: LocalizedError {
  case invalidServerResponse
  case invalidURL
  public var errorDescription: String? {
    switch self {
    case .invalidServerResponse:
      return "The server returned an invalid response."
    case .invalidURL:
      return "URL string is malformed."
    }
  }
}
