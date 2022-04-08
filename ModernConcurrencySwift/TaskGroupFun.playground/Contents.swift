import UIKit

//: [Previous](@previous)

import Foundation
import SwiftUI

/// Models
struct User: Codable, CustomStringConvertible {
  let id: Int
  let name: String
  let username: String
  let phone: String
  
  var description: String {
    "\(id) name \(name) : \(username) -> tel://\(phone)"
  }
}

struct Post: Codable, CustomStringConvertible {
  let userId: Int
  let id: Int
  let title: String
  let body: String
  
  var description: String {
    "\(id) by \(userId) : \(title) -> \(body)"
  }
}

struct Comment: Codable, CustomStringConvertible {
  let postId: Int
  let id: Int
  let name: String
  let email: String
  let body: String
  
  var description: String {
    "\(id) by \(name) : \(email) -> \(body)"
  }
}

enum Endpoint {
  case posts
  case users
  case comments
}

/// Extensions
extension Endpoint {
  var url: URL {
    switch self {
    case .posts : return URL(string: "https://jsonplaceholder.typicode.com/posts")!
    case .users : return URL(string: "https://jsonplaceholder.typicode.com/users")!
    case .comments: return URL(string: "https://jsonplaceholder.typicode.com/comments")!
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

enum ApiError: Error {
  case badStatusCode(String)
  case unknownError
  case unableToDecode
}

/// Generic Decode
///

func decode<T: Codable>(_ type: T.Type, data: Data) -> Result<T, ApiError> {
  do {
    let result = try JSONDecoder().decode(T.self, from: data)
    return .success(result)
  } catch {
    return .failure(.unableToDecode)
  }
}

/// Calls a URL
/// Checks response is 200...299, otherwise return Result.failure
/// Attempts to decode JSON, Returns Result if success or error
///
func fetchEndpointData<T: Codable>(url: URL) async -> Result<T, ApiError> {
  do {
    let (data, response) = try await URLSession.shared.data(from: url)
    guard response.isOkStatus else { return .failure(ApiError.badStatusCode(Endpoint.users.url.absoluteString)) }
    let result = decode(T.self, data: data)
    return result
  } catch let error as ApiError {
    return .failure(error)
  } catch {
    return .failure(ApiError.unknownError)
  }
}

func convert<T: CustomStringConvertible>(result: Result<[T], ApiError>) -> Result<[String], ApiError> {
  switch result {
    case .success(let items) : return .success(items.map { $0.description })
    case .failure(let apiError) : return .failure(apiError)
  }
}

func fetchUsersConverted() async -> Result<[String], ApiError> {
  let result: Result<[User], ApiError> = await fetchEndpointData(url: Endpoint.users.url)
  return convert(result: result)
}

func fetchPostsConverted() async -> Result<[String], ApiError> {
  let result: Result<[Post], ApiError> = await fetchEndpointData(url: Endpoint.posts.url)
  return convert(result: result)
}

func fetchCommentsConverted() async -> Result<[String], ApiError> {
  let result: Result<[Comment], ApiError> = await fetchEndpointData(url: Endpoint.comments.url)
  return convert(result: result)
}

func fetchUsers() async -> Result<[User], ApiError> {
  print("Fetching Users")
  let result: Result<[User], ApiError> = await fetchEndpointData(url: Endpoint.users.url)
  print("Users fetched")
  return result
}

func fetchPosts() async -> Result<[Post], ApiError> {
  print("Fetching Posts")
  let result: Result<[Post], ApiError> = await fetchEndpointData(url: Endpoint.posts.url)
  print("Posts fetched")
  return result
}

func fetchComments() async -> Result<[Comment], ApiError> {
  print("Fetching Comments")
  let result: Result<[Comment], ApiError> = await fetchEndpointData(url: Endpoint.comments.url)
  print("Comments fetched")
  return result
}

Task {
  async let users = await fetchUsers()
  async let posts = await fetchPosts()
  async let comments =  await fetchComments()
  
  if case .success(let actualUsers) = users {
    print("Yay! Got \(actualUsers.count)")
  }
  
//  if case .success(let users) = await users,
//     case .success(let comments) = await comments,
//     case .success(let posts) = await posts {
//    print("Yay! Got \(users.count) users, \(comments.count) comments, and \(posts.count) posts")
//  }
}

/*

Task(priority: .low) {
  await withTaskGroup(of: Result<[String], ApiError>.self) { group in
    group.addTask {
      await fetchUsersConverted()
    }
//    group.addTask {
//      await fetchCommentsConverted()
//    }
    group.addTask {
      await fetchPostsConverted()
    }
    
    for await result in group {
      print("--- New Result ---\n")
      print(result)
      print("--- End Result ---\n\n\n")
    }
  }
}

enum ApiTask {
  case users(Result<[User], ApiError>)
  case posts(Result<[Post], ApiError>)
  case comments(Result<[Comment], ApiError>)
}

Task(priority: .high) {
  await withTaskGroup(of: ApiTask.self) { group in
    group.addTask {
      ApiTask.users(await fetchUsers())
    }
    group.addTask {
      ApiTask.posts(await fetchPosts())
    }
    group.addTask {
      ApiTask.comments(await fetchComments())
    }
    
    for await result in group {
      switch result {
      case .users(let result):
        print("Got Users")
        if case .success(let users) = result {
          print("First User \(users.first?.description ?? "")")
        }
      case .comments(let result):
        print("Got Comments")
        if case .success(let comments) = result {
          print("First Comment \(comments.first?.description ?? "")")
        }
      case .posts(let result):
        print("Got Posts")
        if case .success(let posts) = result {
          print("First Post \(posts.first?.description ?? "")")
        }
      }
    }
  }
}
*/


//: [Next](@next)
