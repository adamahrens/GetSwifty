/// Sample code from the video course, Higher-Order Functions in Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!

import Algorithms

/// ------------------------------------------------------
/// starter data
/// ------------------------------------------------------

let artists = gameLibrary.flatMap(\.artists)
/// ------------------------------------------------------


// MARK: - filter
print("-------- Solo Games --------")
let solo = gameLibrary.filter { g in g.playerCount.lowerBound == 1}
solo.forEach { print($0.description) }



// MARK: - sorted
print("-------- Sorted by Ratings --------")
func rankGames(_ game1: Game, _ game2: Game) -> Bool {
  (game1.rating, game2.name) > (game2.rating, game1.name)
}

let sorted = gameLibrary.sorted(by: rankGames(_:_:))
sorted.forEach { print($0.ratingDescription) }

// MARK: - Uniqued


// MARK: - reduce vs. reductions
print("-------- Total Play Time --------")
let totalPlayTime = gameLibrary.reduce(0) { runningTotal, game in
  runningTotal + game.playTime
}

print(totalPlayTime / 60)

// MARK: - Dictionaries
print("-------- Play Time by Category --------")

