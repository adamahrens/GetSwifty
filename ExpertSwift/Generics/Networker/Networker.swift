/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation
import Combine
import UIKit

protocol NetworkingDelegate: AnyObject {
  func headers(for networking: Networking) -> [String: String]

  func networking(
    _ networking: Networking,
    transformPublisher: AnyPublisher<Data, URLError>
  ) -> AnyPublisher<Data, URLError>
}

extension NetworkingDelegate {
  func headers(for networking: Networking) -> [String: String] {
    [:]
  }

  func networking(
    _ networking: Networking,
    transformPublisher publisher: AnyPublisher<Data, URLError>
  ) -> AnyPublisher<Data, URLError> {
    publisher
  }
}

protocol Networking {
  var delegate: NetworkingDelegate? { get set }
  func fetch<R: Request>(_ request: R) -> AnyPublisher<R.Response, Error>
  func fetchWithCache<R: Request>(_ request: R) -> AnyPublisher<R.Response, Error> where R.Response == UIImage
  func fetch<M: Decodable>(url: URL) -> AnyPublisher<M, Error>
}

final class Networker: Networking {
  
  weak var delegate: NetworkingDelegate?
  
  private let decoder = JSONDecoder()
  private let imageCache = RequestCache<UIImage>()

  func fetch<R: Request>(_ request: R) -> AnyPublisher<R.Response, Error> {
    var urlRequest = URLRequest(url: request.url)
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.allHTTPHeaderFields = delegate?.headers(for: self)

    var publisher = URLSession.shared
      .dataTaskPublisher(for: urlRequest)
      .compactMap { $0.data }
      .eraseToAnyPublisher()

    if let delegate = delegate {
      publisher = delegate.networking(self, transformPublisher: publisher)
    }
    
    return publisher
      .tryMap(request.decode)
      .eraseToAnyPublisher()
  }
  
  func fetchWithCache<R: Request>(_ request: R) -> AnyPublisher<R.Response, Error> where R.Response == UIImage {
    if let response = imageCache.response(for: request) {
      return Just<R.Response>(response)
        .print()
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    return fetch(request)
      .handleEvents(receiveOutput: { [weak self] in
        self?.imageCache.cache($0, for: request)
      })
      .eraseToAnyPublisher()
  }
  
  func fetch<M>(url: URL) -> AnyPublisher<M, Error> where M : Decodable {
    URLSession.shared
      .dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: M.self, decoder: decoder)
      .eraseToAnyPublisher()
  }
}
