# Reactive Programming in iOS with Combine

Previously to deal with async code we would use NotificationCenter, Timers, Delegates, Operations, Closures, GCD

Main components are Publishers, Subscribers, Operators, Scheduling, Sequencing.

`Publisher` it emits events or values of interest.
`Subscriber` attaches to (via subscribes) to a Publisher to receive the events emitted by the Publisher.

`Publisher` can continue to emit values until they send a completion event or failure event.

Both are `protocols` that have `associatedtype` for Input and Error.

`sink` and `assign` are the two ways to subscribe to a `Publisher`

`Subjects` are used to publish values and help bridge to imperative codebases