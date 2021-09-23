//: [Previous](@previous)

import UIKit

let data = API.getData(for: .magicTheGathering)

let decoder = JSONDecoder()
do {
  let cards = try decoder.decode([Card].self, from: data)
  for card in cards {
    print("🃏 \(card.name) #\(card.number), cost \(card.manaCost)")
  }
} catch {
  print("Something went wrong: \(error)")
}

struct Card: Decodable {
  let id: UUID
  let name: String
  let type: String
  let text: String
  let number: String
  let flavor: String?
  let imageUrl: URL?
  let manaCost: Mana
}

// We're trying to decode a string of "manaCost": "{3}{W}{W}" to a strongly typed object

extension Card {
  struct Mana: Decodable, CustomStringConvertible {
    let colors: [Color]
    var description: String { colors.map(\.symbol).joined() }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer() // Arent dealing with keys
      let cost = try container.decode(String.self)
      
      colors = try cost
        .components(separatedBy: "}")
        .dropLast()
        .compactMap { rawCost in
          // Removes the { at the front
          let symbol = String(rawCost.dropFirst())
          guard !symbol.isEmpty, let color = Color(symbol: symbol) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown mana symbol of \(symbol)")
          }
          
          // Symbol and Color is valid
          return color
        }
    }
  }
}

extension Card.Mana {
  enum Color {
    case colorless(Int)
    case extra, white, blue, black, red, green
    
    var symbol: String {
      switch self {
        case .colorless(let number): return "\(number)"
        case .extra:
          return "X"
        case .white:
          return "W"
        case .blue:
          return "U"
        case .black:
          return "B"
        case .red:
          return "R"
        case .green:
          return "G"
      }
    }
    
    init?(symbol: String) {
      if let value = Int(symbol) {
        self = .colorless(value)
        return
      }
      
      switch symbol.lowercased() {
        case "x":
          self = .extra
        case "w":
          self = .white
        case "u":
          self = .blue
        case "b":
          self = .black
        case "r":
          self = .red
        case "g":
          self = .green
        default:
          print("Unknown \(symbol)")
          return nil
      }
    }
  }
}

//: [Next](@next)

/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

