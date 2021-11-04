# SwiftUI by Tutorials

If the `UI` should update when a `SwiftUI` view's values cahnges then use the `@State` property. Then the `@State` value changes the view invalidates and recomputes what it should look like

Use `@Binding var yourData: Bool` instead of `@State` when you have reusable views that don't own that data.

Referring to `object.property` is read only. Using `$object.property` is a read-write binding

`Modifiers` take in a view, change it, and return a new view. Therefore the order in which you apply modifiers can make a difference. For example applying a `border` and then `padding` is different than `padding` and applying `border`