import UIKit
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/// How to login to get auth token

let config = URLSessionConfiguration.default
config.waitsForConnectivity = true
let session = URLSession(configuration: config)


/// Requests
protocol Endpointable {
  var url: URL { get }
}

enum Endpoint: String, Endpointable {
  
  /// GET users
  case users
  
  /// POST login
  case login
  
  /// POST new acronym
  case new
  
  /// URL to make request to
  var url: URL {
    let base = URL(string: "https://tilftw.herokuapp.com/")!
    return URL(string: self.rawValue, relativeTo: base)!
  }
}

/// Models
struct User: Codable {
  let name: String
  let email: String
  let password: String
}

struct Acronym: Codable {
  let short: String
  let long: String
}

struct Auth: Codable {
  let token: String
}


/// Coding
let encoder = JSONEncoder()
let decoder = JSONDecoder()


/// Making requests
let user = User(name: "Adam", email: "adam@me.com", password: "password654321!")
let loginString = "\(user.email):\(user.password)"
guard
  let data = loginString.data(using: .utf8)
else { fatalError("Unable to encode login string")}

let encodedLogin = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))

/// POST to login

var request = URLRequest(url: Endpoint.login.url)
request.httpMethod = "POST"
request.allHTTPHeaderFields = ["Accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "Basic \(encodedLogin)"]

session.dataTask(with: request) { data, response, error in
  guard let response = response, let data = data else {
    fatalError("Bad response from server")
  }
  
  print(response)
  print(HTTPCookieStorage.shared.cookies(for: response.url!))
  
  if let auth = try? decoder.decode(Auth.self, from: data) {
    print("Successfully got auth token. \(auth)")
    
    // Build request with Bearer Authorization
    // Then set the httpBody for the POST
    var acroynmRequest = URLRequest(url: Endpoint.new.url)
    acroynmRequest.httpMethod = "POST"
    acroynmRequest.allHTTPHeaderFields = ["Accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "Bearer \(auth.token)"]
    
    let acroynm = Acronym(short: "fml", long: "Fuck My Life")
    acroynmRequest.httpBody = try? encoder.encode(acroynm)
    
    // Execute the request to the server
    
    session.dataTask(with: acroynmRequest) { _, response, _ in
      guard let response = response else {
        fatalError("Unable to POST new acronym")
      }
      
      print(response)
    }.resume()
  }
  
}.resume()


// Working with cookies

let google = URL(string: "https://www.google.com")!
let googleRequest = URLRequest(url: google)
session.dataTask(with: googleRequest){ data, response, error in
  // Need to access cookies from response header fields
  
  if let httpResponse = response as? HTTPURLResponse {
    if let cookies = httpResponse.allHeaderFields as? [String : String] {
//      print(cookies)
      
      let blah = HTTPCookie.cookies(withResponseHeaderFields: cookies, for: google)
      blah.forEach { cookie in
        print("\(cookie.name) <--->  \(cookie.value)")
      }
//      if let firstCookie = blah.first {
//        print("\(firstCookie.name) = \(firstCookie.value)")
//      }
      
      // Print all cookies in HttpCookieStorage
      print("----- All HTTPCookieStorage ------\n")
      HTTPCookieStorage.shared.cookies?.forEach({ cookie in
        print("\(cookie.name)  <---> \(cookie.value)")
      })
    }
  }
}.resume()

