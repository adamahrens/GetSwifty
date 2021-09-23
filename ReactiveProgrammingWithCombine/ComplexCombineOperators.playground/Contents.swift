import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "switchToLatest") {
  
  let first = PassthroughSubject<String, Never>()
  let second = PassthroughSubject<String, Never>()
  let third = PassthroughSubject<String, Never>()
  
  let mainPublisher = PassthroughSubject<PassthroughSubject<String, Never>, Never>()
  
  mainPublisher
    .switchToLatest()
    .sink { value in
      print("Next >>> \(value)")
    }.store(in: &subscriptions)
  
  mainPublisher.send(first)
  first.send("A")
  first.send("B")
  
  // Once a switch occurs
  // the previous publisher is cancelled
  // no other values sent will emit
  mainPublisher.send(second)
  first.send("C")
  second.send("2A")
  second.send("2B")
  
  mainPublisher.send(third)
  second.send("2C")
  third.send("3A")
  third.send("3B")
  
  third.send(completion: .finished)
  mainPublisher.send(completion: .finished)
}

example(of: "merge") {
  let first = PassthroughSubject<Int, Never>()
  let second = PassthroughSubject<Int, Never>()
  
  first
    .merge(with: second)
    .sink { value in
      print("Next >>> \(value)")
    }.store(in: &subscriptions)
  
  first.send(0)
  first.send(1)
  second.send(2)
  second.send(3)
  first.send(4)
  second.send(5)
  first.send(6)
  
  first.send(completion: .finished)
  second.send(completion: .finished)
}

example(of: "combineLatest") {
  // Allows combining publishers of different types
  let ints = PassthroughSubject<Int, Never>()
  let strings = PassthroughSubject<String, Never>()
  
  ints
    .combineLatest(strings)
    .sink { value in
      print("Next >>> \(value)")
    }.store(in: &subscriptions)
  
  
  // This takes the latest value emitted from each publisher when new ones are sent
  // which is why the first combination printed will be 2A, then 2B, then 3C
  ints.send(1)
  ints.send(2)
  strings.send("A")
  strings.send("B")
  strings.send("C")
  ints.send(3)
  strings.send("D")
  
  ints.send(completion: .finished)
  strings.send(completion: .finished)
}

example(of: "zip") {
  // Similiar to combineLatest expected it pairs them up according
  // To the index at which they would fire to match them
  let ints = PassthroughSubject<Int, Never>()
  let strings = PassthroughSubject<String, Never>()
  
  ints
    .zip(strings)
    .sink { value in
      print("Next >>> \(value)")
    }.store(in: &subscriptions)
  
  
  // This takes the latest value emitted from each publisher when new ones are sent
  // which is why the first combination printed will be 2A, then 2B, then 3C
  ints.send(1)
  ints.send(2)
  strings.send("A")
  strings.send("B")
  strings.send("C")
  ints.send(3)
  strings.send("D") // this gets ignored because it's attempting to match
  strings.send("E")
  ints.send(4)
  
  ints.send(completion: .finished)
  strings.send(completion: .finished)
}

/*
 Copyright (c) 2019 Razeware LLC

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 distribute, sublicense, create a derivative work, and/or sell copies of the
 Software in any work that is designed, intended, or marketed for pedagogical or
 instructional purposes related to programming, coding, application development,
 or information technology.  Permission for such use, copying, modification,
 merger, publication, distribution, sublicensing, creation of derivative works,
 or sale is expressly withheld.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
