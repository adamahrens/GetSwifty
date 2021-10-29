import UIKit

// FizzBuzz Collection

struct FizzBuzz: RandomAccessCollection {
  typealias Index = Int
  
  var startIndex: Index {
    1
  }
  
  var endIndex: Index {
    101
  }
  
  func index(after i: Index) -> Index {
    i + 1
  }
  
  func index(before i: Index) -> Index {
    i - 1
  }
  
  subscript(position: Index) -> String {
    print("Debug subsript", position)
    precondition(indices.contains(position), "out of range")
    
    let tuple = (mult3: position.isMultiple(of: 3), mult5: position.isMultiple(of: 5))
    switch tuple {
      case (false, false):
        return String(describing: position)
      case (true, false):
        return "Fizz"
      case (false, true):
        return "Buzz"
      case (true, true):
        return "FizzBuzz"
    }
  }
}

print("-------- Default FizzBuzz Collection ----")
for value in FizzBuzz() {
  print(value)
}


print("-------- DropFirst ----")
FizzBuzz().dropFirst(11).first!

print("-------- Reversed FizzBuzz ----")

// Still has to visit all the elements just to get the last 5
// Make it a BiDirectionalCollection

for value in FizzBuzz().reversed().prefix(5) {
  print(value)
}

// Now make it a RandomAcccessCollection
// So we can call count without visiting all elements
print("-------- Count FizzBuzz ----")
print(FizzBuzz().count)

struct Array2D<Element>: BidirectionalCollection, MutableCollection {

  typealias Index = Array2DIndex
  
  let width: Int
  let height: Int
  
  private var storage: [Element]
  
  var startIndex: Index {
    Index(x: 0, y: 0)
  }
  
  var endIndex: Index {
    Index(x: 0, y: height)
  }
  
  func index(before i: Index) -> Index {
    if i.x > 0 { return Index(x: i.x - 1, y: i.y) }
    precondition(i.y > 0)
    return Index(x: i.x + 1, y: i.y)
  }
  
  func index(after i: Index) -> Index {
    if i.x < width - 1 { return Index(x: i.x + 1, y: i.y) }
    return Index(x: 0, y: i.y + 1)
  }
  
  subscript(position: Index) -> Element {
    get {
      precondition(inBounds(index: position), "out of bounds \(position)")
      return storage[position.y * width + position.x]
    }
    
    set {
      precondition(inBounds(index: position), "out of bounds \(position)")
      storage[position.y * width + position.x] = newValue
    }
  }
  
  subscript(x x: Int, y y: Int) -> Element {
    get {
      self[Index(x: x, y: y)]
    }
    
    set {
      self[Index(x: x, y: y)] = newValue
    }
  }
  
  func inBounds(index: Index) -> Bool {
    (0..<width).contains(index.x) && (0..<height).contains(index.y)
  }
  
  struct Array2DIndex: Comparable {
    var x: Int
    var y: Int
    
    static func < (lhs: Array2D<Element>.Array2DIndex, rhs: Array2D<Element>.Array2DIndex) -> Bool {
      (lhs.y < rhs.y) || (lhs.y == rhs.y && lhs.x < rhs.y)
    }
  }
  
  init(width: Int, height: Int, repeating value: Element) {
    self.width = width
    self.height = height
    self.storage = Array(repeating: value, count: width * height)
  }
}

extension Array2D {
  func row(_ y: Int) -> AnySequence<Element> {
    var index = Index(x: 0, y: y)
   
    return AnySequence<Element> {
      AnyIterator<Element> {
        guard index.x < self.width else { return nil }
        defer { index.x += 1 }
        return self[index]
      }
    }
  }
  
  func columns(_ x: Int) -> AnySequence<Element> {
    var index = Index(x: x, y: 0)
    
    return AnySequence<Element> {
      AnyIterator<Element> {
        guard index.y < self.height else { return nil }
        defer { index.y += 1 }
        return self[index]
      }
    }
  }
}

print("-------- Array2D ------")

var array = Array2D(width: 4, height: 3, repeating: "-")
array[x: 0, y: 0] = "X"
array[x: 2, y: 1] = "O"

for items in array.row(0) {
  print(items)
}

for items in array.columns(0) {
  print(items)
}

let random = Array(1...20).shuffled()
let evens = random.lazy.filter { $0.isMultiple(of: 2) }
print(type(of: evens))
print(evens)

let fizzBuzz = FizzBuzz()
let buzzes = fizzBuzz.lazy.filter { $0 == "Buzz" }
print("Number of buzzes \(buzzes.count)")
