/// Sample code from the video course, Higher-Order Functions in Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!

import Foundation

let result = gameLibrary.map { $0.name }
print(result)

print("--------")

let keyPathResult = gameLibrary.map(\.name)
print(keyPathResult)
print("--------")

// Flattens array of arrays
let allDesigners = gameLibrary.flatMap(\.designers)
print(allDesigners)
print("--------")

let artists = gameLibrary.flatMap(\.artists).compactMap(PersonNameComponentsFormatter().personNameComponents)
print(artists)
print("--------")
