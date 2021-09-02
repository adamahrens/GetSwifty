// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Create Asynchronous Functions
//:
//: Global queues:
let userQueue = DispatchQueue.global(qos: .userInitiated)
let defaultQueue = DispatchQueue.global()
//: A slow synchronous function:
func slowAdd(_ input: (Int, Int)) -> Int {
  sleep(2)
  return input.0 + input.1
}
//: To use it only once, keep it simple:
// TODO: Dispatch slowAdd to userQueue

userQueue.async {
  let result  = slowAdd((10, 10))
  print(result)
}

//: You'll modify `slowAdd` to return a `Result` that's either an `Int`, or this specific error type, `Slow-add-error`:
enum SlowAddError: Error {
  case notEnoughFingers
}
//: Define `slowAddPlus` to return `Result` instead of `Int`.
//: Flip a coin to decide whether to return success or failure.
// TODO
func slowAddPlus(_ input: (Int, Int)) -> Result<Int, SlowAddError> {
  sleep(2)
  let random = Bool.random()
  
  return random ? .success(input.0 + input.1) : .failure(.notEnoughFingers)
}
//: Check `slowAddPlus` works:
// TODO: Dispatch slowAddPlus on userQueue
userQueue.async {
  let result = slowAddPlus((5, 5))
  switch result {
    case .success(let result):
      print(result)
    case .failure(let error):
    print("SlowAddPlus Error \(error)")
  }
}

sleep(3)

// Comment out the next line before running the Reusable task exercise.
// PlaygroundPage.current.finishExecution()
//: ### 2. Reusable task
//: Wrap the `async` dispatch as an asynchronous function, with arguments for the input, queues and completion handler, and default values for the two queues.
//:
//: __Note:__ In an app, you would return to the main queue, but that doesn't work in playgrounds.
// TODO: Create asyncAdd function
func asyncAdd(_ input: (Int, Int),
  runQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
  completionQueue: DispatchQueue = DispatchQueue.main,
  completion: @escaping (Result<Int, SlowAddError>) -> ()) {

  // First performs calculations on background queue
  runQueue.async {
    let result = input.0 + input.1
    let randomResult = Bool.random()
    let finalResult = randomResult ? Result.success(result) : Result.failure(SlowAddError.notEnoughFingers)
    
    // Calls completion queue (which is main)
    completionQueue.async {
      completion(finalResult)
      PlaygroundPage.current.finishExecution()
    }
  }
}
//: Call `asyncAdd` with default queues. The completion handler
//: is in a trailing closure, and uses a `switch` block:
// TODO

asyncAdd((6, 6)) { result in
  print("Result of asyncAdd")
  switch result {
    case .success(let result):
      print(result)
    case .failure(let error):
      print("SlowAddPlus Error \(error)")
  }
  
  PlaygroundPage.current.finishExecution()
}






