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

## Operations I

## Operations II