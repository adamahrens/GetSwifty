// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import Foundation
//: # Create AsyncOperation
extension AsyncOperation {
  // TODO: Create State enum and keyPath
  enum State: String {
    case ready, executing, finished
    
    fileprivate var keyPath: String {
      "is\(rawValue.capitalized)"
    }
  }
}

// Foundation for all async operations
class AsyncOperation: Operation {
  // TODO: Create state management
  // Must trigger KVO changes in the baseclass
  var state = State.ready {
    willSet {
      willChangeValue(forKey: state.keyPath)
      willChangeValue(forKey: newValue.keyPath)
    }
    
    didSet {
      didChangeValue(forKey: state.keyPath)
      didChangeValue(forKey: oldValue.keyPath)
    }
  }
  
  // TODO: Override properties
  override var isExecuting: Bool {
    state == .executing
  }
  
  override var isFinished: Bool {
    state == .finished
  }
  
  // Only used when running the operation outside of OperationQueue
  // ensures it goes to a background thread
  override var isAsynchronous: Bool {
    true
  }
  
  // TODO: Override start
  override func start() {
    if isCancelled {
      state = .finished
      return
    }
    
    state = .executing
    main()
  }
  
  override func cancel() {
    state = .finished
  }
}
/*:
 `AsyncSumOperation` simply adds two numbers together asynchronously and assigns the result. It sleeps for two seconds just so that you can
 see the random ordering of the operation.  Nothing guarantees that an operation will complete in the order it was added.
 */
final class AsyncSumOperation: AsyncOperation {
  let rhs: Int
  let lhs: Int
  var result: Int?
  
  init(lhs: Int, rhs: Int) {
    self.lhs = lhs
    self.rhs = rhs
    
    super.init()
  }
  
  override func main() {
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 2)
      self.result = self.lhs + self.rhs
      self.state = .finished
    }
  }
}
/*:
- important:
What would happen if you forgot to set `state` to `.finished`?
*/
//:
//: Now that you have an `AsyncOperation` base class and an `AsyncSumOperation` subclass, run it through a small test.
let queue = OperationQueue()
let pairs = [(2, 3), (5, 3), (1, 7), (12, 34), (99, 99)]

pairs.forEach { pair in
  // TODO: Create an AsyncSumOperation for pair
  let operation = AsyncSumOperation(lhs: pair.0, rhs: pair.1)
  operation.completionBlock = {
    guard let result = operation.result else { return }
    print("\(operation.lhs) + \(operation.rhs) = \(result)")
  }

  // TODO: Add the operation to queue
  queue.addOperation(operation)
}

// This prevents the playground from finishing prematurely.
// Never do this on a main UI thread!
queue.waitUntilAllOperationsAreFinished()
PlaygroundPage.current.finishExecution()
