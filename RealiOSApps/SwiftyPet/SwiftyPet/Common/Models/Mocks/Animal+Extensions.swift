//
//  Animal+Extensions.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

extension Animal {
  /// Loads local json file of type Animal
  static let mocks = loadAnimals()
}

private struct AnimalsMock: Codable {
  let animals: [Animal]
}

private func loadAnimals() -> [Animal] {
  guard
    let url = Bundle.main.url(forResource: "AnimalsEndpoint",withExtension: "json"),
    let data = try? Data(contentsOf: url)
  else { return [] }
  
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  let jsonMock = try! decoder.decode(AnimalsMock.self, from: data)
  return jsonMock.animals
}
