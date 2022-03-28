# View Protocol

Each view is a value type. The protocol requires the body property returns `some View`

# Modifiers

Modifiers are applied to Views that change it and return a new View. Order of applying modifiers can affect the end result. An example would be to add a border then padding vs padding then a border.

Also depending on the modifier it returns concrete views or `some View`. For example `.resizable()` modifier on an `Image` returns an `Image`

# State & Binding

`@State` is declared in views that can be updated. When `@State` changes views will become rerendered. `@Binding` is like state that has `read/write` access but doesn't have ownership. Typically this is used when `@State` value in a parent view is passed to a child view. This is all pass by reference to `@State` so there is a single source of truth

# StateObject
