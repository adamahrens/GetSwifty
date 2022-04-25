//
//  PhotoSizes.swift
//  SwiftyPet
//
//  Created by Adam Ahrens on 4/24/22.
//

import Foundation

struct PhotoSizes: Codable {
  let small: URL
  let medium: URL
  let large: URL
  let full: URL
}
