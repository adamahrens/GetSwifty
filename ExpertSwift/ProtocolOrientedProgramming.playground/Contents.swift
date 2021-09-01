//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Combine

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

protocol Endpoint {
  var basePath: String { get }
  var path: String { get }
}

extension Endpoint {
  var basePath: String { return "https://api.raywenderlich.com/api" }
}

protocol Request {
  associatedtype Response
  var method: HTTPMethod { get }
  var urlRequest: URLRequest { get }
  var headers: [String : String] { get }
  
  func response(_ data: Data) throws -> Response
}

protocol DataRequest: Request {
  var endpoint: Endpoint { get }
}

extension Request {
  var headers: [String : String] {
    [:]
  }
}

extension Request where Response: Decodable {
  func decode(_ data: Data) throws -> Response {
    try JSONDecoder().decode(Response.self, from: data)
  }
}

extension DataRequest {
  var urlRequest: URLRequest {
    let url = URL(string: endpoint.basePath + "/" + endpoint.path)!
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers
    return request
  }
}

struct ArticleEndpoint: Endpoint {
  var path: String { "contents?filter[content_types][]=article" }
}

struct ArticleRequest: DataRequest {
  func response(_ data: Data) throws -> ArticleResponse {
    try JSONDecoder().decode(ArticleResponse.self, from: data)
  }
  
  let endpoint: Endpoint = ArticleEndpoint()
  let method = HTTPMethod.get
  
  var headers: [String : String] {
    ["Content-Encoding" : "application/json"]
  }
}

struct ArticleResponse: Codable {
  let data: [Article]
}

struct ImageRequest: Request {

  let url: URL
  
  // MARK: Request
  var urlRequest: URLRequest {
    return URLRequest(url: url)
  }
  
  var method: HTTPMethod { .get }
  
  func response(_ data: Data) throws -> UIImage {
    guard
      let image = UIImage(data: data)
    else { throw ImageError.invalidData }
    
    return image
  }
  
  enum ImageError: Error {
    case invalidData
  }
}

extension Data {
  /// Pretty Printed version of JSON Data if the Data can be serialized
  var prettyPrinted: String {
    guard
      let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
      let encodedPretty = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
    else { return "" }
    
    return String(data: encodedPretty, encoding: .utf8) ?? "unable to pretty print"
  }
}

struct Article: Codable {
  let id: String
  let technology: String
  let name: String
  let subtitle: String
  let author: String
  let artwork: URL
  
  /// Custom decoder to flatten the json structure
  init(from decoder: Decoder) throws {
    let outer = try decoder.container(keyedBy: RootKeys.self)
    let attributes = try outer.nestedContainer(keyedBy: AttributeKeys.self, forKey: .attributes)
    id = try outer.decode(String.self, forKey: .id)
    technology = try attributes.decode(String.self, forKey: .technology)
    name = try attributes.decode(String.self, forKey: .name)
    subtitle = try attributes.decode(String.self, forKey: .subtitle)
    author = try attributes.decode(String.self, forKey: .author)
    
    let artworkString = try attributes.decode(String.self, forKey: .artwork)
    artwork = URL(string: artworkString)!
  }
  
  enum RootKeys: CodingKey {
    case id, attributes
  }
  
  enum AttributeKeys: String, CodingKey {
    case subtitle = "description"
    case name
    case technology = "technology_triple_string"
    case author = "contributor_string"
    case artwork = "card_artwork_url"
  }
}

extension Article: CustomStringConvertible {
  var description: String {
    return "\(id): \(name) - \(subtitle) by \"\(author)\". [\(technology)]"
  }
}

/// Protocol Oriented Programming for Networking Library
/// Allows dependency inversion. Allows mocking for testing
protocol Networking {
  func request<R: Request>(_ request: R) -> AnyPublisher<R.Response, Error>
}

protocol NetworkingHeadersDelegate {
  func additionalHeaders<R: Request>(_ request: R) -> [String : String]
}

final class Networker: Networking {
  func request<R>(_ request: R) -> AnyPublisher<R.Response, Error> where R : Request {
    URLSession.shared
      .dataTaskPublisher(for: request.urlRequest)
      .compactMap { $0.data }
      .handleEvents(receiveOutput: { data in
        print("Request \(request.urlRequest) -> \(data.prettyPrinted)")
      })
      .tryMap(request.response)
      .eraseToAnyPublisher()
  }
  
//  func request<R: Request>(_ request: R) -> AnyPublisher<R.Response, Error> {
//    return URLSession.shared
//      .dataTaskPublisher(for: request.urlRequest)
//      .compactMap { $0.data }
//      .handleEvents(receiveOutput: { data in
//        print("Request \(request.urlRequest) -> \(data.prettyPrinted)")
//      })
//      .tryMap(request.response)
//      .eraseToAnyPublisher()
//  }
}

var subscriptions = Set<AnyCancellable>()
let network = Networker()
let request = ArticleRequest()

let articles = network
  .request(ArticleRequest())
  .map { $0.data }
  .share()

articles
  .compactMap { $0.first?.artwork }
  .map { ImageRequest(url: $0) }
  .flatMap { request in
    network
      .request(request)
      .receive(on: OperationQueue.main)
  }
  .sink { completion in
    print("Completion Result \(completion)")
  } receiveValue: { obj in
    print("Received \(obj)")
    let image = obj
    print(image)
  }.store(in: &subscriptions)

articles.sink { completion in
  print("Completion Result \(completion)")
} receiveValue: { articles in
  print("Received Articles \(articles)")
}.store(in: &subscriptions)

final class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
