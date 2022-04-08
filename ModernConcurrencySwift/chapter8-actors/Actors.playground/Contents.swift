import UIKit

extension Int {
  var nanoseconds: UInt64 {
    UInt64(self * 1_000_000_000)
  }
}
// Makes it thread safe
actor Counter {
  private(set) var count = 0
  
  func increment() {
    count += 1
  }
}

let counter = Counter()

func update(counter: Counter) async {
  let random = Int.random(in: 1...3)
  try? await Task.sleep(nanoseconds: random.nanoseconds)
  await counter.increment()
}

Task {
  // These run in parallel but Counter is thread safe
  await update(counter: counter)
  await update(counter: counter)
  await update(counter: counter)
  await update(counter: counter)
  let count = await counter.count
  print("Current count is \(count)")
}
