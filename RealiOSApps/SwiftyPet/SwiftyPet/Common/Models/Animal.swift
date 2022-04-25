//
//  Animal.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

struct APIAnimalsContainer: Decodable {
  let animals: [Animal]
  let pagination: Pagination
}

struct Animal: Codable {
  let id: Int
  let organizationId: String
  let url: URL
  let type: String
  let species: String
  let breeds: Breed
  let colors: Colors
  let age: Age
  let gender: Gender
  let size: Size
  let coat: Coat?
  let name: String
  let description: String?
  let photos: [PhotoSizes]
  let status: AdoptionStatus
  var attributes: AnimalAttributes
  var environment: AnimalEnvironment
  let tags: [String]
  var contact: Contact
  let publishedAt: String
  let distance: Double?
}

extension Animal: Identifiable {}

extension Animal {
  var picture: URL? {
     photos.first?.medium ?? photos.first?.large
   }
}
