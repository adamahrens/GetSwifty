# Reactive Programming in iOS with Combine

Previously to deal with async code we would use NotificationCenter, Timers, Delegates, Operations, Closures, GCD

Main components are Publishers, Subscribers, Operators, Scheduling, Sequencing.

`Publisher` it emits events or values of interest.
`Subscriber` attaches to (via subscribes) to a Publisher to receive the events emitted by the Publisher.

`Publisher` can continue to emit values until they send a completion event or failure event.

Both are `protocols` that have `associatedtype` for Input and Error.

`sink` and `assign` are the two ways to subscribe to a `Publisher`

`Subjects` are used to publish values and help bridge to imperative codebases. You have `PassThrough` and `CurrentValue`

`subscribe(on:)` create the subscription or start the work on the specified scheduler. Do this to specify what schedule they should do the work on. This can be used to perform work on background queues

`receive(on:)` use this to specify the main queue so you can do work on the main when receiving values emitted from a background publisher