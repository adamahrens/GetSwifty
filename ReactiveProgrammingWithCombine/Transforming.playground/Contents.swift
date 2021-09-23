import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "collect") {
  [1, 2, 3, 4, 5]
    .publisher
    .collect() // Be cognizant of memory. Takes emitted events and publishes them to an array
//    .map { $0.reduce(0, +) }
    .sink { value in
      print("Next value >>> \(value)")
    }.store(in: &subscriptions)
}

example(of: "map") {
  let formatter = NumberFormatter()
  formatter.numberStyle = .spellOut
  
  [200, 1.99, 35, 1234]
    .publisher
    // Map can return optionals, use compactMap to remove those
    .compactMap { formatter.string(from: NSNumber(value: $0)) }
    .sink { value in
      print("Next value >>> \(value)")
    }.store(in: &subscriptions)
  
  // Map can return optionals, use compactMap to remove those
  [200, 1.99, 35, 1234]
    .publisher
    .map { formatter.string(from: NSNumber(value: $0)) }
    .sink { value in
      print("Next value >>> \(value)")
    }.store(in: &subscriptions)
}

example(of: "replaceNil") {
  // Use to replace values that return nil with a default value
  ["A", nil, "C", "D", nil]
    .publisher
    .replaceNil(with: "?")
    .compactMap { $0 }
    .sink { value in
      print("Next value >>> \(value)")
    }.store(in: &subscriptions)
}

example(of: "replaceEmpty") {
  // Publisher must since a finished event in order to use replaceEmpty
  let empty = Empty<Int, Never>()
  
  // Might use replaceEmpty with default values
  empty
    .replaceEmpty(with: 100)
    .sink { value in
      print("Next value >>> \(value)")
    }.store(in: &subscriptions)
}

example(of: "scan") {
  // Allows build from previous emitted values
  var dailyWeightLoss: Int {
    .random(in: -5...6)
  }
  
  let timeline = (1...31)
    .map { _ in dailyWeightLoss}
    .publisher
  
  timeline
    .scan(195, { latest, current in
      max(0, latest + current)
    })
    .sink { value in
    print("Next value >>> \(value)")
  }.store(in: &subscriptions)
}


example(of: "flatMap") {
  // Allows taking output from one publisher
  // Common is to ubscribe to properties that are publishers themselves
  
  struct Chatter {
    let name: String
    let message: CurrentValueSubject<String, Never>
    
    init(name: String, message: String) {
      self.name = name
      self.message = CurrentValueSubject(message)
    }
    
    func send(message: String) {
      self.message.value = "\(name): \(message)"
    }
  }
  
  // Think of a chatroom
  let roy = Chatter(name: "roy", message: "roy: What up")
  let trix = Chatter(name: "trix", message: "trix: woof woof")
  
  let chatroom = CurrentValueSubject<Chatter,Never>(roy)
  
  chatroom
    .flatMap { $0.message }
    .sink { value in
      print(">>> \(value)")
    }.store(in: &subscriptions)
  
  chatroom.value = trix
  
  // We are subscribed to publisher of each cahtter
  roy.send(message: "Anyone here?")
  trix.send(message: "Woof!!!!")
  roy.send(message: "Awesome great to see you!!")
}


example(of: "filter") {
  (1...30)
    .publisher
    .filter { $0.isMultiple(of: 3) }
    .sink{ value in
      print(">>> \(value) is multiple of 3")
    }.store(in: &subscriptions)
}

example(of: "removeDuplicates") {
  // Useful when emitted values conform to Equatable
  ["these", "these", "arent", "the", "the", "the", "droids"]
    .publisher
    .removeDuplicates()
    .collect()
    .map { $0.joined(separator: " ") }
    .sink{ value in
      print(">>> \(value)")
    }.store(in: &subscriptions)
}

example(of: "compactMap") {
  // Use to remove nil values that could be emitted
  ["1", "22.2", "hello"]
    .publisher
    .compactMap { Float($0) }
    .sink{ value in
      print(">>> \(value)")
    }.store(in: &subscriptions)
}
/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
