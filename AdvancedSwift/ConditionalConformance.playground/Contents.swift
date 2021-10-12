import Foundation

struct Pair<Element> {
  let first: Element
  let second:Element
}

extension Pair {
  var flipped: Pair { Pair(first: second, second: first) }
}

// Conform to protocol but only conditionally
// The generic types have to be equatable to so Pair can be equatable
extension Pair: Equatable where Element: Equatable {
  
}

extension Pair: Comparable where Element: Comparable {
  static func < (lhs: Pair<Element>, rhs: Pair<Element>) -> Bool {
    lhs.first < rhs.second
  }
}

/// Challenge Codeable And Hashable for Pair type

extension Pair: Codable where Element: Codable {
  
}

extension Pair: Hashable where Element: Hashable {
  
}

// Change to allow non Comparable elements to support Orderable
//protocol Orderable {
//  associatedtype Element
//  func min() -> Element
//  func max() -> Element
//  func sorted() -> Self
//}

protocol Orderable {
  associatedtype Element
  func min() -> Element
  func max() -> Element
  func sorted() -> Self
}

// Conform to Protocol if conditions for Elements conform to another Protocol
extension Pair: Orderable where Element: Comparable {
  func min() -> Element {
    first < second ? first : second
  }
  
  func max() -> Element {
    first > second ? first : second
  }
  
  func sorted() -> Pair<Element> {
    first < second ? Pair(first: first, second: second) : Pair(first: second, second: first)
  }
}

// So if we had a Pair of Bools we couldn't even write the min and max. Compiler would complain
// Because the conditions for the Orderable Protocol aren't met.
