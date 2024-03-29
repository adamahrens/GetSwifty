# Advanced Swift Learning Path

`Class Dispatch` is familiar with Object Oriented Programming. Typical features are Custom Types, Encapsulation, Hides Implementation Detail, Polymorphism.

Dynamic dispatched through a function lookup of a v-table. For example if you have a `Shape` base class and array of `Circle` and `Rectangle` and you call a `draw` method. It has to use the v-table look up to determine the actual function to  call.

Swift allows `Static Dispatch` which is super fast at compile time It can sometimes inline the function so it doesn't have to perform a lookup. `Dynamic Dispatch` is the default for classes. It's dispatched at runtime via a v-table lookup. `Message Dispatch` is used by the `Objc-C` runtime which also allows method swizzling to occur.

`Protocol Oriented Programming`. OOP only allows one super  class, have to use reference semantics instead of value semantics. `Protocols` are a type of blueprint and behavior for types to adopt. We don't have memory layout restrictions.

Instead of a v-table in the array example above, Protocols use a Protocol Witness Table for dynamic dispatch.

Protocols allows retroactive modeling to classes we don't have the source code for.

```
protocol Geometry {
  func area() -> Double
}

extension Circle: Geometry {
  func area() -> Double {
    Double(.pi * radius * radius)
  }
}

extension CGRect: Geometry {
  func area() -> Double {
    Double(size.width * size.height)
  }
}
```

Generics can be used for functions, initializers, structs, enums, and classes. `<>` is used to specify the type.

`Paremetric Polymorphism` is the more formal name for Generics

Generic Constraints for writing algorithms on generic types.

`Associated Types` How to make protocols themselves generic? They can also have their own Constraints

```
protocol Pixel {
    associatedtype Channel: Comparable
}

struct Gray8: Pixel {
    typealias CHannel = UInt8
}
```

`Condtional Conformance` 

`Values vs References`. Value types provide isolation and speed since they're fast to copy. References allow shared ownership.

Action at a distance is the ability to inject a reference type into a value type such as a `struct` which then allows you to manipulate the reference. Great for testing.

`var` vs `let` on a value type immediately dictates if it can be mutated or not. However, with a reference type specifying it as a let just means the pointer in memory won't change.

What happens when you have an array of value type and references.

Every method in a class, struct, or enum gets passed a self param. However, if the method is marked mutating in `struct` and `enum` it's marked as `inout`. This is what triggers the `didSet` calls.

`Law of Exclusivity` is the law restricts a variable from being written too by multiple contexts.

`COW` or Copy On Write. Makes a deep copy to a reference type before you begin to modify. All variables could still reference the same type until a modification needs to occur.

`Hashable` is used for quick O(1) look up in a dictionary. A type that is `Hashable` is also `Equatable`

`Phantom Types` are types that mask a simple type to provide more compiler support but aren't exposed to a public interface. This examples shows it's use case

```
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

typealias State = Named<StateTag>
typealias Capital = Named<CapitalTag>

// This provides better documentation on what the dictionary gives us.
var lookup: [State : Capital] = ["Alabama" : "Montgomery", "Iowa" : "Des Moines", "Minnesota" : "Saint Paul"]

```

When building Custom Operators you have to think about `Name`, `Arity & Position`, `Precedence`, and `Associativity`

`Name` must include symbols and mathmatical operators

Short circuting is the process of evaluating a condition before an expensive operation

` if condition && expensive()`

Here if the condition is false it'll short circuit out and not evluated the result of `expensive`

`Sequence` is the root Protocol. The return a set of values one at a time. Returns a `Iterator` type that has a `next()` that keeps returning values until it has no more and hits a `nil`

`AnySequence` is used to type erase. It essentially builds a new Sequence while hiding the underlying sequence.

`Collections` build off `Sequence` and allow to revist elements. Think index in an Array

`Eager` vs `Lazy`. Use `numbers.lazy.filter` to wrap it in a `LazyCollection` type. This won't perform the filter until it's on demand requested

Swift uses `ARC` automatic reference counting. When a reference count drops to 0 it's `deinited` This provided great resource utilization. However, we have to understand the object graph.

`Weak` is used to break retain cycles as it doesn't increase the reference count. Always used on `var`, always used on an `Optional` type

`Unowned` tells Swift that it also doesn't need to update reference count. However, unowned used with non optionals. So you wouldn't used it for a `delegate`. Unowned is making a strong statement that a parent will outlive a child.

`Closures` are first class types. Swift guarantees memory safety. So Closures copy objects into a private environment. Ensuring variables you access in the body of the closure will increase the reference count for them.

# Unsafe Memory Access

Use unsafe memory if performance is critical and memory references are slowing it down. Could also use it when interfacing with C. It just means the compiler no longer has your back.

```

MemoryLayout<Int>.size // return 8
MemoryLayout<Int>.alignment // returns 8
MemoryLayout<Int>.stride // returns 8
```

Computed properties dont have memory requirements.

# Error Handling

You have `preconditions/asserts` then `Optionals` then `throws` then Swift `Result` type

