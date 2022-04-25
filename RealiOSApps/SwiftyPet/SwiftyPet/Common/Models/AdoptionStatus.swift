//
//  AdoptionStatus.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

enum AdoptionStatus: String, Codable {
  case adoptable
  case adopted
  case found
  case unknown
}
