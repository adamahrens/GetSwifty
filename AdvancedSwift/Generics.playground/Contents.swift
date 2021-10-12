import UIKit

struct Stack<T>: CustomStringConvertible {
  
  var description: String {
    var display = ""
    for item in storage.reversed() {
      let empty = display.isEmpty
      if !empty {
        display += "^\n"
      }
      
      display += "\(item)\n"
    }
    
    return display
  }
  
  private var storage = [T]()
  
  var top: T? {
    storage.last
  }
  
  var isEmpty: Bool {
    storage.isEmpty
  }
  
  mutating func pop() -> T? {
    storage.popLast()
  }
  
  mutating func push(_ element: T) {
    storage.append(element)
  }
}

extension Stack: ExpressibleByArrayLiteral {
  init(arrayLiteral elements: T...) {
    self.storage = elements
  }
}

/// Generics allow a stack of Ints or Stack of People

struct Person: CustomDebugStringConvertible, CustomStringConvertible {
  var debugDescription: String {
    "\(first) \(last)"
  }
  
  var description: String {
    debugDescription
  }
  
  let first: String
  let last: String
}

var intStack = Stack<Int>()
var personStack = Stack<Person>()

intStack.push(1)
intStack.push(2)
print(intStack.top)
print(intStack)

personStack.push(Person(first: "Adam", last: "Ahrens"))
personStack.push(Person(first: "Francis", last: "Ahrens"))
personStack.push(Person(first: "Claudia", last: "Ahrens"))
print(personStack.top)
print(personStack)

var doubleStack: Stack = [2.1, 6.9, 45.0]


/// Need the Generic Constraint of Number so we know how to add
func add<T: Numeric>(_ a: T, _ b: T) -> T {
  a + b
}

print(add(4, 5))
