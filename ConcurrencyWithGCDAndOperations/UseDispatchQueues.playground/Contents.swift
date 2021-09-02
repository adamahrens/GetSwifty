// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
//: Specify indefinite execution to prevent the playground from killing background tasks when the "main" thread has completed.
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let sleepDuration = UInt32(integerLiteral: 3)
//: # Use Dispatch Queues
//: ## Using a Global Queue
// TODO: Get the .userInitiated global dispatch queue
let userQueue = DispatchQueue.global(qos: .userInitiated)

// TODO: Get the .default global dispatch queue
let defaultQueue = DispatchQueue.global()

// TODO: Get the main queue
let mainQueue = DispatchQueue.main

//: Some simple tasks:
func task1() {
  print("Task 1 started")
  // make task1 take longer than task2
  sleep(2)
  print("Task 1 finished")
}

func task2() {
  print("Task 2 started")
  print("Task 2 finished")
}

print("=== Starting userInitated global queue ===")

// TODO: Dispatch tasks onto the userInitated queue
duration {
  
  // Tasks will run concurrently
  userQueue.async {
    task1()
  }

  userQueue.async {
    task2()
  }
}

sleep(sleepDuration)
//: ## Using a Private Serial Queue
//: The only global serial queue is `DispatchQueue.main`, but you can create a private serial queue. Note that `.serial` is the default attribute for a private dispatch queue:
// TODO: Create mySerialQueue

let serialQueue = DispatchQueue(label: "com.appsbyahrens.serial")


print("\n=== Starting mySerialQueue ===")
// TODO: Dispatch tasks onto mySerialQueue
duration {
  serialQueue.async {
    task1()
  }
  
  serialQueue.async {
    task2()
  }
}

sleep(sleepDuration)
//: ## Creating a Private Concurrent Queue
//: To create a private __concurrent__ queue, specify the `.concurrent` attribute.
// TODO: Create workerQueue

let workerQueue = DispatchQueue(label: "com.appsbyahrens.private.concurrent", attributes: .concurrent)

print("\n=== Starting workerQueue ===")
// TODO: Dispatch tasks onto workerQueue

duration {
  workerQueue.async {
    task1()
  }
  
  workerQueue.async {
    task2()
  }
}

sleep(sleepDuration)
//: ## Dispatching Work _Synchronously_
//: You have to be very careful calling a queue’s `sync` method because the _current_ thread has to wait until the task finishes running on the other queue. **Never** call sync on the **main** queue because that will deadlock your app!
//:
//: But sync is very useful for avoiding race conditions — if the queue is a serial queue, and it’s the only way to access an object, sync behaves as a _mutual exclusion lock_, guaranteeing consistent values.
//:
//: We can create a simple race condition by changing `value` asynchronously on a private queue, while displaying `value` on the current thread:
var value = 42

func changeValue() {
  sleep(1)
  value = 1
}
//: Run `changeValue()` asynchronously, and display `value` on the current thread
// TODO
// .sync is great for avoiding data races. Say we were writing to a database.

print("\n=== Starting serialQueue changeValue async ===")
serialQueue.async {
  changeValue()
}

// However the main thread continued working
// so it would show as 42 since it was never changed
print("+++ Change Value = \(value) +++")

sleep(sleepDuration)

value = 42

print("\n=== Starting serialQueue changeValue sync ===")
serialQueue.sync {
  changeValue()
}

// Now we called sync which waits for the function to return before continuing execution on main
print("+++ Change Value = \(value) +++")
//: Now reset `value`, then run `changeValue()` __synchronously__, to block the current thread until the `changeValue` task has finished, thus removing the race condition:
// TODO




// Allow time for sleeping tasks to finish before letting the playground finish execution:
sleep(3)
PlaygroundPage.current.finishExecution()
