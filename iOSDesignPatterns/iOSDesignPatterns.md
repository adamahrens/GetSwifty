# MVC

Model View Controller. Can lead to Massive View Controller problem as you have a lot of overlapping in code that just goes in the controller.

Potential solution is MVC-N where the N stands for Networking. NetworkClient handles making requests and delivering Models to ViewController.

# MVVM

ViewModel great place to manipulate models. ViewModels communicates with the View Controller. Transforms it into a View representation.

# Multicast Closure Delegate

Spin off pattern from delegate. Instead of one it can have many. Accepts closures that it can call multiple delegates. 

Use an `NSMapTable` has a constructor for weak to strong happens. Prevents circular references between the multi cast and the delegates. Otherwise we'd have to remember to unregister them

# Memento Pattern

Captures & Externalizes State (Basically saves and stores stuff)

Combosed of 3 things 

1. Orginator (does encoding such as converting Struct to Json)
2. Memento ( the object, model, that's meant to be encoded)
3. CareTaker (stores the encoded Memento)

Use case would be encoding stuff into UserDefaults

# Composition over Subclassing

Depend on abstractions instead of details. So pass in protocols to inits to dependency inject an abstraction

# Container Views

DRY things up if views are extremely similar

# Vistor

