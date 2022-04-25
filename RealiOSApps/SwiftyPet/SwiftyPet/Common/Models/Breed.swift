//
//  Breed.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

struct Breed: Codable {
  let primary: String
  let secondary: String?
  let mixed: Bool
  let unknown: Bool
}
