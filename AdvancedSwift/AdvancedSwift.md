# Advanced Swift Learning Path

`Class Dispatch` is familiar with Object Oriented Programming. Typical features are Custom Types, Encapsulation, Hides Implementation Detail, Polymorphism.

Dynamic dispatched through a function lookup of a v-table. For example if you have a `Shape` base class and array of `Circle` and `Rectangle` and you call a `draw` method. It has to use the v-table look up to determine the actual function to  call.

Swift allows `Static Dispatch` which is super fast at compile time It can sometimes inline the function so it doesn't have to perform a lookup. `Dynamic Dispatch` is the default for classes. It's dispatched at runtime via a v-table lookup. `Message Dispatch` is used by the `Objc-C` runtime which also allows method swizzling to occur.

`Protocol Oriented Programming`. OOP only allows one super  class, have to use reference semantics instead of value semantics. `Protocols` are a type of blueprint and behavior for types to adopt. We don't have memory layout restrictions.

Instead of a v-table in the array example above, Protocols use a Protocol Witness Table for dynamic dispatch.