import CoreGraphics
import Foundation

struct Circle {
  var origin: CGPoint
  var radius: CGFloat
}

let circle = Circle(origin: .zero, radius: 10)
let rectangle = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))

/// We need a common API between the struct we control and the one we don't CGRect
/// Assuming we have an array of shapes and we won't to determine the area for all of them
/// One way would be a new Protocol that both our types implement


protocol Geometry {
  func area() -> Double
  
  
  /// Challenge Add Perimeter Support
  func perimeter() -> Double
}

extension Circle: Geometry {
  func area() -> Double {
    Double(.pi * radius * radius)
  }
  
  func perimeter() -> Double {
    Double(2 * .pi * radius)
  }
}

extension CGRect: Geometry {
  func area() -> Double {
    Double(size.width * size.height)
  }
  
  func perimeter() -> Double {
    Double((size.width + size.height) * 2)
  }
}

let geometricItems: [Geometry] = [circle, rectangle]
let totalArea = geometricItems.reduce(0.0) { $0 + $1.area() }
print(totalArea)

let totalPerimter = geometricItems.reduce(0.0) { $0 + $1.perimeter() }
print(totalPerimter)
