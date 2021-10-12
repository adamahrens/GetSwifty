# Beginning CoreData

Used for storing data permanently, cache temporary data, or handling undo. 

Combination of object graph manager and persistence manager. The object graph is the various models (Books, Authors, Genres) and how they relate to each other.

To save, update, delete them you need the persistence framework to handle that.

`ManagedObject` is like a Swift class but it's a representation of the data stored in the persistence layer. `NSManagedObject` is basically a dictionary.

`NSEntityDescription` is used to determined what container to write the data to. Since under the hood it's mostly key-value pairs.

`Managed Object Model` is the list of all the entities you're able to persistent and appears in Xcode's graph editor. A `Managed Object` is the individual entties that appear in the graph.

`NSManagedObjectContext` is a scratch pad that tracks the models/entities you're currently creating/updating/deleting. All these changes aren't persisted until you call `save` explicity. All `NSManagedObject` must be registered with a `NSManagedObjectContext`.

`NSManagedObjectContext` follows the command pattern. Context -> Record of Changes -> Persistence Layer

`NSPersistentStoreCoordinator` sits between the context and the persistent store. The coordinator is responsble for creating the entities that will be saved to disk. It follows the facade patttern.

MangedObjectModel that has an attribute as transient won't be saved to disk. However this can be similar to a computed property if needed.

`Use Sclar Type` determines if you're going to work with primitive types vs objects. Such as working with an `Int` instead of `NSNumber`

You can work with `NSManagedObject` subclasses by writing your own or having Xcode autogenerate them.

Using `@NSManaged` generates the getter/setters for the properties

To pull data out of the store you need a `NSFetchRequest` and it must contain an entity description

Order of the `NSSortDescriptor` you put into the sortDescriptors property of the `NSFetchRequest` are honored. First it sorts by the first, then second, third, etc

`NSPredicate` class is used to filter results even more. NSPredicate has it's own formatting language for filtering. For example `NSPredicate(format: "%K == %@", "isCompleted", NSNumber(booleanLiteral: false))` %K is for keyPath.

`NSCommpoundPredicate` to combine with multiple `NSPredicate` instances. Allows easily AND, OR, NOT operations to occur