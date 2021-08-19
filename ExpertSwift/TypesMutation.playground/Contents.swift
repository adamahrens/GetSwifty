import UIKit

struct StructPoint {
  var x: Double
  var y: Double
}

class ClassPoint {
  var x: Double
  var y: Double
  
  init(x: Double, y: Double) {
    (self.x, self.y) = (x, y)
  }
}

// These implementations have 5 differences

// 1. Struct provides an automatic initializer passed on the properties within.
//    A Class forces you to implement one.

// 2. Struct has value semantics vs. Class has references semenatics. By point a new variable at the
//    struct you can mutate either one independently. The class will point to the same value in memory thus
//    causing it to mutate when changed via either variable.


// 3. Scope of mutation is different between the struct and class. By using a let for a struct variable it forces it not to be mutated. You'd have to specify it as a var. However if you specify the class as a let you're still able to mutate it

let classMutation = ClassPoint(x: 1.0, y: 1.0)
classMutation.x = 2.0 // This wouldn't work with a let struct

// However if you were to specify the Class properties as all let then they couldn't be modified

class ClassPointImmutable {
  let x: Double
  let y: Double
  
  init(x: Double, y: Double) {
    (self.x, self.y) = (x, y)
  }
}

let classImmutable = ClassPointImmutable(x: 1.0, y: 1.0)
// classImmutable.x = 2.0 // Cannot assign let is a constant

let structImmutable = StructPoint(x: 1.0, y: 1.0)
// structImmutable.x = 2.0 // Cannot assign let is a constant
var structMutable = StructPoint(x: 1.0, y: 1.0)
structMutable.x = 2.0

print(structMutable)

// 4. Classes use heap memory by Structs/Enums use stack memory. Stack memory is EXTREMELY fast compared to heap memory. The heap memory is shared by mutliple threads and has to be protected from concurrency locks.

// 5. Structs living on the stack are cheap and tend to have a lifetime (once the stack is cleared it's gone) to copy. References have a lifetime to them and eventually get a deinit call. So classes are using reference counting to determine when something can be deinit

// Other notable differences. Classes support inheritance and dispatch their methods dynamically. Pro tip to mark classes as final to speed up the lookup by devirtualizing and the compiler can even help optimize if it knows the class can't have ovverriden methods or subclasses.

struct Point: Equatable {
  var x, y: Double
}

extension Point {
  
  /// Inverts the x and y values
  func flipped() -> Self {
    Point(x: y, y: x)
  }
  
  /// Inverts but mutates the original struct
  mutating func flip() {
    /*
    let temp = self
    x = temp.y
    y = temp.x
    */
    
    // Can simplify it with
    // Great pattern if you don't want to duplicate logic between mutating and nonmutating functions
    self = flipped()
  }
}

/// Equatable causes Swift to generate the == for structs. For classes you have to write your own.
struct Size: Equatable {
  var width, height: Double
}

/// Basically a CGRect
struct Rectangle: Equatable {
  var origin: Point
  var size: Size
}

// Types can server as their own documentation. Both are right angles by defined as radians vs degrees

let a = Measurement(value: .pi / 2, unit: UnitAngle.radians)
let b = Measurement(value: 90, unit: UnitAngle.degrees)
print(a+b)

// Swift allows extending functionality to types you don't even own

typealias Angle = Measurement<UnitAngle>

extension Angle {
  init(radians: Double) {
    self = Angle(value: radians, unit: .radians)
  }
  
  init(degrees: Double) {
    self = Angle(value: degrees, unit: .degrees)
  }
  
  // Computed Properties for returning radians and degress
  var radians: Double {
    converted(to: .radians).value
  }
  
  var degrees: Double {
    converted(to: .degrees).value
  }
}

let myAngle = Angle(degrees: 245)

print(myAngle.degrees)
print(myAngle.radians)

let degree90 = Angle(degrees: 90)
print(degree90.degrees)
print(degree90.radians)

// We typically use RawRepresentable with enums but we can also use it as type checks in inits for structs
struct Email: RawRepresentable {
  var rawValue: String
  
  init?(rawValue: String) {
    guard
      rawValue.contains("@")
    else { return nil }
    
    self.rawValue = rawValue
  }
}

// Exercises
let liters = Measurement(value: 1.5, unit:  UnitVolume.liters)
print(liters)
let cups = liters.converted(to: .cups)
print(cups)
