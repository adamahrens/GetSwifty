// Copyright (c) 2019 Razeware LLC
// See Copyright Notice page for details about the license.

struct PointValue: CustomStringConvertible {
  var x, y: Int
  
  var description: String {
    return "(\(x), \(y))"
  }
  
  mutating func transpose() {
    (y, x) = (x, y)
  }
}

final class PointReference: CustomStringConvertible {
  var x, y: Int
  
  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
  
  var description: String {
    return "(\(x), \(y))"
  }
  
  func transpose() {
    (y, x) = (x, y)
  }
}

/////////////////////////////////////////////////////////

var pointValues: [PointValue] = [] {
  didSet {
    print("didSet PointValue", pointValues)
  }
}

print("Value Array of Points")
var pv1 = PointValue(x: 10, y: 11)
var pv2 = PointValue(x: 20, y: 21)
pointValues.append(pv1)
pointValues.append(pv2)
pointValues.append(PointValue(x: 30, y: 31))
pv1.x = 50
pointValues[0].x = 25
pointValues[1].transpose()


var pointReferences: [PointReference] = [] {
  didSet {
    print("didSet PointReference", pointReferences)
  }
}
print("Reference Array of Points")
var pr1 = PointReference(x: 10, y: 11)
var pr2 = PointReference(x: 20, y: 21)
pointReferences.append(pr1)
pointReferences.append(pr2)
pointReferences.append(PointReference(x: 30, y: 31))
pr1.x = 50
pointReferences[0].x = -300
pointReferences[1].transpose()
/////////////////////////////////////////////////////////

