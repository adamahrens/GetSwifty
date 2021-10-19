import UIKit

// Since it's a value type
// Compiler will generance equtable conformance for us!
// struct Email: Equatable {

// Making is Hashable guarantees Equtable as well
struct Email: Hashable {
  private(set) var address: String
  
  // Can only init a valid email
  // Can't modify it outside of init
  init?(_ raw: String) {
    guard raw.contains("@") else { return nil }
    address = raw
  }
}


// Compiler Error with Equatable. It can't auto generate for a reference type
// Could generate a circular infintie loop dependency
// Hence we have to implement ourselves. Just simply check all the properties of the type
//final class User: Equatable {

final class User: Hashable {
  var id: Int?
  var name: String
  var email: Email
  
  init(id: Int?, name: String, email: Email) {
    self.id = id
    self.name = name
    self.email = email
  }
  
  static func ==(lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id && lhs.name == rhs.name && lhs.email == rhs.email
  }
  
  // Super nice for adding Hashable
  func hash(into hasher: inout Hasher) {
    
    // Good practice to pass all the properties you use in the ==
    hasher.combine(id)
    hasher.combine(name)
    hasher.combine(email)
  }
}

guard let email = Email("adam@ahrens.com") else { fatalError() }

let user1 = User(id: 20, name: "Adam", email: email)
let user2 = User(id: 20, name: "Adam", email: email)

// == for Equality
user1 == user2

// === for checking if same reference
user1 === user2

let user3 = user1
user1 === user3



// Use a phantom type to wrap a value

struct Named<T>: Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
  var name: String
  
  init(_ name: String) {
    self.name = name
  }
  
  init(stringLiteral value: StringLiteralType) {
    name = value
  }
  
  var description: String {
    name
  }
}

// Phantom Types because they're never referred to in the public interface

enum StateTag {}
enum CapitalTag {}

// Improvement but not ideal
//typealias State = String
//typealias Capital = String

typealias State = Named<StateTag>
typealias Capital = Named<CapitalTag>

// This provides better documentation on what the dictionary gives us.
var lookup: [State : Capital] = ["Alabama" : "Montgomery", "Iowa" : "Des Moines", "Minnesota" : "Saint Paul"]

// However since they're strings compiler doesn't help if we write bad code such as

func printStateAndCapital(_ state: State, _ capital: Capital) {
  print("Capital of \(state) is \(capital)")
}

func unitTest() {
  let iowa = State("Iowa")
  guard let capital = lookup[iowa] else { return }
  
  // However since they're strings compiler doesn't help if we write bad code such as
  // Event with our Typealias to clean it up
  printStateAndCapital(iowa, capital)
}

unitTest()


// Custom operators

infix operator +/-: RangeFormationPrecedence

@inlinable func +/-<T: FloatingPoint>(lhs: T, rhs: T) -> ClosedRange<T> {
  let positive = abs(rhs)
  return ClosedRange(uncheckedBounds: (lower: lhs-positive, upper: lhs+positive))
}

let plusOrMinus = 10.0 +/- 0.5
print(plusOrMinus)
