//: [Previous](@previous)

import Foundation

enum Endpoint {
  case posts
  case users
  case comments
}

extension Endpoint {
  var url: URL {
    switch self {
    case .posts : return URL(string: "https://jsonplaceholder.typicode.com/posts")!
    case .users : return URL(string: "https://jsonplaceholder.typicode.com/users")!
    case .comments : return URL(string: "https://jsonplaceholder.typicode.com/comments")!
    }
  }
}

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

struct Comment: Codable {
  let postId: Int
  let id: Int
  let name: String
  let body: String
}

struct UserDetails {
  let user: User
  let posts: [Post]
}

typealias UserDetailsCompeletion = (UserDetails, [Comment]) -> Void

func fetchData(completion: @escaping UserDetailsCompeletion) {
  print("Starting fetch Data")
  DispatchQueue.global(qos: .userInitiated).async {
    let group = DispatchGroup()
    
    var users = [User]()
    var posts = [Post]()
    var comments = [Comment]()
    
    group.enter()
    print("Starting fetch Users")
    URLSession.shared.dataTask(with: Endpoint.users.url) { data, response, error in
      guard
        let res = response as? HTTPURLResponse, 200..<300 ~= res.statusCode
      else {
        print("Unable to fetch json from \(Endpoint.users.url.absoluteString)")
        return
      }
      
      guard
        error == nil
      else {
        print("Got error from \(Endpoint.users.url.absoluteString). \(error?.localizedDescription ?? "Unknown error")")
        return
      }
      
      guard
        let d = data
      else {
        print("No data returned from \(Endpoint.users.url.absoluteString)")
        return
      }
      
      guard
        let result = try? JSONDecoder().decode([User].self, from: d)
      else {
        print("Unable to decode JSON from \(Endpoint.users.url.absoluteString)")
        return
      }
      
      print("Done fetch Users")
      users = result
      group.leave()
    }.resume()
    
    group.enter()
    print("Starting fetch Comments")
    URLSession.shared.dataTask(with: Endpoint.comments.url) { data, response, error in
      guard
        let res = response as? HTTPURLResponse, 200..<300 ~= res.statusCode
      else {
        print("Unable to fetch json from \(Endpoint.comments.url.absoluteString)")
        return
      }
      
      guard
        error == nil
      else {
        print("Got error from \(Endpoint.comments.url.absoluteString). \(error?.localizedDescription ?? "Unknown error")")
        return
      }
      
      guard
        let d = data
      else {
        print("No data returned from \(Endpoint.comments.url.absoluteString)")
        return
      }
      
      guard
        let result = try? JSONDecoder().decode([Comment].self, from: d)
      else {
        print("Unable to decode JSON from \(Endpoint.comments.url.absoluteString)")
        return
      }
      
      print("Done fetch Comments")
      comments = result
      group.leave()
    }.resume()
    
    group.enter()
    print("Starting fetch Posts")
    URLSession.shared.dataTask(with: Endpoint.posts.url) { data, response, error in
      guard
        let res = response as? HTTPURLResponse, 200..<300 ~= res.statusCode
      else {
        print("Unable to fetch json from \(Endpoint.posts.url.absoluteString)")
        return
      }
      
      guard
        error == nil
      else {
        print("Got error from \(Endpoint.posts.url.absoluteString). \(error?.localizedDescription ?? "Unknown error")")
        return
      }
      
      guard
        let d = data
      else {
        print("No data returned from \(Endpoint.posts.url.absoluteString)")
        return
      }
      
      guard
        let result = try? JSONDecoder().decode([Post].self, from: d)
      else {
        print("Unable to decode JSON from \(Endpoint.posts.url.absoluteString)")
        return
      }
      
      print("Done fetch Posts")
      posts = result
      group.leave()
    }.resume()
    
    
    // Have to wait for all urls to finish
    group.wait()
    
    let user = users.randomElement()!
    let userPosts = posts.filter { $0.userId == user.id }
    let result = UserDetails(user: user, posts: userPosts)

    DispatchQueue.main.async {
      completion(result, comments)
    }
  }
}

func fetchDataWithNotify(completion: @escaping UserDetailsCompeletion) {
  print("Starting fetch Data")
  let group = DispatchGroup()
  
  var users = [User]()
  var posts = [Post]()
  var comments = [Comment]()
  
  group.enter()
  print("Starting fetch Users")
  URLSession.shared.dataTask(with: Endpoint.users.url) { data, response, error in
    guard
      let res = response as? HTTPURLResponse, 200..<300 ~= res.statusCode
    else {
      print("Unable to fetch json from \(Endpoint.users.url.absoluteString)")
      return
    }
    
    guard
      error == nil
    else {
      print("Got error from \(Endpoint.users.url.absoluteString). \(error?.localizedDescription ?? "Unknown error")")
      return
    }
    
    guard
      let d = data
    else {
      print("No data returned from \(Endpoint.users.url.absoluteString)")
      return
    }
    
    guard
      let result = try? JSONDecoder().decode([User].self, from: d)
    else {
      print("Unable to decode JSON from \(Endpoint.users.url.absoluteString)")
      return
    }
    
    print("Done fetch Users")
    users = result
    group.leave()
  }.resume()
  
  group.enter()
  print("Starting fetch Comments")
  URLSession.shared.dataTask(with: Endpoint.comments.url) { data, response, error in
    guard
      let res = response as? HTTPURLResponse, 200..<300 ~= res.statusCode
    else {
      print("Unable to fetch json from \(Endpoint.comments.url.absoluteString)")
      return
    }
    
    guard
      error == nil
    else {
      print("Got error from \(Endpoint.comments.url.absoluteString). \(error?.localizedDescription ?? "Unknown error")")
      return
    }
    
    guard
      let d = data
    else {
      print("No data returned from \(Endpoint.comments.url.absoluteString)")
      return
    }
    
    guard
      let result = try? JSONDecoder().decode([Comment].self, from: d)
    else {
      print("Unable to decode JSON from \(Endpoint.comments.url.absoluteString)")
      return
    }
    
    print("Done fetch Comments")
    comments = result
    group.leave()
  }.resume()
  
  group.enter()
  print("Starting fetch Posts")
  URLSession.shared.dataTask(with: Endpoint.posts.url) { data, response, error in
    guard
      let res = response as? HTTPURLResponse, 200..<300 ~= res.statusCode
    else {
      print("Unable to fetch json from \(Endpoint.posts.url.absoluteString)")
      return
    }
    
    guard
      error == nil
    else {
      print("Got error from \(Endpoint.posts.url.absoluteString). \(error?.localizedDescription ?? "Unknown error")")
      return
    }
    
    guard
      let d = data
    else {
      print("No data returned from \(Endpoint.posts.url.absoluteString)")
      return
    }
    
    guard
      let result = try? JSONDecoder().decode([Post].self, from: d)
    else {
      print("Unable to decode JSON from \(Endpoint.posts.url.absoluteString)")
      return
    }
    
    print("Done fetch Posts")
    posts = result
    group.leave()
  }.resume()
  
  group.notify(queue: DispatchQueue.main) {
    let user = users.randomElement()!
    let userPosts = posts.filter { $0.userId == user.id }
    let result = UserDetails(user: user, posts: userPosts)
    completion(result, comments)
  }
}

fetchData() { userDetails, comments in
  print("Got UserDetails \(userDetails)")
}

fetchDataWithNotify() { userDetails, comments in
  print("Got UserDetails Again \(userDetails)")
}

//: [Next](@next)
