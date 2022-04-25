//
//  Contact.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

struct Contact: Codable {
  let email: String?
  let phone: String?
  let address: Address
}

struct Address: Codable {
  let address1: String?
  let address2: String?
  let city: String?
  let state: String?
  let postcode: String?
  let country: String?
}
