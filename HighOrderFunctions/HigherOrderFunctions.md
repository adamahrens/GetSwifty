# Higher Order Functions

A function that takes in a function as a parameter or returns a function. Some examples in Swift is the `ViewBuilder` in SwiftUI. HOF also appear in `Combine`

It aims to make it more 

Functions are compound types, so even if it isnt named it's type is defined by it's method signature.

Swift includes in the standard library higher order such as `map`, `flatMap`, or `compactMap`

flatMap is taking an array of arrays and joins them to a one dimensional array.

Others include `filter`, `sorted`, `uniqued`, `reduce`

`Currying` is when you take a function with multiple params and you break it down into a chain of functions that each take a single param