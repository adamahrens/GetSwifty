With multi core we can run multiple threads in parallel 

With Grand Central Dispatch you add blocks of code or work items to `dispatch queues` 

GCD executs code in a first in first out order with dispatch to a `DispatchQueue`. These are thread safe.

Queues can be serial or concurrent. Serial means the queue only runs one task at a time. Concurrent means it can run multiple at a time.

GCD comes with three main queue types

`Main` runs on the main thread and is serial

`Global Queues` concurrent queues used by the whole system. They are broken up into 4 sub types `high`, `default`, `low`, and `background`

When using those global queues and dispatching work to it you specify the `QoS` or Quality of Service.

`User-interactive: This represents tasks that must complete immediately to provide a nice user experience. Use it for UI updates` this maps to `high` above

`User-initiated: The user initiates these asynchronous tasks from the UI` this maps to `default` above

`Utility: This represents long-running tasks, typically with a user-visible progress indicator. Use it for computations, I/O, networking,` this maps to `low` above

`Background: This represents tasks the user isn’t directly aware of. Use it for prefetching, maintenance and other tasks that don’t require user interaction and aren’t time-sensitive` this maps to `background` above

You can use `DispatchQueue.sync` or `DispatchQueue.async`. Sync call is blocking and waits for it to complete. Async is not.

# Make Thread Safe Singletons

GCD provides an elegant solution of creating a read/write lock using dispatch barriers

Be careful of deadlocks which is when one or more items — in most cases, threads — deadlock if they get stuck waiting for each other to complete or perform another action