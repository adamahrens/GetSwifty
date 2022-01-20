# SwiftUI by Tutorials

If the `UI` should update when a `SwiftUI` view's values cahnges then use the `@State` property. Then the `@State` value changes the view invalidates and recomputes what it should look like

Use `@Binding var yourData: Bool` instead of `@State` when you have reusable views that don't own that data.

Referring to `object.property` is read only. Using `$object.property` is a read-write binding

`Modifiers` take in a view, change it, and return a new view. Therefore the order in which you apply modifiers can make a difference. For example applying a `border` and then `padding` is different than `padding` and applying `border`

SwiftUI helps avoid the Massive View Controller anti pattern of UIKit. It does this because declarative, functional (same state produces same view), and reactive (updating state causes view to rerender)

The other benefit is that it creates a single source of truth. If you had a textfield and a name property in your model. Is the single source of truth the `textfield.text` or `name`? What if they get out of sync.

SwiftUI is then smart enough to only re render parts of the view that are affected by that `@State`

In SwiftUI, components don’t own the data — instead, they hold a reference to data that’s stored elsewhere. This is achieved with `@Binding`. Since a `TextField` doesn't want to own the data, it gets passed along to it.

```
You access a binding by using the $ operator

@State var name: String = ""
TextField("Type your name...", text: $name)

```

```
Using environmentObject(_:), you inject an object into the environment.
Using @EnvironmentObject, you pull an object (actually a reference to an object) out of the environment and store it in a property.
```

Helpful for maintaining a single source of truth.

Use `.constant(challengesViewModel.numberOfAnswered)` .constant if you have computed properties but want to give them binding like behavior.

Object ownership can be complicated with Reference types. Imagine if you pass a `UserManager` to the init of some view A. Whenever A is re-rendered a new `UserManager` is created and passed. It's preferred to store a single instance in a parent view and pass that instance to the child view.

A better way is to use `@StateObject` for refernce types now

```
struct SomeView: View {
  @StateObject var userManager = UserManager()
  ...
}
```