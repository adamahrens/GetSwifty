//: [Previous](@previous)

import Foundation
import Combine
import SwiftUI

struct TypeWriterIterator: AsyncIteratorProtocol {
  typealias Element = String
  let phrase: String
  
  private var index: String.Index
  
  init(_ phrase: String) {
    self.phrase = phrase
    index = phrase.startIndex
  }
  
  /// AsyncIteratorProtocol
  mutating func next() async throws -> String? {
    guard index < phrase.endIndex else { return nil }
    
    /// Random sleep to indicate a process taking a certain amount of time
    /// Think if we had to fetch data from a network
    /// or a variable length process such as reading various file sizes
    try await Task.sleep(nanoseconds: UInt64.random(in: 1000000000...2000000000))
    
    defer {
      index = phrase.index(after: index)
    }
    
    return String(phrase[phrase.startIndex...index])
  }
}

struct TypeWriter: AsyncSequence {
  typealias Element = String
  
  let phrase: String
  
  /// AsyncSequence Protocol
  func makeAsyncIterator() -> TypeWriterIterator {
    return TypeWriterIterator(phrase)
  }
}

let typeWriter = TypeWriter(phrase: "To infinity, and BEYOND!")

Task.detached(priority: .userInitiated) {
  for try await portion in typeWriter {
    print(portion)
  }
}


/// What if we didn't want to keep adding new types for Async Sequence
/// Apple has AsyncStream that provides a closure
///

var phrase = "Careful man there's a beverage here"
var index = phrase.startIndex
let stream = AsyncStream<String> {
  guard index < phrase.endIndex else { return nil }
  
  do {
    try await Task.sleep(nanoseconds: UInt64.random(in: 1000000000...2000000000))
  } catch {
    return nil
  }
  
  defer {
    index = phrase.index(after: index)
  }
  
  return String(phrase[phrase.startIndex...index])
}

Task.detached(priority: .userInitiated) {
  for try await portion in stream {
    print(portion)
  }
}

//: [Next](@next)
