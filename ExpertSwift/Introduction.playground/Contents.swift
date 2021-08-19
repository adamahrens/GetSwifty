import UIKit
import Foundation

/// Building a custom feature for Swift
/// ifelse feature from R

/// Generic function to work for any time
//func ifelse<T>(_ condition: Bool, _ valueTrue: T, _ valueFalse: T) -> T {
//  condition ? valueTrue : valueFalse
//}

let value = ifelse(.random(), 100, 0)
print(value)

enum User {
  case unknown
  case valid(first: String)
}

let user = ifelse(.random(), User.valid(first: "Adam"), User.unknown)

/// However what if they were expensive operations
/// Using @autoclosure causes the compiler to wrap arguments in closure automatically
/// Allows us to pass a function to call or a simple value to result it to
/// Adding @inlinable hints to the comiler that the body of the method should be direclty included in client code
/// Prevents the overhead of calling a function and using lookup tables

@inlinable
func ifelse<T>(_ condition: Bool, _ valueTrue: @autoclosure () -> T, _ valueFalse: @autoclosure () -> T) -> T {
  condition ? valueTrue() : valueFalse()
}

let expensive1 = {
  User.valid(first: "Adam")
}

let expensive2 = {
  User.unknown
}


let result = ifelse(.random(), expensive1(), expensive2())
print(result)
