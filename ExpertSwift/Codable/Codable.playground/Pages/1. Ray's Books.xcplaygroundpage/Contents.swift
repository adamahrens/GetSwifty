//: [Previous](@previous)

import UIKit
import PlaygroundSupport

struct Book: Decodable {
  let id: String
  let name: String
  let authors: [String]
  let storeLink: URL // differs from store_link in json. Handle it yourself or use decodingStrategy
  let imageBlob: Data
  
  // Computed Property
  var image: UIImage? {
    UIImage(data: imageBlob)
  }
}

// let data = API.getData(for: .rwBooks) // use snake_case_for_keys
let data = API.getData(for: .rwBooksKebab) // use kebab-case-for-keys

// Since we're using kebab-case we need a custom key coding strategy

struct AnyCodingKey: CodingKey {
  let stringValue: String
  let intValue: Int?
  
  init?(stringValue: String) {
    self.stringValue = stringValue
    intValue = nil
  }
  
  init?(intValue: Int) {
    self.intValue = intValue
    stringValue = "\(intValue)"
  }
}

extension JSONDecoder.KeyDecodingStrategy {
  static var convertFromKebabCase: JSONDecoder.KeyDecodingStrategy = .custom { keys in
    let codingKey = keys.last!
    let key = codingKey.stringValue
    
    guard key.contains("-") else { return codingKey }
    let words = key.components(separatedBy: "-")
    
    // Removes all the -, appends every word after the first
    // Converting to camelCase
    let camelCased = words[0] + words[1...].map(\.capitalized).joined()
    
    // Use our custom AnyCodingKey wrapper
    return AnyCodingKey(stringValue: camelCased)!
  }
}

let decoder = JSONDecoder()
//decoder.keyDecodingStrategy = .convertFromSnakeCase // converts keys like store_link to storeLink
decoder.keyDecodingStrategy = .convertFromKebabCase

decoder.dataDecodingStrategy = .base64 // Used if we have properties of type Data in our structs

do {
  let books = try decoder.decode([Book].self, from: data)
  print("--- Example decoding books.json ---")
//  print(books)
  
  var images = [UIImage]()
  for book in books {
    print("\(book.name) \(book.id) by \(book.authors.joined(separator: ", ")) found at \(book.storeLink)")
    if let i = book.image {
      images.append(i)
    }
  }
} catch {
  print("Error occurred while decoding. \(error)")
}


//: [Next](@next)

/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

