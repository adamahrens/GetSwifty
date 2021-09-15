# iOS Concurrency with GCD and Operations

## Getting Started

Concurrency is simply more than one task running at the same time where a task could be saving data, downloading an image, updating a tableview. 

Concurrency allows apps to be super responsive such as a tableview with images. Download the images in the background and update when available.

Structure the app to safely allow tasks to run at the same time. Ensure thread safety.

`Thread` is where a task runs. They are the lowest level of execution and appear in Xcode's debug navigation (select the CPU).

GCD is Apple's libdispatch library. It provides 5 globabl dispatch queues. These run on threads and provide a higher level. So they're `FIFO` since it's a queue.

They can run more than one instruction at a time and finish out of order (depends on the workload)

Operations is another level of abstraction on top of GCD. They give you the ability to add dependencies between operations and various state variables for KVO.

Concurrent vs Serial. Synchronous vs Asynchronous. Combine & RxSwift

Dispatch Queues

> DispatchQueue.main // used for the main thread only
> // Below are the concurrent queues that run multiple threads at once
> // Quality of Service allows the Scheduler to determine how important the work is
> DispatchQueue.global(qos: .userInteractive) // High
> DispatchQueue.global(qos: .userInitiated) // Tasks started by the User from tapping on something
> DispatchQueue.global(qos: .utility) // Long running tasks with activity indicators, network, saving data
> DispatchQueue.global(qos: .background) // Low user might not be aware of it (prefetching, backups, sending analytics, etc)

Use `DispatchWorkItem` for simply dependency management and cancelling.

A private dispatch queue `DispatchQueue(label: "my serial queue")` is a serial queue by default, need to pass in atrributes to make it concurrent

Several Reactive Frameworks exists to wrap the apis of `Timers`, `NotificationCenter`, `Delegate`, `Operations`, `Closures` and `GCD`

Combine is on iOS 13 and later.

## Grand Central Dispatch

We'll learn about `DispatchGroup`, wrapping async function to be synchronous, `DispatchSemaphore`

Concurrency is inheritly challengings as task don't run the same way each time. Need to watch out for Deadlocks(Locks on resources the results in circular dependency) or Data Races (ATM 1& 2 accessing shared resource). Priority Inversion is when a low priority task blocks resouces that are needed by a high priority resource.

Swift Arrays and Dictionaries are not thread safe. How to make a class thread safe?

Edit the Xcode Scheme Diagnositics to include Thread Sanitizer that can help find some of these data race issues.

`DispatchGroup` are used to dispatch tasks to queue but run them as a group. The `notify` callback is used to specifiy a queue and callback when all the tasks have completed.

Wrap async function with `enter` and `leave` calls. For example images downloaded with URLSessions.

`DispatchSemaphore` was used to control access to number of resources. How many things can execute at once. You use `wait` to start it and `signal` when it's not longer needed.

## Operations I

Operations allow you to wrap up units of work. Usually you subclass `Operation` to make reusable bodies of work. Override the `main` methhod to execute the work. An Operation has several states `isReady` -> `isExecuting` which can then go to `isCancelled` or `isFinished`. Run operations by calling `start` on it.

Can use the default `BlockOperation` that allows passing it a closure. `BlockOperations` run concurrently. If you want serial you need to add to a private serial queue.

Operations is a bit better than GCD. It allows more dependency 

The real power of operations is when used with `OperationQueue` then you don't have to call start yourself. `OperationQueue` handle the scheduling and dependencies for you.

To make an `OperationQueue` serial set it's `maxConcurrentOperationCount` to `1`.

You add operations via a closure or subclass of `Operation`

To use an async task (URLSession.shared.dataTask) in an `Operation` you need to manage some of the state yourself. Requires `KVO` and use a custom state to set to finished.

## Operations II

Be careful with using dependencies. Could create a deadlock.

CoreData is not thread safe. Any `NSManagedObject` can not be shared across threads. Ensure you said up parent/child context relationship. When using callbacks use the parent to look up the entity by the objectId.