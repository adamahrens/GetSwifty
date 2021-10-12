import UIKit
import Foundation

class Distribution {
  
  /// Virtual Method with Virtual Dispatch
  func sample() -> Double {
    fatalError("Must override in subclass")
  }
  
  func sample(count: Int) -> [Double] {
    (1...count).map { _ in sample() }
  }
}

final class UniformDistribution: Distribution {
  
  let range: ClosedRange<Int>
  
  init(range: ClosedRange<Int>) {
    self.range = range
  }
  
  override func sample() -> Double {
    Double(Int.random(in: range))
  }
}

/// Roll 20 sided dice, 10 times.
/// Using Dynamic lookup to match the type with the method to run. In this case `sample`
let d20 = UniformDistribution(range: 1...20)
print(d20.sample(count: 10))


class GeometryBase {
  func area() -> Double {
    fatalError("Subclass must impelemtn")
  }
}

/// However this won't be put into the v-table
extension GeometryBase {
  
  /// Now we can override in subclasses because it'll be inferred.
  /// Specifying @objc gives it Messaging Dispatch
  /// If we specify a subclass as final we give it dynamic dispatch.
  /// Since the compiler can make some inferences.
  @objc func perimeter() -> Double {
    fatalError("")
  }
}


protocol DistributionProtocol {
  func sample() -> Double
  func sample(count: Int) -> [Double]
}

/// Can still add default implementations
extension DistributionProtocol {
  func sample(count: Int) -> [Double] {
    (1...count).map { _ in sample() }
  }
}

/// Now we can use value types (struct)
struct UniformDistributionValueType: DistributionProtocol {
  let range: ClosedRange<Int>
  
  func sample() -> Double {
    Double(Int.random(in: range))
  }
}

let d20Again = UniformDistributionValueType(range: 1...20)
print(d20Again.sample(count: 10))

// Count all 10 roles
print("Number of roles that were a 10")
print(d20Again.sample(count: 100).reduce(0) { $0 + ($1 == 10 ? 1 : 0) })
