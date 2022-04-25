//
//  AnimalAttributes.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

struct AnimalAttributes: Codable {
  let spayedNeutered: Bool
  let houseTrained: Bool
  let declawed: Bool?
  let specialNeeds: Bool
  let shotsCurrent: Bool
}
