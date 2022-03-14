//: [Previous](@previous)

import Foundation
import SwiftUI

/// Models
struct User: Codable {
  let id: Int
  let name: String
  let username: String
  let phone: String
}

struct Post: Codable {
  let userId: Int
  let id: Int
  let title: String
  let body: String
}

struct UserDetails {
  let user: User
  let posts: [Post]
}

enum Endpoint {
  case posts
  case users
}

/// Extensions
extension Endpoint {
  var url: URL {
    switch self {
    case .posts : return URL(string: "https://jsonplaceholder.typicode.com/posts")!
    case .users : return URL(string: "https://jsonplaceholder.typicode.com/users")!
    }
  }
}

extension URLResponse {
  var isOkStatus: Bool {
    guard let r = self as? HTTPURLResponse else { return false }
    return 200..<300 ~= r.statusCode
  }
}

/// Errors

enum DecodeError: Error{
  case unableToDecode
}

enum EndpointError: Error {
  case badStatusCode(String)
  case noDataReturned
}

func decode<T: Codable>(_ type: T.Type, data: Data) -> Result<T, DecodeError> {
  do {
    let result = try JSONDecoder().decode(T.self, from: data)
    return .success(result)
  } catch {
    return .failure(.unableToDecode)
  }
}

/// Calls a URL
/// Checks response is 200...299, otherwise throws
/// Attempts to decode JSON, Returns Result if success or error
///
func fetchEndpointData<T: Codable>(url: URL) async throws -> Result<T, DecodeError> {
  let (data, response) = try await URLSession.shared.data(from: url)
  guard response.isOkStatus else { throw EndpointError.badStatusCode(Endpoint.users.url.absoluteString) }
  let result = decode(T.self, data: data)
  return result
}


func fetchUserDetails() async throws -> UserDetails {
  var user: User?
  let usersResult: Result<[User], DecodeError> = try await fetchEndpointData(url: Endpoint.users.url)
  
  switch usersResult {
  case .success(let users):
    user = users.first
  case .failure(let error):
    throw error
  }
  
  guard let u = user else { throw  EndpointError.noDataReturned }
  
  var posts = [Post]()
  let postsResult: Result<[Post], DecodeError> = try await fetchEndpointData(url: Endpoint.posts.url)
 
  switch postsResult {
  case .success(let pos):
    posts = pos.filter { $0.userId == u.id }
  case .failure(let error):
    throw error
  }
  
  return UserDetails(user: u, posts: posts)
}

Task {
  do {
    let details = try await fetchUserDetails()
    print("Fetched data with \(details)")
  } catch let e as EndpointError {
    print("Got endpoint error \(e)")
  } catch let e as DecodeError {
    print("Got decode error \(e)")
  }
}


//: [Next](@next)
