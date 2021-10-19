import UIKit

struct PointValue {
  var x: Int
  var y: Int
}

final class PointReference {
  var x: Int
  var y: Int
  
  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

do {
  let p1 = PointValue(x: 10, y: 12)
  var p2 = p1
  
  // This will only affect p2 instance, p1.x will still be 10
  p2.x = 100
  
  dump(p1)
  dump(p2)
}

print("---------------")


do {
  let p1 = PointReference(x: 10, y: 12)
  let p2 = p1
  
  // Cant since it's specified as a constant.
  // p1 = PointReference(x: 100, y: 100)
  // This will only affect both since they'll reference the same area of memory
  // So p1.x == p2.x which will both be 100
  p2.x = 100
  
  dump(p1)
  dump(p2)
}


struct Tracked<V>: CustomDebugStringConvertible {
  private var _value: V
  private(set) var readCount = 0
  private(set) var writeCount = 0
  
  init(_ value: V) {
    self._value = value
  }
  
  mutating func reset() {
    readCount = 0
    writeCount = 0
  }
  
  var debugDescription: String {
    "\(_value) R:\(readCount), W:\(writeCount)"
  }
  
  // Computed property for updating the read/write
  
  var value: V {
    mutating get {
      readCount += 1
      return _value
    }
    
    // Set is implicitly mutating which is why it doesn't need the modifier
    set {
      writeCount += 1
      _value = newValue
    }
  }
}


func computeNothing(input: inout Int) {
  print("computeNothing")
}

func compute100Time(input: inout Int) {
  print("compute100Time")
  
  for _ in 1...100 {
    input += 1
  }
}


var tracked = Tracked(42)

// Still has one read/write
// inout copies the value in, modifies it, copies it out.
computeNothing(input: &tracked.value)
print("ComputedNothing", tracked)


tracked.reset()

compute100Time(input: &tracked.value)
print("Compute100Time", tracked)
