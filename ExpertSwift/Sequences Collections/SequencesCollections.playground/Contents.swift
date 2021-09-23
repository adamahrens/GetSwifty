import UIKit

struct CountdownIterator: IteratorProtocol {
  private(set) var count: Int
  
  mutating func next() -> Int? {
    //Ensure we can countdown
    guard count >= 0 else { return nil }
    
    // Update count after returning the next count.
    defer { count -= 1 }
    
    return count
  }
}

struct Countdown: Sequence {
  let start: Int
  
  func makeIterator() -> CountdownIterator {
    CountdownIterator(count: start)
  }
}

// For will create the iterator for you
for next in Countdown(start: 5) {
  print("Counting down \(next)...")
}

/// Contrived to make our own when we could use Stride to make an iterator for us
print("--- Using stride ---")
for next in stride(from: 5, through: 0, by: -1) {
  print("Stride down \(next)...")
}


print("--- Using UnfoldFirstSequence ---")
let countdown = sequence(state: 5) { (state: inout Int) -> Int? in
  defer { state -= 1 }
  return state >= 0 ? state : nil
}

for next in countdown {
  print("UnfoldFirstSequence down \(next)...")
}

print("\n\n--- Challenges ---")

let array = ["a", "tale", "of", "two", "cities"]
let anySequence = AnySequence(array)


extension Sequence {
  func countingDown() -> [(Int, Element)] {
    enumerated().reversed().map { ($0.offset, $0.element) }
  }
}

print(array.countingDown())


/// Collections
print("\n\n--- Collections ---")

struct FizzBuzz: Collection {

  
  typealias Index = Int
  
  var startIndex: Int { 1 }
  var endIndex: Int { 101 }
  
  func index(after i: Int) -> Int {
    i + 1
  }
  
  subscript(index: Index) -> String {
    precondition(indices.contains(index), "Out of 1 to 100")
    let result = (multiple3: index.isMultiple(of: 3), multiple5: index.isMultiple(of: 5))
    switch result {
      case (false, false):
        return String(index)
        
      case (true, false):
        return "Fizz"
        
      case (false, true):
        return "Buzz"
        
      case (true, true):
        return "FizzBuzz"
    }
  }
}


let fixBuzz = FizzBuzz()
for value in fixBuzz {
  print(value, terminator: "\n")
}
print()

/// Can use all kinds of collection methods

let fizzBuzzLocations = fixBuzz.enumerated().reduce(into: [Int]()) { list, item in
  if item.element == "FizzBuzz" {
    list.append(item.offset + fixBuzz.startIndex)
  }
}

print("All FizzBuzz locations are... ")
print(fizzBuzzLocations)
