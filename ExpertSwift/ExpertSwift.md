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

## Generics

## Numerics & Ranges

## Sequences, Collections, & Algorithms

## Strings

## Codable

## Unsafe

## High Order Functions

## Functional Reactive Programs

## Instrumentation

## API Design Tips & Tricks