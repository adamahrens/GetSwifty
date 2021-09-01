# Expert Swift Book

Working through Expert Swift Book from RayWenderlich.com

## Introduction

Swift compiler turns `.swift` files into object `.o` code. The chain of events is parse -> AST (Abstract Syntax Tree) -> Semantic Analysis -> SILGen -> Swift Intermediate Language (SIL) -> LLVM -> .o files.

This is the process of `lowering` where you take a high level langauge and reduce it to machine code.

Most of the fundamental types are part of the standard library and not baked into the compiler.

Try passing closures to a function to defer execution of it if it is an expensive operation that would only execute if a condition is true

## Types & Mutations

Swift emphasizes `mutable value semantics` 

Structs, Enums, and Classes are fundamental named types that Swift uses to make all other concrete types such as `Bool` and `Int`

Structs/Enums are value types. Classes reference types

Reference Types have a built in notion of lifetime and identity

Instance methods secretly pass in `self`

## Protocols

Allows using of multiple types as the same super-type by hiding information about the underlying types. The protocols hides all other members of the `class` or `struct` expect the ones exposed by the `protocol` itself.

`static` vs `dynamic` dispatch. What happens when a function is called? Swift looks up that function, finds it's address, and executes it. There are two ways to lookup the function. `static` lookup happens when you know for sure the function will never change. That's why we mark things as `final` because they can be used for `static` lookup. In a sense the compiler can hardcode the function. With dynamic the compiler doesn't know so it has to use a v-table to look it up

Swift syntehizes protocol conformance for `Equatable`, `Hashable`, `Comparable`, and `Codable` which consists of `Encodable` and `Decodable`

## Generics

Protocols with associated types makes it a requirement of the Protocol instead of a generic type like for a function. Swift needs a concrete type to work with at compile-time. But what if you want an array of `Protools with Associated Types` ? You have to use `type erasure`

`Self` is always an alias to the concrete type of the scope it appears in. It is always a concrete type. `self` on the other hand is straightforward except when in a class or static methods.

Key things are using `<>` to add generic parameters to functions or structs. You can even make a `protocol` generic with an `associatedtype`
`self` has the value of the current type in static methods & computed properies

You can use `generic constraints` in extensions with a `where` clause i.e. `where T == UIImage`

Use `type erasure` to use generics and protocol with associated types as regular types. Swift already uses this a lot such as `AnyPublisher`, `AnySequence` or `AnyView`

## Numerics & Ranges

## Sequences, Collections, & Algorithms

## Strings

## Codable

## Unsafe

## High Order Functions

## Functional Reactive Programs

## Instrumentation

## API Design Tips & Tricks