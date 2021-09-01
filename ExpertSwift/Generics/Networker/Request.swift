/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case update = "UPDATE"
  case delete = "DELETE"
}

protocol Request {
  associatedtype Response
  var url: URL { get }
  var method: HTTPMethod { get }
  var anyRequest: AnyRequest { get }
  func decode(_ data: Data) throws -> Response
}

extension Request where Response: Decodable {
  func decode(_ data: Data) throws -> Response {
    try JSONDecoder().decode(Response.self, from: data)
  }
}

extension Request {
  var anyRequest: AnyRequest {
    AnyRequest(url: url, method: method)
  }
}

struct AnyRequest: Hashable {
  let url: URL
  let method: HTTPMethod
}
