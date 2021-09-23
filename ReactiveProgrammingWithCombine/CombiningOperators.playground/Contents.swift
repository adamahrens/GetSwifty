import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "prepend") {
  let publisher = [3, 4].publisher
  
  publisher
    .prepend(1, 2)
    .sink { value in
      print("Next >>> \(value)")
    }.store(in: &subscriptions)
}


example(of: "prepend with Sequence") {
  let publisher = [5, 6, 7].publisher
  
  publisher
    .prepend(Set(-1...2))
    .prepend([3, 4])
    .sink { value in
      print("Next >>> \(value)")
    }.store(in: &subscriptions)
}

example(of: "preprend with Publisher") {
  // Only works if the prepended publisher
  // Can send a completion event
  // If the second publisher was a passthrough
  // and never sent a completion nothign would run
  let first = [3, 4].publisher
  let second = [1, 2].publisher
  
  first
    .prepend(second)
    .sink { value in
      print("Next >>> \(value)")
    }.store(in: &subscriptions)
}
