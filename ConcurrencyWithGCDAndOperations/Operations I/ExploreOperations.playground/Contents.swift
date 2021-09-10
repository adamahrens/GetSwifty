// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Explore Operations
//: An `Operation` represents a 'unit of work', and can be constructed as a `BlockOperation` or as a custom subclass of `Operation`.
//: ## BlockOperation
//: Create a `BlockOperation` to add two numbers
var result = 0
// TODO: Create and run sumOperation

let sumOperation = BlockOperation {
  result = 10 + 21
  sleep(5)
}

// Run synchronous so don't call on main queue
duration {
  sumOperation.start()
}

print(result)

//: Create a `BlockOperation` with multiple blocks:
// TODO: Create and run multiPrinter
let multiPrinter = BlockOperation()

multiPrinter.addExecutionBlock {
  print("First Part")
  sleep(4)
}

multiPrinter.addExecutionBlock {
  print("Second part")
  sleep(2)
}

multiPrinter.addExecutionBlock {
  print("Third part")
  sleep(2)
}

multiPrinter.completionBlock = {
  print("All done printing things")
}

// Operation is concurrent so it runs all the blocks concurrently
// they just happened to sometimes come out in the right order
// that makes it doesn't take a total of 6 seconds to run them all
duration {
  multiPrinter.start()
}

PlaygroundPage.current.finishExecution()
